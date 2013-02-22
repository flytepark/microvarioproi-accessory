#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>

extern NSString *EADeviceReceivedNotification;

// NOTE: EADSessionController is not threadsafe, calling methods from different threads will lead to unpredictable results
@interface EADevice : NSObject <EAAccessoryDelegate, NSStreamDelegate> {
    EAAccessory *_accessory;
    EASession *_session;
    NSString *_protocolString;
    
    NSMutableData *_writeData;
    NSMutableData *_readData;
    
    NSObject* _delegate;
}
 
@property (readwrite,assign) bool isConnected;
@property (readwrite,assign) bool isStreamOpen;

- (void)setupControllerForAccessory:(EAAccessory *)accessory withProtocolString:(NSString *)protocolString;

- (BOOL)openSession;
- (void)closeSession;
- (void)writeData:(NSData *)data;

- (void) onStreamOpened;
- (void) _onDataRecieved;

- (NSUInteger)readBytesAvailable;
- (NSData *)readData:(NSUInteger)bytesToRead;
- (void) setDelegate: (NSObject*) delegate;

@property (nonatomic, readonly) EAAccessory *accessory;
@property (nonatomic, readonly) NSString *protocolString;
@property (nonatomic, readonly) NSObject *delegate;

@end