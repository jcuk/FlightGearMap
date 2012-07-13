//
//  Instrument.h
//  FlightGearMap
//
//  Created by Jason Crane on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drawable.h"
#import "PlaneData.h"


#define PI 3.141

@interface Instrument : UIImageView

- (id)initWithFilename:(NSString *)fileName;
-(void)addSubviewInFront:(UIView *)view;
-(void)addSubviewBehind:(UIView *)view;
-(void)updatePlaneData:(PlaneData *)planeData;
-(UIView *)addHand:(NSString *)fileName off:(double)offset inFront:(bool)front;
-(UIView *)addHandWithOffset:(NSString *)fileName off:(double)offset inFront:(bool)front;
-(CGSize)rootSize;

@end
