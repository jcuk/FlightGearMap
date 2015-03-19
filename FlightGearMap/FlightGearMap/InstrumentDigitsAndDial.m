//
//  InstrumentsDigitsAndDial.m
//  FlightGearMap
//
//  Created by Jason Crane on 19/03/2015.
//
//

#import "InstrumentDigitsAndDial.h"

@implementation InstrumentDigitsAndDial

-(id)initWithFilename:(NSString *)fileName hand:(NSString*)handFilename digits:(NSString *)digitsName dataType:(PlaneDataType)planeDataType {
    self = [super initWithFilename:fileName hand:handFilename dataType:planeDataType min:0 max:450 minAngle:0 maxAngle:335];
    if (self) {
        UIImage *digits = [UIImage imageNamed:digitsName];
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
        
        //Force the layout to speed 000
        [self updatePlaneData:nil];
        
    }
    return self;
}

-(void)updatePlaneData:(PlaneData *)planeData {
    
    [super updatePlaneData:planeData];
    
    NSNumber *dataValue = [planeData getDataValue:_planeDataType];
    
    //Default to 0 if no data available
    float value=0;
    
    if (dataValue) {
        value = [dataValue floatValue];
    }
    
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

-(float)getHandAngle:(float)value {
    return [super getHandAngle:value];
}

@end
