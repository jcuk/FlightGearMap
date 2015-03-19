//
//  Instrument.m
//  FlightGearMap
//
//  Created by Jason Crane on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Instrument.h"

@implementation Instrument

-(void)addSubviewCentered:(UIView *)view {
    [self addSubview:view];
    view.frame = CGRectMake(self.frame.size.width / 2 - view.frame.size.width / 2, 
                            self.frame.size.height / 2 - view.frame.size.height / 2,
                            view.frame.size.width, view.frame.size.height);
}

-(CGSize)rootSize {
    return self.frame.size;
}

-(void)addSubviewInFront:(UIView *)view {
    [self addSubviewCentered:view];
    [self bringSubviewToFront:view];
}

-(void)addSubviewBehind:(UIView *)view {
    [self addSubviewCentered:view];
    [self sendSubviewToBack:view];

}

-(id)initWithFilename:(NSString *)fileName {
    UIImage *image = [UIImage imageNamed:fileName];
    self = [super init];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        self.frame = imageView.frame;
        self.opaque = NO;
 //       [self addSubviewInFront:[[UIImageView alloc]initWithImage:image]];
    }
    
    return self;
}

-(CGRect)centerHand:(CGSize)imageSize hand:(CGSize)handSize {
    return CGRectMake(imageSize.width/2 - handSize.width/2, imageSize.height/2 - handSize.height/2,
                      handSize.width, handSize.height);
}

-(UIView *)addHand:(NSString *)fileName off:(float)offset inFront:(bool)front  {
    return [self addHandWithOffset:fileName off:offset inFront:front];    
}

-(UIView *)addHandWithOffset:(NSString *)fileName off:(float)offset inFront:(bool)front {
    
    UIImage *handOffset = [UIImage imageNamed:fileName];
    UIImageView *handView = [[UIImageView alloc] initWithImage:handOffset];
    
    if (front) {
        [self addSubviewInFront:handView];
    } else {
        [self addSubviewBehind:handView];
    }
    
    
    handView.frame = CGRectMake(super.frame.size.width/2 - handOffset.size.width/2, super.frame.size.height/2 * (1 + offset) - handOffset.size.height/2,
               handOffset.size.width, handOffset.size.height);
    
    return handView;
    
}

-(void)updatePlaneData:(PlaneData *)planeData {
    //Override for your particular instrument
}

@end
