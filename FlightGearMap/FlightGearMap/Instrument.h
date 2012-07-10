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

@interface Instrument : UIImageView

- (id)initWithFilename:(NSString *)fileName;
-(void)addSubviewInFront:(UIView *)view;
-(void)addSubviewBehind:(UIView *)view;

@property (weak) PlaneData* planeData;

@end
