//
//  VarioDevice.h
//  FlyteParkDevice
//
//  Created by Brian Vogel on 8/21/11.
//  Copyright 2011 Techrhythm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EADevice.h"
#import "VarioLog.h"
#import "VarioOptions.h"
#import "VarioComm.h"
#import "VarioRealtimeData.h"

//only needed for USB, VarioDevice only uses serial 
//const int VENDOR_ID  = 0x23F7;  //Techrhythm vendor id
//const int PRODUCT_ID = 0x0001;  //flytepark vario logger

@protocol VarioDeviceDelegate <NSObject>

-(void) flyteParkDeviceDidConnect;
-(void) flyteParkDeviceDidDisconnect;
-(void) realtimeDataReceived: (VarioRealtimeData*) varioData;
-(void) varioOptionsReceived: (NSArray*) VarioOptions selectedProfile: (int) profileIndex;
-(void) varioInitialized;

@end

@interface VarioDevice : EADevice {
    VarioCommand lastCommand;
    NSDictionary* commandToValue;
    int lastRealtimePacket;
    ushort packetCounter;
    ushort receivedPacketCounter;
    bool _responsePending;
    bool _trackError;
    uint _currentTrackAddress;
    int _tracksReceived;
    int _trackCount;
    Byte _trackPayloadSize; //max size is 58, omitting one byte so all packets will fit in one request.
    Byte _trackEntrySize;
    Byte _bytesRequested;

}

@property (readwrite,assign) BOOL isRealtime;
@property (readwrite,assign) BOOL isInitialized;
@property (nonatomic,retain) NSMutableArray* queuedPackets;


- (id) initWithDelegate: (NSObject*) target;
- (void) initDefaults;
- (void) didInitialize;

- (void) sendGetOptions;

- (void) saveSettings: (NSArray*) settings selectedProfile: (int) profileIndex;

- (void) sendString: (NSString*) str;
- (void) setDelegate: (NSObject*) target;
- (void) attachHandlers;
- (void) connectFlyteParkDevice: (EAAccessory*) connectedAccessory;

//device specific handlers
- (void) _onSessionDataReceived:(NSNotification *) notification;
- (void) onDataRecieved:(NSData*) data;
- (void) onVarioError: (NSData*) data;
- (void) onOk;
- (void) onRealtimeData: (NSData*) data;
- (void) onVarioInitialized;
//- (void) onReadLog: (NSData*) data  actualResponse:(VarioResponse) response  hasErrors: (bool) errors;
- (void) onTime: (NSData*) data;
- (void) onOptions: (NSData*) options;
//- (void) onReadTrack: (NSData*) data response: (VarioResponse)  hasErrors: (bool);

//device specific commands
- (void) eraseTracks;
- (void) eraseFlights;
- (void) setFactoryDefaults;
- (void) readTracks: (VarioLog*) log;
- (void) readLog: (int) index;
- (void) readDeviceId;
- (void) readTrackLogCount;
- (void) readTime;
- (void) setTime: (NSDate*) date;
- (void) writeOptions: (NSArray*) options selectedProfileIndex: (int) index;
- (void) getOptions;
- (void) enableRelatime;


//utility methods
//- (void) isTrackSizeValid: (int) tracks, trackAddress: int address;
- (void) continueReadingTracks;
- (NSData*) getTracksFromData: (NSData*)data;
- (void) sendCommand: (VarioCommand) command;
- (void) sendCommand: (VarioCommand) command payloadByte: (unsigned char) byte;
- (void) sendCommand: (VarioCommand) command payloadData: (NSData*) data;
- (void) sendQueuedPacket: (NSData*) packet;
- (void) queuePacket: (NSData*) packet;

- (VarioResponse) getExpectedResponse: (VarioCommand) command;

+(void) dumpData: (NSData*) data;

@end


