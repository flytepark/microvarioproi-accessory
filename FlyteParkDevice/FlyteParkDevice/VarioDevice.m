//
//  VarioDevice.m
//  FlyteParkDevice
//
//  Created by Brian Vogel on 8/21/11.
//  Copyright 2011 Techrhythm. All rights reserved.
//

#import "VarioDevice.h"
#import "VarioComm.h"

//

@implementation VarioDevice 

@synthesize queuedPackets;
@synthesize isInitialized;

-(id) initWithDelegate:(NSObject *) delegate
{
        self = [super init];
        if (self) 
        {
            [self initDefaults];

            NSMutableArray* packets = [[NSMutableArray alloc] init];
            [self setQueuedPackets: packets];
            
            [self setDelegate:delegate];
            [self didInitialize];
                                       
            [packets release];                                       

        }
        
        return self;
}

-(id) init
{
        self = [super init];
        if (self) 
        {
            [self initDefaults];
            [self didInitialize];
            
        }

    return self;

}

-(void) initDefaults
{
    lastRealtimePacket = 0;
    packetCounter = 0;
    receivedPacketCounter = 0;
    _responsePending = false;
    _trackError = false;
    _currentTrackAddress = 0x000000;
    _tracksReceived = 0;
    _trackCount = 0;
    _trackPayloadSize =  57; //max size is 58, omitting one byte so all packets will fit in one request.
    _trackEntrySize = 3;
    _bytesRequested = 0;

}


-(void) dealloc
{
    [self.queuedPackets release];
    [super dealloc];
}

-(void) didInitialize
{
    //set up event handlers
    [self attachHandlers];
    commandToValue = [[NSDictionary alloc] init];

}

- (VarioResponse) getExpectedResponse:(VarioCommand)command
{
    VarioResponse response = VR_BAD_COMMAND;
    

    
    if (command == VC_ERASE_FLIGHTS) response= VR_OK;
    else if (command==VC_ERASE_TRACKS) response = VR_OK;
    else if (command==VC_INITIALIZE) response = VR_INITIALIZED;
    else if (command==VC_READ_ID) response = VR_ID;
    else if (command==VC_READ_LOG) response = VR_LOG;
    else if (command==VC_READ_OPTION) response = VR_OPTION;
    else if (command==VC_READ_OPTIONS) response = VR_OPTIONS;
    else if (command==VC_READ_RTC) response = VR_RTC;
    else if (command==VC_READ_TRACK) response = VR_TRACK;
    else if (command==VC_READ_TRACK_LOG_COUNT) response = VR_TRLOG_COUNT;
    else if (command==VC_REALTIME_DATA_MODE) response = VR_REALTIME_DATA;
    else if (command==VC_SET_FACTORY_DEFAULTS) response = VR_OK;
    else if (command==VC_WRITE_OPTION) response = VR_OK;
    else if (command==VC_WRITE_OPTIONS) response = VR_OK;
    
    return response;
}


-(void) attachHandlers
{
    NSLog(@"VarioDevice - Attaching Handlers");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidConnect:) name:EAAccessoryDidConnectNotification object:nil];
    
    //NB: this does not need to be handled because the accessory delegate already handles this
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];   
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    
}

-(void) setDelegate:(NSObject *)target
{
    [super setDelegate:target];
     NSMutableArray* _accessoryList = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];
    
    for (int i=0;i<[_accessoryList count];i++)
    {
        EAAccessory *connectedAccessory =  [_accessoryList objectAtIndex:i];
        [self connectFlyteParkDevice:connectedAccessory];
    }
    
    [_accessoryList release];
    
}

//initialize the controller when the acessory conencts
-(void) accessoryDidConnect:(NSNotification *)notification 
{
    isInitialized=false;
    _responsePending=false;

 
    EAAccessory *connectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    [self connectFlyteParkDevice:connectedAccessory];
}

