//
//  InstrumentHorizon.m
//  FlightGearMap
//
//  Created by Jason Crane on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define PITCH_MOVEMENT_PER_DEGREE 0.01

#import "InstrumentHorizon.h"

@implementation InstrumentHorizon

-(id)initWithFilename:(NSString *)fileName {
    self = [super initWithFilename:fileName];
    if (self) {
        UIImage *bank = [UIImage imageNamed:@"ati2"];
        bankView = [[UIImageView alloc] initWithImage:bank];
        [self addSubviewBehind:bankView];
        
        UIImage *horizon = [UIImage imageNamed:@"ati1"];
        horizonView = [[UIImageView alloc] initWithImage:horizon];
        [self addSubviewBehind:horizonView];
        
        UIImage *horizonBG = [UIImage imageNamed:@"ati0"];
        horizonBGView = [[UIImageView alloc] initWithImage:horizonBG];
        [self addSubviewBehind:horizonBGView];
        
    }
    
    return self;
}

-(void)updatePlaneData:(PlaneData *)planeData {
    NSNumber *roll = [planeData getDataValue:ROLL];
    NSNumber *pitch = [planeData getDataValue:PITCH];
    
    int rollAngle = 20;
    int pitchAngle = 0;
    
    if (roll && pitch) {
        rollAngle = [roll doubleValue];
        pitchAngle = [pitch doubleValue];
    }
    
    //TODO: roll horizon BG?
    CGAffineTransform rollTransform = CGAffineTransformMakeRotation(rollAngle);
    [bankView       setTransform:rollTransform];
    [horizonView    setTransform:rollTransform];
    [horizonBGView  setTransform:rollTransform];
    
    //TODO: pitch
    
}



@end
