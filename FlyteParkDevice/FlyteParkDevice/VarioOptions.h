//
//  VarioOptions.h
//  FlyteParkDevice
//
//  Created by Brian Vogel on 12/18/11.
//  Copyright 2011 Techrhythm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum VarioVolume
{
    VOL_OFF = 0x00,
    VOL_LOW = 0x01,
    VOL_NORMAL = 0x02
} VarioVolume;


@interface VarioOptions : NSObject {
@private
    
}

@property (readwrite,assign) short climbThreshold;
@property (readwrite,assign) short sinkThreshold;
@property (readwrite,assign) short liftThreshold;
@property (readwrite,assign) unsigned char trackLogInterval;
@property (readwrite,assign) unsigned char trackLogTrigger;
@property (readwrite,assign) unsigned char varioDamping;
@property (readwrite,assign) unsigned char sampleRate;
@property (readwrite,assign) VarioVolume volume;
@property (readwrite,assign) unsigned char flags;


@end
