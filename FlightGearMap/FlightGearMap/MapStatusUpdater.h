//
//  MapStatusUpdater.h
//  FlightGearMap
//
//  Created by Jason Crane on 19/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MapStatusUpdater <NSObject>
-(void)updatePosition:(double)lon lat:(double)latitude altInFt:(double)alt;
-(void)updateHeading:(double)heading;

@end
