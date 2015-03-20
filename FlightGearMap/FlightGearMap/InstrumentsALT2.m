//
//  InstrumentsALT2.m
//  FlightGearMap
//
//  Created by Jason Crane on 19/03/2015.
//
//

#import "InstrumentsALT2.h"

@implementation InstrumentsALT2

-(id)initWithFilename:(NSString *)fileName hand:(NSString*)handFilename digits:(NSString *)digitsName {
    self = [super initWithFilename:fileName hand:handFilename digits:digitsName dataType:ALTITUDE digitsXFrame:0.75f digitsYFrame:0.3f];
    if (self) {
        
    }
    return self;
}

-(float)getHandAngle:(float)value {
    //100 ft per revolution
    float ft = fmod(value,100.0f);
    return ft / 100 * 360 ;
}

-(NSArray *)getDigits:(float)value {
    //Dial is in 1000s and 100s of feet
    return [super getDigits:value / 100];
}

@end
