//
//  InstrumentsASI2.m
//  FlightGearMap
//
//  Created by Jason Crane on 16/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentsASI2.h"

@implementation InstrumentsASI2

-(id)initWithFilename:(NSString *)fileName {
    //TODO: check speed values 
    self = [super initWithFilename:fileName hand:@"hand1" dataType:SPEED min:0 max:450 minAngle:0 maxAngle:335];
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
    
    if (value > 450) {
        angle = 333;
    } else if (value > 300) {
        angle = value*0.42 + 144;
    } else if (value > 250) {
        angle = value*0.5 + 120;
    } else if (value > 100) {
        angle = value*1.25 - 70;
    } else if (value > 75){
        angle = value*2.2 - 165;
    } else {
        angle = 0.0f;
    }
     
    CGAffineTransform rotate = CGAffineTransformMakeRotation(angle/360 * 2 * PI);
    [_handView setTransform:rotate];
    
    //TODO: add digits
}

//Digits

/* 
 
 Minor digit
 
 ldd ::= last digit + decimals eg ldd(123.4) = 3.4
 d   ::= digit of eg d(2, 123) = 2
 
 disp = ldd(x) * h
 if (ldd(x) > 9) {
    disp2 = ldd(x)+10 * h
 }
 
 Major digit n
 
disp = d(n, x) * h
if ((ldd(x)) > 9) {
  disp += ldd(x) * h //change from 9 to 0
}
 
 
 */

@end
