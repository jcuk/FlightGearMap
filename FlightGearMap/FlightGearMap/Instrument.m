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
        [self addSubviewInFront:[[UIImageView alloc]initWithImage:image]];
    }
    
    return self;
}

-(void)updatePlaneData:(PlaneData *)planeData {
    
}

@end
