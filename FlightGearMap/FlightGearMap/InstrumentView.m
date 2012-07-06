//
//  InstrumentView.m
//  FlightGearMap
//
//  Created by Jason Crane on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentView.h"
#import "Instrument.h"

@implementation InstrumentView

NSMutableArray * instruments;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        instruments = [[NSMutableArray alloc]init];
        
        [instruments addObject:[[Instrument alloc]initWithImage:@"alt1-70.png"]];
        [instruments addObject:[[Instrument alloc]initWithImage:@"ati3-70.png"]];
        [instruments addObject:[[Instrument alloc]initWithImage:@"climb-70.png"]];
        [instruments addObject:[[Instrument alloc]initWithImage:@"rpm-70.png"]];
        [instruments addObject:[[Instrument alloc]initWithImage:@"speed-70.png"]];
        [instruments addObject:[[Instrument alloc]initWithImage:@"speed-70.png"]];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    int y = 0;
    int step = 70;
    
    for (Instrument *instrument in instruments) {
        
        CGRect imageRect = CGRectMake(0, y, 70, 70);
        
        [instrument.image drawInRect:imageRect];
        
        y+=step;
    }
    
}

@end
