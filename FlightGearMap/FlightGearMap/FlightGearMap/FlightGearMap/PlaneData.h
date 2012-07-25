//
//  PlaneData.h
//  FlightGearMap
//
//  Created by Jason Crane on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaneData : NSObject

typedef enum {
    SPEED,RPM,HEADING_MOV,ALTITUDE,CLIMB_RATE,PITCH,ROLL,LATITUDE,LONGITUDE,SECONDS,TURN_RATE,SLIP,HEADING,FUEL1,FUEL2,
    OIL_PRESS,OIL_TEMP,AMP,VOLT,NAV1_TO,NAV1_FROM,NAV1_DEFLECTION,NAV1_SEL_RADIAL,NAV2_TO,NAV2_FROM,NAV2_DEFLECTION,
    NAV2_SEL_RADIAL,ADF_DEFLECTION,ELEV_TRIM,FLAPS
}PlaneDataType;

-(void)addData:(float)value dataType:(PlaneDataType)dataType;
-(NSNumber *)getDataValue:(PlaneDataType)dataType;

@end
