//
//  Unit.h
//  FlyteParkDevice
//
//  Created by Brian Vogel on 8/9/12.
//  Copyright 2012 Techrhythm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum UnitType
{
    U_METERS = 0,
    U_CENTIMETERS = 1,
    U_FEET = 2,
    U_INCHES = 3,
    U_FARENHEIGHT = 4,
    U_CELCIUS = 5,
    U_KNOTS = 6,
    U_CMS = 7,
    U_INMIN = 8,
    U_FTMIN = 9,
    U_MMIN = 10
    //LAST = 0x0E
} UnitType;



@interface Unit : NSObject {
    UnitType _displayUnits;
    SEL displayValueCallback;
}

@property (readwrite,assign) double value;
@property (readonly) UnitType unitType;
@property (readonly,getter = getDisplayValue) double displayValue;


-(void) setDisplayUnits: (UnitType) units;
-(double) getDisplayValue;
-(void) setDisplayValue:(double)displayValue;

-(NSString*) getDisplayValueAbbreviation;

+(Unit*) unitWithUnit: (Unit*) unit;
+(Unit*) unitWithValue: (double) value unit: (UnitType) unitType;
+(Unit*) unitWithValue: (double) value unit: (UnitType) unitType displayUnits: (UnitType) displayUnits;

+(NSString*)displayValueAbbreviationForUnitType: (UnitType) unitType;
//C to F - = 1.8 * C + 32


@end
