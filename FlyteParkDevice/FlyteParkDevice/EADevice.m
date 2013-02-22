//
//  EADevice.m
//  MicrovarioProTestApp
//
//  Created by Brian Vogel on 8/21/11.
//  Copyright 2011 Techrhythm. All rights reserved.
//

#import "EADevice.h"

NSString *EADeviceReceivedNotification = @"EADeviceReceivedNotification";

@implementation EADevice

@synthesize isConnected;
@synthesize isStreamOpen;

@synthesize accessory = _accessory;
@synthesize protocolString = _protocolString;
@synthesize delegate = _delegate;


#pragma mark Internal

// low level write method - write data to the accessory while there is space available and data to write
- (void)_writeData {
    while (([[_session outputStream] hasSpaceAvailable]) && ([_writeData length] > 0))
    {
        NSInteger bytesWritten = [[_session outputStream] write:[_writeData bytes] maxLength:[_writeData length]];
        if (bytesWritten == -1)
        {
            //NSLog(@"write error");
            break;
        }
        else if (bytesWritten > 0)
        {
            [_writeData replaceBytesInRange:NSMakeRange(0, bytesWritten) withBytes:NULL length:0];
        }
    }
}

// low level read method - read data while there is data and space available in the input buffer
- (void)_readData {
#define EAD_INPUT_BUFFER_SIZE 128
    uint8_t buf[EAD_INPUT_BUFFER_SIZE];
    while ([[_session inputStream] hasBytesAvailable])
    {
        NSInteger bytesRead = [[_session inputStream] read:buf maxLength:EAD_INPUT_BUFFER_SIZE];
        if (_readData == nil) {
            _readData = [[NSMutableData alloc] init];
        }
        [_readData appendBytes:(void *)buf length:bytesRead];
        //NSLog(@"read %d bytes from input stream", bytesRead);
    }
    
    [self _onDataRecieved];
    //[[NSNotificationCenter defaultCenter] postNotificationName:EADeviceReceivedNotification object:self userInfo:nil];
}

- (void) _onDataRecieved
{


}


#pragma mark Public Methods

 

- (void)dealloc
{
    [self closeSession];
    [self setupControllerForAccessory:nil withProtocolString:nil];
    
    [super dealloc];
}

// initialize the accessory with the protocolString
- (void)setupControllerForAccessory:(EAAccessory *)accessory withProtocolString:(NSString *)protocolString
{
    [_accessory release];
    _accessory = [accessory retain];
    [_protocolString release];
    _protocolString = [protocolString copy];

   
}

- (void) setDelegate:(NSObject *)delegate
{
    [_delegate release];
    _delegate = [delegate retain];
    
}

// open a session with the accessory and set up the input and output stream on the default run loop
- (BOOL)openSession
{

    [_accessory setDelegate:self];
    _session = [[EASession alloc] initWithAccessory:_accessory forProtocol:_protocolString];
    
    if (_session)
    {
        [[_session inputStream] setDelegate:self];
        [[_session inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[_session inputStream] open];
        
        [[_session outputStream] setDelegate:self];
        [[_session outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[_session outputStream] open];
        
        isConnected = true;
    }
    else
    {
        NSLog(@"creating session failed");
    }
    
    return (_session != nil);
}

// close the session with the accessory.
- (void)closeSession
{
   
    if (_session)
    {
    
        
        [[_session inputStream] close];
        [[_session inputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[_session inputStream] setDelegate:nil];
        [[_session outputStream] close];
        [[_session outputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[_session outputStream] setDelegate:nil];
        [_session release];
        _session = nil;
        
        [_writeData release];
        _writeData = nil;
        [_readData release];
        _readData = nil;
    }

}

// high level write data method
- (void)writeData:(NSData *)data
{
    if (_writeData == nil) {
        _writeData = [[NSMutableData alloc] init];
    }
    
    [_writeData appendData:data];
    [self _writeData];
}

// high level read method 
- (NSData *)readData:(NSUInteger)bytesToRead
{
    NSData *data = nil;
    if ([_readData length] >= bytesToRead) {
        NSRange range = NSMakeRange(0, bytesToRead);
        data = [_readData subdataWithRange:range];
        [_readData replaceBytesInRange:range withBytes:NULL length:0];
    }
    return data;
}

// get number of bytes read into local buffer
- (NSUInteger)readBytesAvailable
{
    return [_readData length];
}

#pragma mark EAAccessoryDelegate
- (void)accessoryDidDisconnect:(EAAccessory *)accessory
{
    [self closeSession];
    isConnected = false;
}

-(void) onStreamOpened
{
    
}

#pragma mark NSStreamDelegateEventExtensions

// asynchronous NSStream handleEvent method
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventNone:
          // NSLog(@"StreamEvent:NSStreamEventNone");
            break;
        case NSStreamEventOpenCompleted:
            isStreamOpen = true;
           //  NSLog(@"StreamEvent:NSStreamEventOpenCompleted");
            [self onStreamOpened];
            break;
        case NSStreamEventHasBytesAvailable:
             //NSLog(@"StreamEvent:NSStreamEventHasBytesAvailable (read)");              
            [self _readData];
            break;
        case NSStreamEventHasSpaceAvailable:
            // NSLog(@"StreamEvent:NSStreamEventHasSpaceAvailable (write)");               
            [self _writeData];
            break;
        case NSStreamEventErrorOccurred:
            // NSLog(@"StreamEvent:Stream Error");                       
            break;
        case NSStreamEventEndEncountered:
            // NSLog(@"StreamEvent:NSStreamEventEndEncountered");               
            break;
        default:
           //  NSLog([NSString stringWithFormat: @"StreamEvent: UNKNOWN EVENT - %d",eventCode]);     
            break;
    }
}

@end
