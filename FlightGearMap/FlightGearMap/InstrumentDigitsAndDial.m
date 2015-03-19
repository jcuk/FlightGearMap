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

@end
