//
//  BinaryUtility.m
//  FlyteParkDevice
//
//  Created by Brian Vogel on 12/18/11.
//  Copyright 2011 Techrhythm. All rights reserved.
//

#import "BinaryUtility.h"


@implementation BinaryUtility

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

+ (int) BytesToShort: (Byte) a byte2: (Byte) b  
{
    void* byteData = {a,b};
    return *((short*) byteData);
}

+ (int) BytesToInt: (Byte) a byte2: (Byte) b byte3: (Byte) c byte4: (Byte) d
{
    void* byteData = {a,b,c,d};
    return *((NSInteger*) byteData);
}


+ (uint) BytesToUInt: (Byte) a byte2: (Byte) b byte3: (Byte) c byte4: (Byte) d
{
    void* byteData = {a,b,c,d};
    return *((UInt32*) byteData);
}

@end
