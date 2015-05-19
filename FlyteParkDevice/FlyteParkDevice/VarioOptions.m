//
//  VarioOptions.m
//  FlyteParkDevice
//
//  Created by Brian Vogel on 12/18/11.
//  Copyright 2011 Techrhythm. All rights reserved.
//

#import "VarioOptions.h"


@implementation VarioOptions

@synthesize climbThreshold;
@synthesize sinkThreshold;
@synthesize liftThreshold;
@synthesize trackLogInterval;
@synthesize trackLogTrigger;
@synthesize varioDamping;
@synthesize sampleRate;
@synthesize volume;
@synthesize flags;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
