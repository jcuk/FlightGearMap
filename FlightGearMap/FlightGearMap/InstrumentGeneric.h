//
//  InstrumentGeneric.h
//  FlightGearMap
//
//  Created by Jason Crane on 11/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Instrument.h"

@interface InstrumentGeneric : Instrument {
    UIView *_handView;
    PlaneDataType _planeDataType;
    float _minVal, _maxVal, _maxAngle,_minAngle;
}

-(id)initWithFilename:(NSString *)fileName hand:(NSString *)handFilename dataType:(PlaneDataType)planeDataType
    min:(float)minValue max:(float)maxValue minAngle:(float)minHandAngle maxAngle:(float)maxHandAngle;
-(float)getHandAngle:(float)value;

@end
