//
//  InstrumentView.h
//  FlightGearMap
//
//  Created by Jason Crane on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaneData.h"

@interface InstrumentView : UIView {
    bool _fullScreenView;
}

-(void)updatePlaneData:(PlaneData *)planeData;
-(void)showPropInstruments:(bool)fullScreen;
-(void)showFastJetInstruments:(bool)fullScreen;

@end
