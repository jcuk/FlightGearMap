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
    self = [super initWithFilename:fileName hand:@"hand1" dataType:SPEED min:0 max:450 minAngle:0 maxAngle:335];
    if (self) {
        UIImage *digits = [UIImage imageNamed:@"jet-asi-digits"];
        digit1 = [[UIImageView alloc]initWithImage:digits];
        digit2 = [[UIImageView alloc]initWithImage:digits];
        digit3 = [[UIImageView alloc]initWithImage:digits];
        
        NSLog(@"Frame %f %f",self.frame.size.width, self.frame.size.height);
        
        CGRect frame = CGRectMake(0, 0, self.frame.size.width*0.375,
            self.frame.size.height*0.625);
        
        digitsView = [[UIView alloc]initWithFrame:frame];
        digitsView.clipsToBounds = YES;
        
        [self addSubviewBehind:digitsView];
        
        [digitsView addSubview:digit1];
        [digitsView addSubview:digit2];
        [digitsView addSubview:digit3];
        
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
    
    //Calibrate speed
    if (value > 450) {
        angle = 333;
    } else if (value > 300) {
        angle = value*0.42 + 144;
    } else if (value > 250) {
        angle = value*0.5 + 120;
    } else if (value > 100) {
        angle = value*1.25 - 70; //Not sure from here...
    } else if (value > 75){
        angle = value*2.2 - 165;
    } else {
        angle = 0.0f;
    }
     
    CGAffineTransform rotate = CGAffineTransformMakeRotation(angle/360 * 2 * PI);
    [_handView setTransform:rotate];
 
    //Set up digits in window of ASI
    float xoff = digit1.frame.size.width;
    float yoff = digit1.frame.size.height * 0.8325;

    float digitHeight = digit1.frame.size.height *0.088372;
    
    float fraction = value - (int)value;
    float units = ((int)value % 10) + fraction;
    float tens = (((int)value % 100) - ((int)value % 10)) / 10;
    if (units >= 9) {
        tens += fraction;
    }
    float hundreds = (((int)value % 1000) - ((int)value % 100)) / 100;
    if (tens >= 9) {
        hundreds += fraction;
    }
    
    CGAffineTransform translate1 = CGAffineTransformMakeTranslation(xoff*2, -yoff + units * digitHeight);
    [digit1 setTransform:translate1];
    
    CGAffineTransform translate2 = CGAffineTransformMakeTranslation(xoff, -yoff + tens * digitHeight);
    [digit2 setTransform:translate2];
    
    CGAffineTransform translate3 = CGAffineTransformMakeTranslation(0.0f, -yoff + hundreds * digitHeight);
    [digit3 setTransform:translate3];
    
}


@end
