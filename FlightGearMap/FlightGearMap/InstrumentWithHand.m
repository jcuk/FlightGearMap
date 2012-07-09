//
//  InstrumentWithHand.m
//  FlightGearMap
//
//  Created by Jason Crane on 07/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentWithHand.h"

@implementation InstrumentWithHand

float handCentre = 0.2;

- (id)initWithFilename:(NSString *)fileName {
    //Also need :  min:(int)minVal aMin:(int)angleMin max:(int)maxVal aMax:(int)angleMax
    self = [super initWithFilename:fileName];
    if (self) {
        
        UIImage *hand = [UIImage imageNamed:@"hand1-70.png"];
        UIImageView *handView = [[UIImageView alloc] initWithImage:hand];
        [self addSubview:handView];
        [self bringSubviewToFront:handView];
        handView.frame = CGRectMake(super.image.size.width/2 - hand.size.width/2, super.image.size.height/2 - hand.size.height/2 - hand.size.height*handCentre, hand.size.width, hand.size.height);
        
    }
    return self;
}

-(int)angle {
    return 0;
}

@end
