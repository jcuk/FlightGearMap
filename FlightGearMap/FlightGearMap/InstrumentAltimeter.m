//
//  InstrumentAltimeter.m
//  FlightGearMap
//
//  Created by Jason Crane on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentAltimeter.h"

@implementation InstrumentAltimeter

-(id)initWithFilename:(NSString *)fileName {
    self = [super initWithFilename:fileName];
    if (self) {
        UIImage *altitude = [UIImage imageNamed:@"alt0-70.png"];
        UIImageView *altView = [[UIImageView alloc] initWithImage:altitude];
        [self addSubview:altView];
        [self sendSubviewToBack:altView]; //dosent work??
        
        UIImage *hand1 = [UIImage imageNamed:@"hand1-70.png"];
        UIImageView *hand1View = [[UIImageView alloc] initWithImage:hand1];
        [self addSubview:hand1View];
        [self bringSubviewToFront:hand1View];
        
        //TODO: 2nd hand
        //TODO: refactor frame manipulation
        //-(CGRect)centerHand:(CGRec):instFrame frame:(CGRect)handFrame size:(float):handSize
     
     
    }
    
    return self;
}


@end
