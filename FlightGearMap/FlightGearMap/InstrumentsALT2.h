//
//  InstrumentsALT2.h
//  FlightGearMap
//
//  Created by Jason Crane on 19/03/2015.
//
//

#import <Foundation/Foundation.h>

#import "InstrumentDigitsAndDial.h"

@interface InstrumentsALT2 : InstrumentDigitsAndDial {
    
}

-(id)initWithFilename:(NSString *)fileName hand:(NSString*)handFilename digits:(NSString *)digitsName;

@end
