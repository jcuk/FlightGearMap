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

UIView *_handView;
PlaneDataType _planeDataType;
float _minVal, _maxVal, _maxAngle,_minAngle;

-(id)initWithFilename:(NSString *)fileName hand:(NSString *)handFilename dataType:(PlaneDataType)planeDataType
max:(float)maxValue min:(float)minValue minAngle:(float)minHandAngle maxAngle:(float)maxHandAngle {
    self = [super initWithFilename:fileName];
    if (self) {
        _handView = [super addHand:handFilename];   
        _planeDataType = planeDataType;
        _minVal = minValue;
        _maxVal = maxValue;
    }
    
    return self;
}

-(void)updatePlaneData:(PlaneData *)planeData {
    NSNumber *dataValue = [planeData getDataValue:_planeDataType];
    double angle = 0;
    if (dataValue) {
        double prop = ([dataValue doubleValue] - _minVal)/_maxVal;
        angle = prop *(_maxAngle - _minAngle) + _minAngle;
    }
        
    CGAffineTransform rotate = CGAffineTransformMakeRotation(angle * 2 * PI);
    [_handView setTransform:rotate];
}

@end
