//
//  InstrumentGeneric.m
//  FlightGearMap
//
//  Created by Jason Crane on 11/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentGeneric.h"
#import "PlaneData.h"

@implementation InstrumentGeneric

-(id)initWithFilename:(NSString *)fileName hand:(NSString *)handFilename dataType:(PlaneDataType)planeDataType
min:(float)minValue max:(float)maxValue minAngle:(float)minHandAngle maxAngle:(float)maxHandAngle {
    self = [super initWithFilename:fileName];
    if (self) {
        _handView = [super addHand:handFilename];   
        _planeDataType = planeDataType;
        _minVal = minValue;
        _maxVal = maxValue;
        _maxAngle = maxHandAngle;
        _minAngle = minHandAngle;
    }
    
    return self;
}

-(void)updatePlaneData:(PlaneData *)planeData {
    NSNumber *dataValue = [planeData getDataValue:_planeDataType];
    
    //Default to 0 if no data available
    double value=0;

    if (dataValue) {
        value = [dataValue doubleValue];
    }
    
    double prop = (value - _minVal)/(_maxVal-_minVal);
    double angle = prop *(_maxAngle - _minAngle) + _minAngle;
        
    CGAffineTransform rotate = CGAffineTransformMakeRotation(angle/360 * 2 * PI);
    [_handView setTransform:rotate];
}

@end
