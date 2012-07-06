//
//  Instrument.h
//  FlightGearMap
//
//  Created by Jason Crane on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Instrument : UIView

- (id)initWithImage:(NSString *)fileName;

@property (readonly, strong) UIImage *image;


@end
