//
//  InstrumentTurnAndSlip.m
//  FlightGearMap
//
//  Created by Jason Crane on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentTurnAndSlip.h"

//Proportion of the size of the instrument the radius of slip indicator is
#define SLIP_RADIUS 1.5

//proportion of how far the slip indicator is down the dial
float slipDown = 0.33;

#define MAX_SLIP_ANGLE 10
#define SLIP_SCALE 1.0

@implementation InstrumentTurnAndSlip

-(id)initWithFilename:(NSString *)fileName {
    self = [super initWithFilename:fileName hand:@"turn0.png" dataType:TURN_RATE
        min:-4 max:4 minAngle:-80 maxAngle:80];
    if (self) {
        _slipView = [self addHandWithOffset:@"slip.png" off:slipDown inFront:NO];
        [self addSubviewBehind:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trn0.png"]]];
        
    }
    
    return self;
}

-(void)updatePlaneData:(PlaneData *)planeData {
    [super updatePlaneData:planeData];
    //Handle slip seperatly as it rotates about a non-central point
    
    double slipValue = 0;
    NSNumber *slipData = [planeData getDataValue:SLIP];
    if (slipData) {
        slipValue = [slipData doubleValue];
    }
    
    //Compound affine transformation for curved slip indicator
    double slipAngle = slipValue * SLIP_SCALE * MAX_SLIP_ANGLE;
            
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0, [self rootSize].height * SLIP_RADIUS);
    CGAffineTransform translate2 = CGAffineTransformInvert(translate);
    CGAffineTransform rotate = CGAffineTransformMakeRotation(slipAngle/360 * 2 * PI);
    
    [_slipView setTransform:CGAffineTransformConcat(CGAffineTransformConcat(translate, rotate),translate2)];
    
    
}


@end
