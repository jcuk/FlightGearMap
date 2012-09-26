//
//  MapStatusUpdater.h
//  FlightGearMap
//
//  Created by Jason Crane on 19/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaneData.h"

@protocol MapStatusUpdater <NSObject>

-(void)updateFlightData:(PlaneData *)planeData;

@end
