//
//  InstrumentAltimeter.m
//  FlightGearMap
//
//  Created by Jason Crane on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentAltimeter.h"

@implementation InstrumentAltimeter

UIView *hundredsHandView;
UIView *thousandsHandsView;
UIView *calibrationView;

-(id)initWithFilename:(NSString *)fileName {
    self = [super initWithFilename:fileName];
    if (self) {
        UIImage *altitude = [UIImage imageNamed:@"alt0-70.png"];
        UIImageView *calibrationView = [[UIImageView alloc] initWithImage:altitude];
        [self addSubview:calibrationView];
        [self sendSubviewToBack:calibrationView];
        
        hundredsHandView = [super addHand:@"hand1-70.png"];
        thousandsHandsView = [super addHand:@"hand2-70.png"];
             
    }
    
    return self;
}

-(void)updatePlaneData:(PlaneData *)planeData {
    NSNumber *alt = [planeData getDataValue:ALTITUDE];
    
    if (alt) {
        double altitude = [alt doubleValue];
        double hundredsHandAngle = (altitude / 1000) * 2 * PI;
        double thousandsHandAngle = (altitude / 10000) * 2 * PI;
        
        CGAffineTransform rotateHundreds = CGAffineTransformMakeRotation( hundredsHandAngle);
        [hundredsHandView setTransform:rotateHundreds];
        
        CGAffineTransform rotateThousands = CGAffineTransformMakeRotation( thousandsHandAngle);
        [thousandsHandsView setTransform:rotateThousands];
    }
}


@end
