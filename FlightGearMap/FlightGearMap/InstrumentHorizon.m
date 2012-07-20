//
//  InstrumentHorizon.m
//  FlightGearMap
//
//  Created by Jason Crane on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define PITCH_MOVEMENT_PER_DEGREE 0.01

#import "InstrumentHorizon.h"
#import <QuartzCore/QuartzCore.h>

@implementation InstrumentHorizon

-(id)initWithFilename:(NSString *)fileName {
    self = [super initWithFilename:fileName];
    if (self) {
        UIImage *bank = [UIImage imageNamed:@"ati2"];
        bankView = [[UIImageView alloc] initWithImage:bank];
        [self addSubviewBehind:bankView];
        
        //TODO: clip horizon view - bit of a bodge, use RPM
        UIImage *maskImage = [UIImage imageNamed:@"rpm"];
        CALayer *maskingLayer = [CALayer layer];
        maskingLayer.frame = self.bounds; //????
        
        [maskingLayer setContents:(id)[maskImage CGImage]];
        [self.layer setMask:maskingLayer];
        
        
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
    
    float rollAngle = 0;
    float pitchAngle = 45;
    
    if (roll && pitch) {
        rollAngle = [roll floatValue];
        pitchAngle = [pitch floatValue];
    }
    
    CGAffineTransform pitchTransform = CGAffineTransformMakeTranslation(0, pitchAngle * PITCH_MOVEMENT_PER_DEGREE * [self rootSize].height);
    
    CGAffineTransform rollTransform = CGAffineTransformMakeRotation(-rollAngle / 360 * 2 * PI);
    [bankView       setTransform:rollTransform];
    [horizonView    setTransform:CGAffineTransformConcat(rollTransform,pitchTransform)];
    [horizonBGView  setTransform:rollTransform];
    
}



@end
