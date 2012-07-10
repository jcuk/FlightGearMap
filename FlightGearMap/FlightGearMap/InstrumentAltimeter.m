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
        [self sendSubviewToBack:altView];
        
        [super addHand:@"hand1-70.png"];
        [super addHand:@"hand2-70.png"];
             
    }
    
    return self;
}


@end