-(void) connectFlyteParkDevice: (EAAccessory*) connectedAccessory
{
  
    // check to see if it is the Microvario Pro-i, if it is assume we're going ot use the first an only protocol it supports
    if(![self isConnected] && [[connectedAccessory name] isEqualToString:@"Microvario Pro-i"] 
       && [[connectedAccessory protocolStrings] count]>0 )
    {
        //do serial
        NSLog(@"connectFlyteParkDevice: setting up controller");
        NSString *protocol = [[connectedAccessory protocolStrings] objectAtIndex:0];
        [super setupControllerForAccessory:connectedAccessory withProtocolString:protocol ];
        
        //open communcation with this device
        [self openSession];
        
        NSLog(@"Session Opened!");
        
        if([ [self delegate] respondsToSelector:@selector(flyteParkDeviceDidConnect)]) {
            [[self delegate] flyteParkDeviceDidConnect];
        }
        
        //send init sequence
        [self sendCommand:VC_INITIALIZE];

        
    }
    else
    {
    // NSString* debug = [NSString stringWithString:[connectedAccessory name]]  ;
        NSLog(@"-- Begin Microvario Pro Time --");
        NSLog( [connectedAccessory name] );
        NSLog(@"-- End Microvario Pro Time --");
        
    }
    
}


-(void) accessoryDidDisconnect:(EAAccessory *)accessory
{
    //require re-initialization if accessory disconnects
    isInitialized=false;
    _responsePending=false;
    
    [super accessoryDidDisconnect:accessory];
 
    NSLog(@"Session Closed!");        
    NSLog(@"Acessory Disconnected");
    
    if([[self delegate] respondsToSelector:@selector(flyteParkDeviceDidDisconnect)]) {
            [[self delegate] flyteParkDeviceDidDisconnect];
    }
    
}

+(void) dumpData:(NSData *)data
{
    unsigned char* bytes = (unsigned char*) [data bytes];

    for(int i=0;i< [data length];i++)
    {
        NSString* op = [NSString stringWithFormat:@"%d:%X",i,bytes[i],nil];
        NSLog(op);
    }
}


-(void) onStreamOpened
{

}

-(void) _onDataRecieved
{
    [super _onDataRecieved];
    
    [[self delegate] logMessage:@"Dataindahouse"];
    
    //[[self delegate] logMessage:@"Got Data!" ];
    uint32_t bytesAvailable = 0;
    
    
    //packets right now are 128 byres
    while ((bytesAvailable = [self readBytesAvailable]) > 0) 
    {
        NSData *data = [self readData:bytesAvailable];
        
        //NSLog(@"%D bytes data read", bytesAvailable);
        
        //get the packet count
        ushort newPacketCounter;
        [data getBytes:&newPacketCounter range:NSMakeRange([data length]-2,2)];
        
        //the device may send the same packet twice
        //TODO: add stale packet test if needed.
        bool stale = false; //(receivedPacketCounter == newPacketCounter);
        receivedPacketCounter = newPacketCounter;

        unsigned char* bytes = (unsigned char*) [data bytes];

        if (!stale && bytes[0]== GET_MAGIC)
        {
            _responsePending = false;
            VarioResponse response = (VarioResponse) bytes[1];            
            VarioResponse expectedResponse = [self getExpectedResponse:lastCommand];
            

            #if DEBUG
            
            if (expectedResponse!=VR_REALTIME_DATA)
            {
                //[VarioDevice dumpData:data];
            }
            
            #endif
 
            
            if (response == VR_INITIALIZED)
            {
                //vario has initialized
                [self onVarioInitialized];
            }
            else if (isInitialized)
            {
                bool hasErrors = response != expectedResponse;
                
                //send the response to the expected handler
                switch (expectedResponse) {
                        
                    case VR_OK:
                        [self onOk];
                        break;
                    case VR_LOG: 
                        //TODO: handle log
                        //OnReadLog(data, response, hasErrors);
                        break;
                    case VR_REALTIME_DATA:
                        [self onRealtimeData:data];
                        break;
                    case VR_RTC: 
                        //OnTime(data);
                    break;
 
                    case VR_OPTIONS:
                        [self onOptions:data];
                        break;
                    case VR_TRACK: 
                        //OnReadTrack(data, response, hasErrors);
                        break;                        
                        
                    default:
                        break;
                }
                
            }
            
            
                                       
        }
        
        //send out any queued packets that may have accumulated
        if (!_responsePending && [queuedPackets count]>0)
        {
            NSLog(@"Sending packet from queue");
            NSData* packet = [queuedPackets objectAtIndex:0];
 
            unsigned char* bytes = (unsigned char*) [packet bytes];
            lastCommand=bytes[1];
            
            
            _responsePending=TRUE;
            [self writeData:packet];
            [queuedPackets removeObjectAtIndex:0];
            
            //NB: Packet should be retained by array
            //[packet release];
        }
    }
}

-(void) queuePacket:(NSData *)packet
{
    [packet retain];
    [queuedPackets addObject:packet];
}


