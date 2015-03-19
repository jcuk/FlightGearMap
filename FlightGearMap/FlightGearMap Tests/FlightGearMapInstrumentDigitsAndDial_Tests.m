//
//  FlightGearMap_Tests.m
//  FlightGearMap Tests
//
//  Created by Jason Crane on 19/03/2015.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "InstrumentDigitsAndDial.h"

@interface FlightGearMap_InstrumentDigitsAndDialTests : XCTestCase

@end

@implementation FlightGearMap_InstrumentDigitsAndDialTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNormalDigits {
    InstrumentDigitsAndDial *iad = [[InstrumentDigitsAndDial alloc]init];
    
    NSArray *digits = [iad getDigits:123.45f];
    XCTAssertEqualWithAccuracy(1.0f,  [[digits objectAtIndex:0]floatValue], 0.01f);
    XCTAssertEqualWithAccuracy(2.0f,  [[digits objectAtIndex:1]floatValue], 0.01f);
    XCTAssertEqualWithAccuracy(3.45f, [[digits objectAtIndex:2]floatValue], 0.01f);
}

- (void)testDigitsRollingOver {
        InstrumentDigitsAndDial *iad = [[InstrumentDigitsAndDial alloc]init];
    
    NSArray *digits = [iad getDigits:499.9f];
    XCTAssertEqualWithAccuracy(4.9f, [[digits objectAtIndex:0]floatValue], 0.01f);
    XCTAssertEqualWithAccuracy(9.9f, [[digits objectAtIndex:1]floatValue], 0.01f);
    XCTAssertEqualWithAccuracy(9.9f, [[digits objectAtIndex:2]floatValue], 0.01f);

}


@end
