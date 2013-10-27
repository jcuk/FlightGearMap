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
#import "InstrumentSpeedo.h"
#import "FGMViewController.h"
#import "InstrumentsASI2.h"

@implementation InstrumentView

NSMutableArray *instruments, *propInstruments, *jetInstruments;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        Instrument *alti = [[InstrumentAltimeter alloc]initWithFilename:@"alt1"];
        Instrument *hori = [[InstrumentHorizon alloc]initWithFilename:@"ati3"];
        Instrument *climb = [[InstrumentGeneric alloc]initWithFilename:@"climb"
                hand:@"hand1" dataType:CLIMB_RATE min:-2000 max:2000 minAngle:-265 maxAngle:85];
        Instrument *rpm = [[InstrumentGeneric alloc]initWithFilename:@"rpm"
                hand:@"hand1" dataType:RPM min:0 max:3500 minAngle:-125 maxAngle:125];
        Instrument *speed = [[InstrumentSpeedo alloc]initWithFilename:@"speed"];
        Instrument *tas = [[InstrumentTurnAndSlip alloc]initWithFilename:@"trn1"];
        Instrument *jetAsi =[[InstrumentsASI2 alloc]initWithFilename:@"jet-asi"];
        
        propInstruments = [[NSMutableArray alloc]initWithObjects:alti,hori,climb, rpm, speed, tas, nil];
        jetInstruments = [[NSMutableArray alloc]initWithObjects:alti,hori,climb, rpm, jetAsi, tas, nil];
        [self showPropInstruments];
    }
    return self;
}

-(void)showPropInstruments {
    instruments = propInstruments;
    [self setNeedsLayout];
}

-(void)showFastJetInstruments {
    instruments = jetInstruments;
    [self setNeedsLayout];
}

-(void)updatePlaneData:(PlaneData *)planeData {
    for (Instrument *instrument in instruments) {
        [instrument updatePlaneData:planeData];
    }
}

-(void)setNeedsLayout {
    [super setNeedsLayout];
    
    int y=0;
    
    int rectSize;
    int step;
    int viewWidth;
    
    NSLog(@"Orientation %d",[UIDevice currentDevice].orientation);
    
    int orientation = [UIDevice currentDevice].orientation;

    //Remove any views not needed
    //NB: Will need changing if any non-instrument subviews are added
    for (UIView *view in [self subviews]) {
        if (![instruments containsObject:view]){
            [view removeFromSuperview];
        }
    }
    
    if (orientation == UIDeviceOrientationUnknown ||
        orientation == UIDeviceOrientationPortrait ||
        orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        //Portrait - 1 column of 6 instruments
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
            step = 160;
            rectSize = 160;
            viewWidth = 160;
        } else {
            step = 69;
            rectSize = 70;
            viewWidth = 70;
        }
        
        for (Instrument *instrument in instruments) {
            [self addSubview:instrument];
            instrument.frame = CGRectMake(0, y, rectSize, rectSize);
            y += step;
        }
        
    } else {
        //Landscape - 2 columns of 3 instruments
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
            step = 260;
            rectSize = 160;
            viewWidth = 320;
        } else {
            step = 90;
            rectSize = 70;
            viewWidth = 140;
        }
        
        bool left = YES;
        for (Instrument *instrument in instruments) {
            [self addSubview:instrument];
            if (left) {
                instrument.frame = CGRectMake(0, y, rectSize, rectSize);
            } else {
                instrument.frame = CGRectMake(instrument.frame.size.width, y, rectSize, rectSize);
                y += step;
            }
            
            left = !left;
        }
        
    }
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y, 
                            viewWidth,
                            self.frame.size.height);
}

@end
