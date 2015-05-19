//
//  VarioLog.h
//  FlyteParkDevice
//
//  Created by Brian Vogel on 12/18/11.
//  Copyright 2011 Techrhythm. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VarioLog : NSObject {
    uint trackAddress;
    uint trackPoints;
    uint startAltitude;
    uint maxAltitude;
    uint endtAltitude;
    uint maxSink;
    uint maxClimb;
    NSTimeInterval* trackTime;
    NSTimeInterval* trackInterval;
    NSDate* startTime;
    NSDate *endTime;
}

-(id) initWithData: (NSData*) data;


@end
