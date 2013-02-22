//
//  VarioLog.m
//  MicrovarioProTestApp
//
//  Created by Brian Vogel on 12/18/11.
//  Copyright 2011 Techrhythm. All rights reserved.
//

#import "VarioLog.h"
#import "BinaryUtility.h"

@implementation VarioLog

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id) initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        //trackPoints = [BinaryUtilit]
        
        /*
        TrackPoints = BinaryUtility.BytesToInt(data[4], data[5], data[6], data[7]);
        TrackAddress = BinaryUtility.BytesToUInt(data[8], data[9], data[10], data[11]);
        StartAltitude = BinaryUtility.BytesToShort(data[12], data[13]);
        MaxAltitude = BinaryUtility.BytesToShort(data[14], data[15]);
        EndAltitude = BinaryUtility.BytesToShort(data[16], data[17]);
        MaxClimb = BinaryUtility.BytesToShort(data[18], data[19]);
        MaxSink = BinaryUtility.BytesToShort(data[20], data[21]);
        TrackInterval = data[22];
        
        //data[22] hours
        //data[23] minutes
        //data[24] log interval
        
        TrackTime = new TimeSpan(0, 0, TrackPoints * data[24]);
        
        
        try
        {
            
            StartTime = new DateTime(2000 + data[23], data[24], data[25], data[26], data[27], data[28]);
        }
        catch
        {
            
        }
        
        try
        {
            EndTime = new DateTime(2000 + data[29], data[30], data[31], data[32], data[33], data[34]);
        }
        catch
        {
            
        }
        */
    }
    
    return self;
    
}


- (void)dealloc
{
    [super dealloc];
}

@end
