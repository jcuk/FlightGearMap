//
//  UDPClient.m
//  FlightGearMap
//
//  Created by Jason Crane on 16/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UDPClient.h"
#import "PlaneData.h"

@implementation UDPClient

-(void)stop {
    socket = nil;
}

-(id)init:(int)port {
    self = [super init];
    if (self) {
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

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    NSLog(@"Did recieve data %d",[data length]); 
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"Message %@",msg);
    
    NSArray *strValues = [msg componentsSeparatedByString:@":"];
    
    float speed = [self floatValue:[strValues objectAtIndex:0]];
    
    NSLog(@"Speed: %f",speed);

}


@end
