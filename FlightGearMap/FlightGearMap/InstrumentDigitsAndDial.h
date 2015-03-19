//
//  InstrumentsDigitsAndDial.h
//  FlightGearMap
//
//  Created by Jason Crane on 19/03/2015.
//
//

#import <Foundation/Foundation.h>
#import "InstrumentGeneric.h"

//An instrument with numeric digits and a hand
@interface InstrumentDigitsAndDial : InstrumentGeneric {
    @private UIView *digitsView;
    @protected UIView *digit1;
    @protected UIView *digit2;
    @protected UIView *digit3;
    
    float xoff;
    float yoff;
}

-(id)initWithFilename:(NSString *)fileName hand:(NSString*)handFilename digits:(NSString *)digitsName dataType:(PlaneDataType)planeDataType;
-(void)setDigitOffsets;
-(NSArray *)getDigits:(float)value;

@end
