//
//  BinaryUtility.m
//  MicrovarioProTestApp
//
//  Created by Brian Vogel on 12/18/11.
//  Copyright 2011 Techrhythm. All rights reserved.
//

#import "BinaryUtility.h"


@implementation BinaryUtility

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

+ (uint) checksumFromData:(NSData *)data
{
    unsigned char sum = 0;
    
    NSUInteger length = [data length];
    
    for (NSUInteger i=0;i< length;i++)
    {
        //sum+= [data bytes][i];
    }
    
    return sum;
}

/*
public static byte Checksum(this byte[] bytes)
{
    byte sum = 0;
    for (int i = 1; i < bytes.Length-1; i++)
    {
        sum += bytes[i];
    }
    
    return (byte)(~sum);
    
}(/


/*
+ (NSData*) BytesFromInt(int number)
{
    return BitConverter.GetBytes(number);
}

+ (NSData*) BytesFromUInt(uint number)
{
    return BitConverter.GetBytes(number);
}

+ (NSData*) BytesFromInt(uint number)
{
    return BitConverter.GetBytes(number);
}


+ (short BytesToShort(byte a, byte b)
{
    return (short)( 0x000000 | a | b << 8);
}

+ (ushort BytesToUShort(byte a, byte b)
{
    return (ushort)(0x000000 | a | b << 8);
}


+ (byte[] BytesFromShort(short number)
{
    byte a, b;
    
    a = (byte)number;
    b = (byte)(number >> 8);
    
    return new byte[] { a, b};
}

 */
@end
