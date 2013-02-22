//
//  MathUtility.h
//  MicrovarioProTestApp
//
//  Created by Brian Vogel on 8/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define CLAMP(x,min,max)       {if ((x) <= (min)) (x) = (min); else if ((x) >= (max)) (x) = (max);}
#define ROUND(number,roundto) (number>0) ? roundto * floor(number/roundto + 0.5) : roundto * ceil(number/roundto - 0.5) 

@interface MathUtility : NSObject {
    
}

+(double) averageArray: (NSArray*) samples selector:(SEL) getValueSelector;

@end
