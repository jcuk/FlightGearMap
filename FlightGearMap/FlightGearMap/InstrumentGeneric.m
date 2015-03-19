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
        _handView = [super addHand:handFilename off:0.0 inFront:YES];   
        _planeDataType = planeDataType;
        _minVal = minValue;
        _maxVal = maxValue;
        _maxAngle = maxHandAngle;
        _minAngle = minHandAngle;
        
        PlaneData *planeData = [[PlaneData alloc]init];
        
        [self updatePlaneData:planeData];
    }
    
    return self;
}

-(void)updatePlaneData:(PlaneData *)planeData {
    NSNumber *dataValue = [planeData getDataValue:_planeDataType];
    
    //Default to 0 if no data available
    float value=0;

    if (dataValue) {
        value = [dataValue floatValue];
    }
    
    float angle = [self getHandAngle:value];
        
    CGAffineTransform rotate = CGAffineTransformMakeRotation(angle/360 * 2 * PI);
    [_handView setTransform:rotate];
}

-(float)getHandAngle:(float)value
{
    float prop = (value - _minVal)/(_maxVal-_minVal);
    return prop *(_maxAngle - _minAngle) + _minAngle;
}

@end
