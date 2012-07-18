//
//  UDPClient.m
//  FlightGearMap
//
//  Created by Jason Crane on 16/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UDPClient.h"
#import "PlaneData.h"
#import "MapStatusUpdater.h"

@implementation UDPClient

NSObject <MapStatusUpdater> *mapStatusUpdater;
PlaneData *planeData;

-(void)stop {
    socket = nil;
}

-(id)init:(int)port mapStatusUpdater:(NSObject <MapStatusUpdater> *)updater {
    self = [super init];
    if (self) {
        mapStatusUpdater = updater;
        
        planeData = [[PlaneData alloc]init];
        socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *err;
        //TODO: config port
        [socket bindToPort:port error:&err];
    
        if (err) {
            NSLog(@"Error binding port %@",err);
        }
        
        [socket beginReceiving:&err];
        
        if (err) {
            NSLog(@"Error starting UDP socket");
        }
    }
    return self;
}

-(float)floatValue:(NSString *)string {
    return [string floatValue];
}

-(int)intValue:(NSString *)string {
    return [string intValue];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    //NSLog(@"Did recieve data %d",[data length]); 
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
   // NSLog(@"Message %@",msg);
    
    NSArray *strValues = [msg componentsSeparatedByString:@":"];
    
    [planeData addData:[self floatValue:    [strValues objectAtIndex:SPEED]]        dataType:SPEED];
    [planeData addData:[self intValue:      [strValues objectAtIndex:RPM]]          dataType:RPM];
    [planeData addData:[self floatValue:    [strValues objectAtIndex:ALTITUDE]]     dataType:ALTITUDE];
    [planeData addData:[self floatValue:    [strValues objectAtIndex:CLIMB_RATE]]   dataType:CLIMB_RATE];
    [planeData addData:[self floatValue:    [strValues objectAtIndex:PITCH]]        dataType:PITCH];
    [planeData addData:[self floatValue:    [strValues objectAtIndex:ROLL]]         dataType:ROLL];
    [planeData addData:[self floatValue:    [strValues objectAtIndex:LATITUDE]]     dataType:LATITUDE];
    [planeData addData:[self floatValue:    [strValues objectAtIndex:LONGITUDE]]    dataType:LONGITUDE];
    [planeData addData:[self floatValue:    [strValues objectAtIndex:TURN_RATE]]    dataType:TURN_RATE];
    [planeData addData:[self floatValue:    [strValues objectAtIndex:SLIP]]         dataType:SLIP];
    [planeData addData:[self floatValue:    [strValues objectAtIndex:HEADING]]      dataType:HEADING];
    
    [mapStatusUpdater updateFlightData:planeData];
   
}


@end
