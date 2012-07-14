//
//  InstrumentView.m
//  FlightGearMap
//
//  Created by Jason Crane on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentView.h"
#import "Instrument.h"
#import "InstrumentAltimeter.h"
#import "InstrumentHorizon.h"
#import "InstrumentGeneric.h"
#import "InstrumentTurnAndSlip.h"

@implementation InstrumentView

NSMutableArray * instruments;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        instruments = [[NSMutableArray alloc]init];
        
        [instruments addObject:[[InstrumentAltimeter alloc]initWithFilename:@"alt1.png"]];
        [instruments addObject:[[InstrumentHorizon alloc]initWithFilename:@"ati3.png"]];
        [instruments addObject:[[InstrumentGeneric alloc]initWithFilename:@"climb.png"
            hand:@"hand1.png" dataType:CLIMB_RATE min:-2000 max:2000 minAngle:-265 maxAngle:85]];
        [instruments addObject:[[InstrumentGeneric alloc]initWithFilename:@"rpm"
            hand:@"hand1.png" dataType:RPM min:0 max:3500 minAngle:-125 maxAngle:125]];
        [instruments addObject:[[InstrumentGeneric alloc]initWithFilename:@"speed.png"
            hand:@"hand1.png" dataType:SPEED min:0 max:320 minAngle:0 maxAngle:220]];
        [instruments addObject:[[InstrumentTurnAndSlip alloc]initWithFilename:@"trn1.png"]];
        
        int rectSize;
        int step;
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
            step = 160;
            rectSize = 160;
        } else {
            step = 69;
            rectSize = 70;
        }
                
        int y = 0;
        
        //TODO: rotate
        //TODO: retina
        //TODO: ipad
        for (Instrument *instrument in instruments) {
            [self addSubview:instrument];
            instrument.frame = CGRectMake(0, y, rectSize, rectSize);
            y += step;
        }
        
    }
    return self;
}

-(void)updatePlaneData:(PlaneData *)planeData {
    for (Instrument *instrument in instruments) {
        [instrument updatePlaneData:planeData];
    }
}

@end
