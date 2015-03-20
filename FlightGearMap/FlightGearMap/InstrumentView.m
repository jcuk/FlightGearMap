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
#import "InstrumentsALT2.h"

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
        Instrument *jetAsi =[[InstrumentsASI2 alloc]initWithFilename:@"jet-asi" hand:@"hand1" digits:@"jet-asi-digits"];
        Instrument *jetAlti =[[InstrumentsALT2 alloc]initWithFilename:@"jet-alt" hand:@"hand1" digits:@"jet-alt-digits"];
        
        propInstruments = [[NSMutableArray alloc]initWithObjects:alti, hori, climb, rpm, speed, tas, nil];
        jetInstruments = [[NSMutableArray alloc]initWithObjects:jetAlti, hori, climb, rpm, jetAsi, tas, nil];
        [self showPropInstruments:false];
    }
    return self;
}

-(void)showPropInstruments:(bool)fullscreen {
    _fullScreenView = fullscreen;
    instruments = propInstruments;
    [self setNeedsLayout];
}

-(void)showFastJetInstruments:(bool)fullscreen {
    _fullScreenView = fullscreen;
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
    
    int rectSize;
    int step;
    int viewWidth;
    
    NSLog(@"Orientation %d",(int)[UIDevice currentDevice].orientation);
    
    int orientation = [UIDevice currentDevice].orientation;

    //Remove any views not needed
    //NB: Will need changing if any non-instrument subviews are added
    for (UIView *view in [self subviews]) {
        if (![instruments containsObject:view]){
            [view removeFromSuperview];
        }
    }
    
    int cols = 0;
    
    if (_fullScreenView) {
        if (orientation == UIDeviceOrientationUnknown ||
            orientation == UIDeviceOrientationPortrait ||
            orientation == UIDeviceOrientationPortraitUpsideDown) {
            cols = 2;
    
            //Portrait - 2 columns of 3 instruments
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
                step = 320;
                rectSize = 350;
                viewWidth = 160;
            } else {
                step = 140;
                rectSize = 150;
                viewWidth = 70;
            }
    
        } else {
            //Landscape - 3 columns of 2 instruments
            cols = 3;
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
                step = 350;
                rectSize = 350;
                viewWidth = 320;
            } else {
                step = 135;
                rectSize = 170;
                viewWidth = 140;
            }
    
        }
        
    } else {
        if (orientation == UIDeviceOrientationUnknown ||
            orientation == UIDeviceOrientationPortrait ||
            orientation == UIDeviceOrientationPortraitUpsideDown) {
            cols = 1;
            
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
        } else {
            //Landscape - 2 columns of 3 instruments
            cols = 2;
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
                step = 260;
                rectSize = 160;
                viewWidth = 320;
            } else {
                step = 90;
                rectSize = 70;
                viewWidth = 140;
            }
        }
    }
    
    int count = 0;
    for (Instrument *instrument in instruments) {
        [self addSubview:instrument];
        instrument.frame = CGRectMake(instrument.frame.size.width * (count % cols), step * (int)(count / cols), rectSize, rectSize);
    //    instrument.transform = CGAffineTransformMakeScale(2, 2);
        count++;
    }
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y, 
                            viewWidth,
                            self.frame.size.height);
}

@end
