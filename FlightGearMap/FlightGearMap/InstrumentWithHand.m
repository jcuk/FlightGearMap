//
//  InstrumentWithHand.m
//  FlightGearMap
//
//  Created by Jason Crane on 07/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentWithHand.h"

@implementation InstrumentWithHand

//hand-70 5x27

UIImage *hand;

int centX = 35;
int centY = 35;

int handCentX = 3;
int handCentY = 13;

- (id)initWithImage:(NSString *)fileName {
    //Also need :  min:(int)minVal aMin:(int)angleMin max:(int)maxVal aMax:(int)angleMax
    self = [super initWithImage:fileName];
    if (self) {
        hand = [UIImage imageNamed:@"hand1-70.png"];
        
    }
    return self;
}

-(int)angle {
    return 0;
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    int value = 100;
    
    //TODO: draw hand
    
    [hand drawAtPoint:CGPointMake(rect.origin.x+centX-handCentX,rect.origin.y+centY-handCentY)];
}


@end
