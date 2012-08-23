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

@implementation InstrumentView

@synthesize faceUpPortrait;

NSMutableArray * instruments;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        instruments = [[NSMutableArray alloc]init];
        
        [instruments addObject:[[InstrumentAltimeter alloc]initWithFilename:@"alt1"]];
        [instruments addObject:[[InstrumentHorizon alloc]initWithFilename:@"ati3"]];
        [instruments addObject:[[InstrumentGeneric alloc]initWithFilename:@"climb"
            hand:@"hand1" dataType:CLIMB_RATE min:-2000 max:2000 minAngle:-265 maxAngle:85]];
        [instruments addObject:[[InstrumentGeneric alloc]initWithFilename:@"rpm"
            hand:@"hand1" dataType:RPM min:0 max:3500 minAngle:-125 maxAngle:125]];
        [instruments addObject:[[InstrumentSpeedo alloc]initWithFilename:@"speed"]];
        [instruments addObject:[[InstrumentTurnAndSlip alloc]initWithFilename:@"trn1"]];
        
        [self setNeedsLayout];
                                
    }
    return self;
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
    
    faceUpPortrait = NO;
    
    if (orientation == UIDeviceOrientationFaceUp) {
        NSLog(@"Face up Width: %f Height: %f",self.frame.size.width, self.frame.size.height);
        if (self.frame.size.width*2.5 < self.frame.size.height) {
            orientation = UIDeviceOrientationPortrait;
            faceUpPortrait = YES;
        }        
    }
    
    if (orientation == UIDeviceOrientationUnknown ||
        orientation == UIDeviceOrientationPortrait ||
        orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        //Portrait - 1 coulum of 6 instruments
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
