//
//  UDPClient.h
//  FlightGearMap
//
//  Created by Jason Crane on 16/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
#import "MapStatusUpdater.h"

@interface UDPClient : NSObject {
    GCDAsyncUdpSocket *socket;
    
}

@property int _port;

-(id)init:(int)port mapStatusUpdater:(NSObject <MapStatusUpdater> *)updater;
-(void) reconnectToNewPort:(int)port;

@end
