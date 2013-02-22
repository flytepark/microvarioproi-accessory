//
//  VarioRealtimeData.h
//  MicrovarioProTestApp
//
//  Created by Brian Vogel on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Unit.h"

@interface VarioRealtimeData : NSObject {
    Unit* _altitudeUnit;
    Unit* _climbUnit;
    Unit* _temperatureUnit;
    
    NSString* _altitudeLabelString;
    NSString* _climbLabelString;
    NSString* _temperatureLabelString;
}

-(Unit*) altitudeUnit;
-(Unit*) climbUnit;
-(Unit*) temperatureUnit;
@property (readwrite,assign) int batVoltage;


-(NSString*) getTemperatureString;
-(NSString*) getClimbString;
-(NSString*) getAltitudeString;
-(NSString*) getTemperatureAbbreviation;
 
-(NSString*) getAltitudeAbbreviation;

-(NSString*) altitudeLabelString;
-(NSString*) climbLabelString;
-(NSString*) temperatureLabelString;

-(void) setAltitude: (int) value;
-(void) setClimb: (int) value;
-(void) setTemperature: (int) value;
-(void) setBatVoltage: (int) value;

-(void) addData: (VarioRealtimeData*) data;
-(void) subtractData: (VarioRealtimeData*) data;


@end
