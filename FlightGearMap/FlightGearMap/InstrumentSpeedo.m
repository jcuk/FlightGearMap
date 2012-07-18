//
//  InstrumentSpeedo.m
//  FlightGearMap
//
//  Created by Jason Crane on 16/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentSpeedo.h"

@implementation InstrumentSpeedo

-(id)initWithFilename:(NSString *)fileName {
    self = [super initWithFilename:fileName hand:@"hand1.png" dataType:SPEED min:0 max:200 minAngle:0 maxAngle:320];
    if (self) {
        
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
    
    float angle;
    
    //Correct for non-linarity of speedo
    if (value < 40) {
        angle = value / 2;
    } else {
        angle =  -0.0061147f * value * value + 3.3f * value - 104.5f;
    }
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(angle/360 * 2 * PI);
    [_handView setTransform:rotate];
}

@end
