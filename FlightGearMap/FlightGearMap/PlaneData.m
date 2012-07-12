//
//  PlaneData.m
//  FlightGearMap
//
//  Created by Jason Crane on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaneData.h"
#import <Foundation/Foundation.h>

@implementation PlaneData

NSMutableDictionary *data;

-(NSString *)makeKey:(PlaneDataType)dataType {
    return [NSString stringWithFormat:@"%d",dataType];
}

-(id) init {
    self = [super init];
    if (self) {
        data = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(NSNumber *)getDataValue:(PlaneDataType)dataType {
    return [data objectForKey:[self makeKey:dataType]];
}

-(void)addData:(double)value dataType:(PlaneDataType)dataType {
    [data setObject:[[NSNumber alloc]initWithDouble:value] forKey:[self makeKey:dataType]];
}

@end
