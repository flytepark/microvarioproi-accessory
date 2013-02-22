//
//  BinaryUtility.h
//  MicrovarioProTestApp
//
//  Created by Brian Vogel on 12/18/11.
//  Copyright 2011 Techrhythm. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BinaryUtility : NSObject {
@private
    
}

+ (int) BytesToShort: (Byte) a byte2: (Byte) b;
+ (int) BytesToInt: (Byte) a byte2: (Byte) b byte3: (Byte) c byte4: (Byte) d;
+ (uint) BytesToUInt: (Byte) a byte2: (Byte) b byte3: (Byte) c byte4: (Byte) d;

+ (uint) sumOfData: (NSData*) data;
+ (uint) checksumFromData: (NSData*) data;

@end
