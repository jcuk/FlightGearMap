//
//  InstrumentHorizon.m
//  FlightGearMap
//
//  Created by Jason Crane on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentHorizon.h"

@implementation InstrumentHorizon

-(id)initWithFilename:(NSString *)fileName {
    self = [super initWithFilename:fileName];
    if (self) {
        UIImage *bank = [UIImage imageNamed:@"ati2-70.png"];
        UIImageView *bankView = [[UIImageView alloc] initWithImage:bank];
        [self addSubviewBehind:bankView];
        
        UIImage *horizon = [UIImage imageNamed:@"ati1-70.png"];
        UIImageView *horizonView = [[UIImageView alloc] initWithImage:horizon];
        [self addSubviewBehind:horizonView];
        
        UIImage *horizonBG = [UIImage imageNamed:@"ati0-70.png"];
        UIImageView *horizonBGView = [[UIImageView alloc] initWithImage:horizonBG];
        [self addSubviewBehind:horizonBGView];
        
    }
    
    return self;
}



@end
