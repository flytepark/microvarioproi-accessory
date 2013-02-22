//
//  MathUtility.m
//  MicrovarioProTestApp
//
//  Created by Brian Vogel on 8/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MathUtility.h"
#import "VarioConstants.h"

@implementation MathUtility



+(double) averageArray: (NSArray*) samples selector:(SEL) getValueSelector
 {
        int numSamples = [samples count];
        double average=0;
        
        for(int i=0;i<numSamples;i++)
        {
            if (getValueSelector!=nil)
            {
                id current = [samples objectAtIndex:i];
                int value = (int) [current performSelector:getValueSelector];
                average+= (double) value;             
            }
            else
            {
                average+= [[samples objectAtIndex:i] doubleValue];             
                
            }

        }
        
        //average = (average >= 0 ? average+numSamples/2 : average-numSamples/2);
        average /= numSamples;
        return average;
 }

/*

+(int) calculateVelocity: (NSArray*) samples denomonator: (long) denomonator selector:(SEL) getValueSelector
{
    int numSamples = [samples count];
    int average =  [MathUtility averageArray:samples];
    long sumZt;
    
    for (int i=0;i<numSamples;i++)
    {
        sumZt += ((long)  [[[samples objectAtIndex:i] performSelector:getValueSelector] longValue]) - average;
    }
    
    int velocity = (int)((sumZt*(long)(SNS_SAMPLES_PER_SECx10*numSamples))/(10*denomonator));
    CLAMP(velocity,-MAX_VERTICAL_VELOCITY_CPS,MAX_VERTICAL_VELOCITY_CPS);
    return velocity;

}
 
 */

/*
///
/// Linear regression on velocity sample window to calculate vertical
/// acceleration
+(int) calculateAcceleration: (NSArray*) samples
    int index,trel;
    s32 nAccel;
    s64 v, sum_vt;
    sum_vt = 0;
    trel = nSamples;
    while (trel)  {
        index = gnVSampleIndex - trel + 1;
        if (index < 0) index += SNS_NUM_VSAMPLES;
        v = (s64)(gVBuf[index] - gPSD.cpsAverage);
        sum_vt += ((s64)-trel*v);
        trel--;
    }
    nAccel = (s32)((sum_vt*(s64)(SNS_SAMPLES_PER_SECx10*nSamples))/(10*gnADen));
    return nAccel;
}
 */

@end
