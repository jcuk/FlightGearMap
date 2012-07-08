//
//  InstrumentView.m
//  FlightGearMap
//
//  Created by Jason Crane on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentView.h"
#import "Instrument.h"
#import "InstrumentWithHand.h"

@implementation InstrumentView

NSMutableArray * instruments;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        instruments = [[NSMutableArray alloc]init];
        
        [instruments addObject:[[Instrument alloc]initWithFilename:@"alt1-70.png"]];
        [instruments addObject:[[Instrument alloc]initWithFilename:@"ati3-70.png"]];
        [instruments addObject:[[Instrument alloc]initWithFilename:@"climb-70.png"]];
        [instruments addObject:[[Instrument alloc]initWithFilename:@"rpm-70.png"]];
        [instruments addObject:[[Instrument alloc]initWithFilename:@"speed-70.png"]];
        [instruments addObject:[[Instrument alloc]initWithFilename:@"trn1-70.png"]];
        [instruments addObject:[[Instrument alloc]initWithFilename:@"alt1-70.pn"]];
                
        int y = 0;
        int step = 70;
        
        //TODO: rotate
        //TODO: retina
        //TODO: ipad
        for (Instrument *instrument in instruments) {
            [self addSubview:instrument];
            instrument.frame = CGRectMake(0, y, 70, 70);
            y += step;
        }
        
    }
    return self;
}

@end
