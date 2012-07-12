//
//  InstrumentTurnAndSlip.m
//  FlightGearMap
//
//  Created by Jason Crane on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentTurnAndSlip.h"

@implementation InstrumentTurnAndSlip
//proportion of how far the slip indicator is down the dial
float slipDown = 0.66;
UIView *_slipView;

-(id)initWithFilename:(NSString *)fileName {
    self = [super initWithFilename:fileName hand:@"turn-70.png" dataType:TURN_RATE min:-4 max:4 minAngle:-80 maxAngle:80];
    if (self) {
        _slipView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"slip-70"]];
        [self addSubviewBehind:_slipView];
        
 //       _slipView.frame = CGRectMake([self rootView].frame.size.width/2, [self rootView].frame.size.height/2,
   //             _slipView.frame.size.width, _slipView.frame.size.height);
        
    }
    
    return self;
}

-(void)updatePlaneData:(PlaneData *)planeData {
    [super updatePlaneData:planeData];
    //Handle slip seperatly as it rotates about a non-central point
    
    double slip = 0;
    NSNumber *slipData = [planeData getDataValue:SLIP];
    if (slipData) {
        slip = [slipData doubleValue];
    }
    
    //Compound affine transformation
    
}


@end