//specific handlers
-(void) onVarioInitialized
{
    isInitialized = true;
   
    if([[self delegate] respondsToSelector:@selector(varioInitialized)]) {
        [[self delegate] varioInitialized];
    }
    
    //TODO: dispatch notification
}

//handle an OK response
-(void) onOk
{
    switch (lastCommand)
    {
        case VC_SET_VARIO_AUDIO:
            if([[self delegate] respondsToSelector:@selector(setVarioAudioCompleted)]) {
                [[self delegate] setVarioAudioCompleted];
            }          
        break;
        
        case VC_ERASE_FLIGHTS:
            //TODO: dispatch notification
            //if (EraseFlightsCompleted!=null) EraseFlightsCompleted(this, new EventArgs());
            break;
        case VC_ERASE_TRACKS:  
            //TODO: dispatch notification
            //if (EraseTracksCompleted!=null) EraseTracksCompleted(this, new EventArgs());
            break;
        case VC_SET_FACTORY_DEFAULTS:
            //TODO: dispatch notification
            //if (SetFactoryDefaultsCompleted != null) SetFactoryDefaultsCompleted(this, new EventArgs());
            break;            
    }
}


-(void) onRealtimeData:(NSData *)data
{
    //NOTE: There should be a packet counter here but there may not be
    const int RT_PACKET_SIZE=14;
    unsigned char* byteData = (unsigned char*) [data bytes];
    unsigned char* count = byteData;
    
    VarioRealtimeData* realtimeData;
    
    float altitudeTotal = 0.0;
    float climbTotal = 0.0;
    float batteryTotal= 0.0;
    float temperatureTotal=0.0;
    float itemCount = 0.0;
    
    for (int i=0;i<[data length];i+=RT_PACKET_SIZE)
    {
        
        realtimeData=[[[VarioRealtimeData alloc] init] autorelease];        
        
        //realtimeData.altidue =  (*(int32_t*) (count+3)) >> 8; //only 24 bits needed, loose the last byte
        altitudeTotal+= 0x000000 | count[3] | count[4] << 8 | count[5] << 16;
        climbTotal+=  *(short int*) (count+6);
        batteryTotal+= (*(short int*) (count+8));
        temperatureTotal+=  (*(short int*) (count+10));
       
        //11 - checksum not in IAP packet
        
        //counter 12/13
        int packet =  *(short unsigned int*) (count+12);
        itemCount++;
        
        //TODO: re-enable this code.
        if (true)//packet!=lastRealtimePacket)
        {
            lastRealtimePacket = packet;
        }
        
        if (i+RT_PACKET_SIZE<[data length])
        {
            count+=RT_PACKET_SIZE;
        }
        
    }
    
    realtimeData=[[[VarioRealtimeData alloc] init] autorelease];
    
    
    //realtimeData.altidue =  (*(int32_t*) (count+3)) >> 8; //only 24 bits needed, loose the last byte
    [realtimeData setAltitude: altitudeTotal / itemCount];
    [realtimeData setClimb:  climbTotal / itemCount];
    [realtimeData setBatVoltage:  (batteryTotal/itemCount) / 100.0];
    [realtimeData setTemperature:  (temperatureTotal/itemCount)  / 100.00  ];
     
    
    if(  itemCount>0 &&  [[self delegate] respondsToSelector:@selector(realtimeDataReceived:)]) {
        [[self delegate] realtimeDataReceived:realtimeData];
    }

}

-(void) onOptions:(NSData *) data
{
    unsigned char* bytes = (unsigned char*) [data bytes];
    int selectedProfile = (int) bytes[51]; //selected profile index
    void* count = bytes;
    count+=3; //start at altitude offset;
    
    NSMutableArray* optionsList = [[NSMutableArray alloc] init];
    
    
    for(int i=0;i<3;i++)
    {
       VarioOptions* options= [[[VarioOptions alloc] init] autorelease];
       
        //short int altitudeOffset =  * (short int*)count;
        options.climbThreshold =  * (short int*) (count+2);
        options.sinkThreshold =  * (short int*)(count+4);
        options.liftThreshold =  * (short int*)(count+6);
        options.trackLogTrigger = *(unsigned char*) (count+8);
        options.trackLogInterval = *(unsigned char*) (count+9);
        
        options.varioDamping = *(unsigned char*) (count+10);
        options.volume = *(unsigned char*) (count+11);
        options.sampleRate = *(unsigned char*) (count+12);
        options.flags = *(unsigned char*) (count+13);

        [optionsList addObject:options];
       
        //2 pad bytes
        count+=2;
    }
    
    
    NSArray* result = [NSArray arrayWithArray:optionsList];
    [optionsList release];
    
    if([[self delegate] respondsToSelector:@selector(varioOptionsReceived:selectedProfile:)]) {
        [[self delegate] varioOptionsReceived:result selectedProfile:selectedProfile];
    }
    
}


