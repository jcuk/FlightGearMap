//
//  Instrument.m
//  FlightGearMap
//
//  Created by Jason Crane on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Instrument.h"

@implementation Instrument

-(id)initWithFilename:(NSString *)fileName {
    UIImage *image = [UIImage imageNamed:fileName];
    self = [super initWithImage:image];
    if (self) {
        self.opaque = NO;
    }
    
    return self;
}

@end
