//
//  InstrumentsASI2.h
//  FlightGearMap
//
//  Created by Jason Crane on 15/09/2013.
//
//

#import "InstrumentDigitsAndDial.h"

@interface InstrumentsASI2 : InstrumentDigitsAndDial {

}

-(id)initWithFilename:(NSString *)fileName hand:(NSString*)handFilename digits:(NSString *)digitsName;

@end