-(void) onVarioError:(NSData *)data
{
        
}

-(void) sendGetOptions
{
    NSLog(@"Read Options");

    [self sendCommand:VC_READ_OPTIONS];
}


- (void) writeOptions: (NSArray*) optionsData selectedProfileIndex: (int) index
{
    NSMutableData* data = [NSMutableData alloc];
 
    for(int i=0;i<3;i++)
    {
        VarioOptions* options= [optionsData objectAtIndex:i];
        
        short int zeroInt = 0;
        short int altitudeOffset = zeroInt;
        short int climbThreshold = options.climbThreshold;
        short int sinkThreshold =  options.sinkThreshold;
        short int liftThreshold =  options.liftThreshold;

        short int trackLogTrigger = options.trackLogTrigger;
        short int trackLogInterval = options.trackLogInterval;
        
        unsigned char varioDamping = options.varioDamping;
        unsigned char volume = options.volume;
        unsigned char sampleRate = options.sampleRate;
        unsigned char flags = options.flags;
        
        [data appendBytes: &altitudeOffset length: sizeof(short int) ];
        [data appendBytes: &climbThreshold length: sizeof(short int) ];
        [data appendBytes: &sinkThreshold length: sizeof(short int) ];
        [data appendBytes: &liftThreshold length: sizeof(short int) ];
        
        [data appendBytes: &trackLogTrigger length: sizeof(unsigned char) ];
        [data appendBytes: &trackLogInterval length: sizeof(unsigned char) ];
        [data appendBytes: &varioDamping length: sizeof(unsigned char)];
        [data appendBytes: &volume length: sizeof(unsigned char)];
        [data appendBytes: &sampleRate length: sizeof(unsigned char)];
        [data appendBytes: &flags length: sizeof(unsigned char) ];

        [data appendBytes: &zeroInt length: sizeof(short int) ];
    }
    
    
    [data appendBytes:&index length:1];
    [self sendCommand:VC_WRITE_OPTIONS payloadData:data];
    
    [VarioDevice dumpData:data];
    
    [data release];
}


//send commands
-(void) sendCommand:(VarioCommand)command 
{
    [self sendCommand:command payloadData:NULL] ;    
}

-(void) sendCommand: (VarioCommand) command  payloadByte: (unsigned char) byte
{
    [self sendCommand:command payloadData:[NSData dataWithBytes:&byte length:1]];  

}
-(void) sendCommand: (VarioCommand) command  payloadData: (NSData*) data
{
    if ( [self isConnected])
    {
            //create the packet
            //Minimum bytes in packet
            //1. MAGIC
            //2. COMMAND
            //3. NBytes
            //5. Checksum            
           
        
            long dataLength =  (data== NULL) ? 0 : [data length];
            
            NSMutableData *buffer; //packet to send
            NSData* counterData = [[NSData alloc] initWithBytes:&packetCounter length:sizeof(int16_t)];   //packet counter bytes
            unsigned char sum = 0; //checksum
            unsigned char packetLength = MIN_PACKET_SIZE + dataLength;     //just the size of the data payload, used for calculating the checksum
            
            //setup packet header
            unsigned char header[3] = {SET_MAGIC,
                (unsigned char) command,
                (unsigned char) packetLength};
            
            
            buffer = [[NSMutableData alloc] initWithBytes:&header length:3];
            
                        
            if (NULL!=data)
            {
             [buffer appendData:data];
            }
            
            //append checksum data
            [buffer appendBytes:&sum length:1];            
            long bufferLength = [buffer length];
            
            
            //calculate checksum
            unsigned char* byteData= (unsigned char*) [buffer bytes];
            
            for (int i = 0; i < ([buffer length]-1); i++)
            {
                sum += byteData[i];
            }
                         
            //set checksum and counder sta
            byteData[bufferLength-1]= ~sum;
            [buffer appendData:counterData];

             if ( !_responsePending)
            {
                lastCommand = command;
                _responsePending=true;
                //send packet
                [self writeData:buffer];         

            }
            else
            {
                [self queuePacket:buffer];
            }
                   
            //clean up
            [buffer release];
            [counterData release];
            
            packetCounter++;
   
    }
            
}

 

@end
