//
//  FlightGearMap_ASI2Tests.m
//  FlightGearMap
//
//  Created by Jason Crane on 19/03/2015.
//
//

#import <XCTest/XCTest.h>

#import "InstrumentsALT2.h"

@interface FlightGearMap_ALT2Tests : XCTestCase

@end

@implementation FlightGearMap_ALT2Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNormalDigits {
    InstrumentsALT2 *alt2 = [[InstrumentsALT2 alloc]init];
    
    NSArray *digits = [alt2 getDigits:30123.0f];
    XCTAssertEqualWithAccuracy(3.0f,  [[digits objectAtIndex:0]floatValue], 0.01f);
    XCTAssertEqualWithAccuracy(0.0f,  [[digits objectAtIndex:1]floatValue], 0.01f);
    XCTAssertEqualWithAccuracy(1.23f, [[digits objectAtIndex:2]floatValue], 0.01f);
}

- (void)testDigitsRollingOver {
    InstrumentsALT2 *alt2 = [[InstrumentsALT2 alloc]init];
    
    NSArray *digits = [alt2 getDigits:39950.0f];
    XCTAssertEqualWithAccuracy(3.5f,  [[digits objectAtIndex:0]floatValue], 0.01f);
    XCTAssertEqualWithAccuracy(9.5f,  [[digits objectAtIndex:1]floatValue], 0.01f);
    XCTAssertEqualWithAccuracy(9.5f, [[digits objectAtIndex:2]floatValue], 0.01f);
}

@end
