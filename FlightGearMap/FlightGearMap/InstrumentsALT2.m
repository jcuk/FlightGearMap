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
    self = [super initWithFilename:fileName hand:handFilename digits:digitsName dataType:ALTITUDE];
    if (self) {
        
    }
    return self;
}

@end
