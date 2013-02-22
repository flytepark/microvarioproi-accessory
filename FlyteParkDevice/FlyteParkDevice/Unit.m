//
//  Unit.m
//  MicrovarioProTestApp
//
//  Created by Brian Vogel on 8/9/12.
//  Copyright 2012 Techrhythm. All rights reserved.
//

#import "Unit.h"

#define CM_IN_INCHES 0.393701
#define CM_IN_FEET 0.0328084

#define M_IN_CM 100.000000
#define FEET_IN_CM 30.480000

NSString* unitTypeAbbreviations[11] =  {
    @"m",       //0. U_METERS
    @"cm",      //1. U_CENTIMETERS
    @"ft",      //2. U_FEET
    @"\"",      //3. U_INCHES
    @"F",       //4. U_FARENHEIGHT
    @"C",       //5. U_CELCIUS
    @"K",       //6. U_KNOTS
    @"cm/sec", //7. U_CMS
    @"in/min", //8. U_INMIN
    @"ft/min", //9. U_FTMIN
    @"m/min" //10. U_MIN
    
};      //U_KNOTS

@implementation Unit

@synthesize unitType = _unitType;
@synthesize value;
@synthesize displayValue;



-(id) initWithValue: (double) val unitType: (UnitType) unitType
{
    self = [super init];
    
    if (self)
    {
        self.value = val;
        _unitType=unitType;
        displayValueCallback = @selector(noConversion);
    }
    
    
    return self;
}

-(NSString*)getDisplayValueAbbreviation
{
    return [NSString stringWithString: unitTypeAbbreviations[_displayUnits]];
}

-(NSNumber*) noConversion
{
    return [NSNumber numberWithDouble:self.value];
}


-(NSNumber*) cmToM
{
    
    return  [NSNumber numberWithDouble:value / 100.0];
}

-(NSNumber*) cmsToMMin
{
    return  [NSNumber numberWithDouble: (value / 100.0) * 60.0];
}

-(NSNumber*) celciusToFarenheight
{
    return  [NSNumber numberWithDouble:32.0 + (value*1.8) ];
}

-(NSNumber*) cmToFeet
{
    return  [NSNumber numberWithDouble:value * CM_IN_FEET];
}

-(NSNumber*) cmsToFeetMin
{
    return  [NSNumber numberWithDouble: (value * CM_IN_FEET) * 60];
}

-(double) mToCm: (double) value
{
    
    return  value * 100.0;
}



-(double) FeetToCm: (double) value
{
    return  value * FEET_IN_CM;
}



-(void) setDisplayValue:(double) value
{
    double result = 0;
    
    switch (_displayUnits) {
            
        case U_METERS:
            [self setValue: value * M_IN_CM];
            break;
            
        case U_FEET:
            [self setValue: value * FEET_IN_CM];
            break;
            
        case U_INCHES:
        case U_FARENHEIGHT:
        default:
            displayValueCallback = @selector(noConversion);
            break;
    }
    
}

-(void) setDisplayUnits: (UnitType) units
{
    _displayUnits = units;
    
    switch (units) {
            
        case U_METERS:
            if (self.unitType==U_CENTIMETERS) displayValueCallback = @selector(cmToM);
            break;
            
        case U_INCHES:
            if (self.unitType==U_CENTIMETERS) displayValueCallback = @selector(cmToInches);
            
            break;
            
        case U_FEET:
            if (self.unitType==U_CENTIMETERS) displayValueCallback = @selector(cmToFeet);
            break;
            
        case U_FARENHEIGHT:
            if (self.unitType == U_CELCIUS) displayValueCallback = @selector(celciusToFarenheight);
            break;
            
        case U_MMIN:
            if (self.unitType==U_CMS) displayValueCallback = @selector(cmsToMMin);
            break;
            
        case U_FTMIN:
            if (self.unitType==U_CMS) displayValueCallback = @selector(cmsToFeetMin);
            break;
            
        case U_CMS:
        default:
            displayValueCallback = @selector(noConversion);
            break;
    }
    
}

-(UnitType) displayUnits
{
    return _displayUnits;
}

-(double) getDisplayValue
{
    NSNumber* result = (NSNumber*)[self performSelector:displayValueCallback];
    return  [result doubleValue];
}

+(Unit*) unitWithUnit: (Unit*) unit
{
    return [Unit unitWithValue: [unit value]  unit: [unit unitType]  displayUnits: [unit displayUnits]];
}


+(Unit*) unitWithValue: (double) value unit: (UnitType) unitType
{
    return [[[Unit alloc ] initWithValue:value unitType:unitType] autorelease];
}

+(Unit*) unitWithValue: (double) value unit: (UnitType) unitType displayUnits: (UnitType) displayUnits
{
    Unit* unit = [[[Unit alloc ] initWithValue:value unitType:unitType] autorelease];
    [unit setDisplayUnits:displayUnits];
    return unit;
}

+(NSString*)displayValueAbbreviationForUnitType: (UnitType) unitType
{
    return [NSString stringWithString: unitTypeAbbreviations[unitType]];
}

@end
