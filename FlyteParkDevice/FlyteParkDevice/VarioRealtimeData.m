//  VarioRealtimeData.m
//  MicrovarioProTestApp
//
//  Created by Brian Vogel on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "VarioRealtimeData.h"
#import "UserPreferences.h"
#import "MathUtility.h"

#define RELEASE_SAFE(x) if(NULL!=x) [x release]

@implementation VarioRealtimeData



@synthesize batVoltage;

 

-(Unit*) altitudeUnit
{
    return _altitudeUnit;
}

-(Unit*) climbUnit
{
    return _climbUnit;
}

-(Unit*) temperatureUnit
{
    return _temperatureUnit;
}

-(NSString*) getTemperatureString
{
    return [NSString stringWithFormat:@"%.2f", [_temperatureUnit getDisplayValue] ];
}

-(NSString*) getClimbString
{
    float roundAmount = ([_climbUnit displayUnits] == U_CMS) ? 0.0f : 0.5f;
    float rounded = ROUND([_climbUnit getDisplayValue], roundAmount);
 
    
    return [NSString stringWithFormat:@"%.2f", rounded];
}

 

-(NSString*) getAltitudeString
{
    return [NSString stringWithFormat:@"%.0f", [_altitudeUnit getDisplayValue] ];
}

-(NSString*) getAltitudeString: (float) offset
{
    return [NSString stringWithFormat:@"%.0f", offset+[_altitudeUnit getDisplayValue] ];
}

-(NSString*) getTemperatureAbbreviation
{
    return [_temperatureUnit getDisplayValueAbbreviation];
}

-(NSString*) getAltitudeLabelString: (NSString*) name
{
    return [NSString stringWithFormat:@"%@ (%@)", name,
            [_altitudeUnit getDisplayValueAbbreviation]];  
}


-(NSString*) getAltitudeLabelString
{
    return [NSString stringWithFormat:@"Altitude (%@)", 
             [_altitudeUnit getDisplayValueAbbreviation]];  
}
-(NSString*) getClimbLabelString
{
   return [NSString stringWithFormat:@"Climb (%@)", 
                           [_climbUnit getDisplayValueAbbreviation]]; 
}

-(NSString*) getTemperatureLabelString
{
   return [NSString stringWithFormat:@"Temp (%@%@)",@"\u00B0", 
                                 [_temperatureUnit getDisplayValueAbbreviation]]; 
}
 
 

-(NSString*) getAltitudeAbbreviation
{
    return [_altitudeUnit getDisplayValueAbbreviation];
}


-(void) setAltitude: (int) value
{
    if (_altitudeUnit!=NULL)
    {
        _altitudeUnit.value = (double) value;
    }
    else
    {
       _altitudeUnit = [[Unit unitWithValue:(double) value unit:U_CENTIMETERS ] retain];
        UnitType unitType= [[UserPreferences instance] getDistanceDisplayUnitType];
       [_altitudeUnit setDisplayUnits: unitType];
    }
    

}


-(void) setClimb: (int) value
{
    
    if (_climbUnit!=NULL)
    {
        _climbUnit.value = (double) value;
    }
    else
    {
        _climbUnit = [[Unit unitWithValue:(double) value unit:U_CMS] retain];
        [_climbUnit setDisplayUnits: [[UserPreferences instance] getSpeedDisplayUnitType] ];
    }
}

-(void) setTemperature: (int) value
{
    if (_temperatureUnit!=NULL)
    {
        _temperatureUnit.value = (double) value;
    }
    else
    {
        _temperatureUnit = [[Unit unitWithValue:(double) value unit:U_CELCIUS] retain];
        [_temperatureUnit setDisplayUnits: [[UserPreferences instance] getTemperatureDisplayUnitType]];        
    }
    

}


-(void) addData: (VarioRealtimeData*) data
{
    [[self climbUnit] setValue: self.climbUnit.value + data.climbUnit.value];
    [[self altitudeUnit] setValue: self.altitudeUnit.value + data.altitudeUnit.value];
    [[self temperatureUnit] setValue: self.temperatureUnit.value + data.temperatureUnit.value];
    self.batVoltage+=data.batVoltage;
}

-(void) subtractData: (VarioRealtimeData*) data
{
    [[self climbUnit] setValue: self.climbUnit.value - data.climbUnit.value];
    [[self altitudeUnit] setValue: self.altitudeUnit.value - data.altitudeUnit.value];
    [[self temperatureUnit] setValue: self.temperatureUnit.value - data.temperatureUnit.value];
    self.batVoltage-=data.batVoltage;
}

 

//preferences changed, update display units
-(void) unitsPreferenceChanged
{
    UnitType lengthUnit = [[UserPreferences instance] getDistanceDisplayUnitType];
    UnitType tempUnit = [[UserPreferences instance] getTemperatureDisplayUnitType];
    UnitType speedUnit = [[UserPreferences instance] getSpeedDisplayUnitType];
    
    if(_altitudeUnit!=NULL) 
    {
        [_altitudeUnit setDisplayUnits:lengthUnit];
    }
    
    if (_climbUnit!=NULL)
    {
        
        [_climbUnit setDisplayUnits:speedUnit];
    }
    
    if (_temperatureUnit!=NULL)
    {
        [_temperatureUnit setDisplayUnits:tempUnit];           
    }

}

-(void) dump
{
    //NSLog(@"%.2f", clbU )
}

-(id) init
{
    self = [super init];
    
    if (self)
    {    
        [[UserPreferences instance] addTarget:self action:@selector(unitsPreferenceChanged) forEvent:UP_UNITS_PREFERENCE_CHANGED];
    }
    
    return self;
}

-(void) dealloc
{
    
  [[UserPreferences instance] removeTarget:self action:@selector(unitsPreferenceChanged) forEvent:UP_UNITS_PREFERENCE_CHANGED]; 

  if(_altitudeUnit!=NULL)  [_altitudeUnit release];
  if (_climbUnit!=NULL)    [_climbUnit release];
  if (_temperatureUnit!=NULL) [_temperatureUnit release];
    
    
  [super dealloc];
}


@end
