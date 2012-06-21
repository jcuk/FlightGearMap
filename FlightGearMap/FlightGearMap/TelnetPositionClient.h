//
//  TelnetPositionClient.h
//  FlightGearMap
//
//  Created by Jason Crane on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "MapStatusUpdater.h"

enum {DISCONNECTED, CONNECTED, CONNECTING, CANT_CONNECT};

@interface TelnetPositionClient : NSObject {
    GCDAsyncSocket *socket;
}

@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *port;
@property (atomic) int status;


-(id)init:(NSObject <MapStatusUpdater> *)updater;
-(void)start;
-(void)stop;

@end
