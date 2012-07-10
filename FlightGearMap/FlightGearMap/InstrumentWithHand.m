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

-(CGRect)centerHand:(CGSize)imageSize hand:(CGSize)handSize size:(float)handCenter {
    return CGRectMake(imageSize.width/2 - handSize.width/2, imageSize.height/2 - handSize.height/2 - handSize.height*handCentre, handSize.width, handSize.height);
}

-(void)addHand:(NSString *)fileName {
    
    UIImage *hand = [UIImage imageNamed:fileName];
    UIImageView *handView = [[UIImageView alloc] initWithImage:hand];
    //[self addSubview:handView];
    //[self bringSubviewToFront:handView];
    [self addSubviewInFront:handView];
    handView.frame = [self centerHand:super.frame.size hand:hand.size size:handCentre];
    
}

- (id)initWithFilename:(NSString *)fileName {
    //Also need :  min:(int)minVal aMin:(int)angleMin max:(int)maxVal aMax:(int)angleMax
    self = [super initWithFilename:fileName];
    if (self) {
        
        [self addHand:@"hand1-70.png"];
        
    }
    return self;
}

-(int)angle {
    return 0;
}

@end
