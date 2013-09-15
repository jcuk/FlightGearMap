//
//  ASTViewController.h
//  FlightGearMap
//
//  Created by Jason Crane on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapStatusUpdater.h"
#import "UIConfigController.h"
#import "InstrumentView.h"

#define METERS_PER_MILE 1609.344

@interface FGMViewController : UIViewController <MapStatusUpdater, UIConfigControllerDelagate> {
    @private bool _doneInitialZoom; 
}

@property (weak, nonatomic) IBOutlet MKMapView *_mapView;
@property (weak, nonatomic) IBOutlet UIImageView *_planeView;
@property (weak, nonatomic) IBOutlet InstrumentView *_instrumentView;

@end
