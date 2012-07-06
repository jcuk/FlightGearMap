//
//  Instrument.m
//  FlightGearMap
//
//  Created by Jason Crane on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Instrument.h"

@implementation Instrument

@synthesize image;

- (id)initWithImage:(NSString *)fileName
{
    self = [super init];
    if (self) {
        image = [UIImage imageNamed:fileName];
    }
    return self;
}





@end
