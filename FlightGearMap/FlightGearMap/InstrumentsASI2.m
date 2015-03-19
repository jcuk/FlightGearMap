//
//  InstrumentsASI2.m
//  FlightGearMap
//
//  Created by Jason Crane on 16/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentsASI2.h"

@implementation InstrumentsASI2

-(id)initWithFilename:(NSString *)fileName hand:(NSString*)handFilename digits:(NSString *)digitsName {
    self = [super initWithFilename:fileName hand:handFilename digits:digitsName dataType:SPEED];
    if (self) {
        
    }
    return self;
}

-(float)getHandAngle:(float)value {
    float angle;
    
    //Calibrate speed
    if (value > 450) {
        angle = 333;
    } else if (value > 300) {
        angle = value*0.42 + 144;
    } else if (value > 250) {
        angle = value*0.5 + 120;
    } else if (value > 100) {
        angle = value*1.25 - 70; //Not sure from here...
    } else if (value > 75){
        angle = value*2.2 - 165;
    } else {
        angle = 0.0f;
    }
    
    return angle;
}


@end
