//
//  Config.m
//  FlightGearMap
//
//  Created by Jason Crane on 23/03/2015.
//
//

#import "Config.h"
#import <MapKit/MapKit.h>

@implementation Config

-(id)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSString *version = [dictionary objectForKey:@"version"];
        NSNumber *port = [dictionary objectForKey:@"port"];
        NSString *instruments = [dictionary objectForKey:@"instruments"];
        NSNumber *mapType = [dictionary objectForKey:@"mapType"];
        NSString *instrumentType = [dictionary objectForKey:@"instrumentType"];
        
        if ([version isEqualToString:@"1.5"]) {
            _port = [port intValue];
        } else {
            NSString *stPort = [dictionary objectForKey:@"port"];
            if ([stPort length]==0) {
                _port = 9999; //Default port
            } else {
                _port = [stPort intValue];
            }
        }
        
        if (!mapType) {
            _mapType = (MapType)MKMapTypeStandard;
        } else {
            _mapType = [mapType intValue];
        }
                
        if (instrumentType) {
            _instrumentType = [instrumentType intValue];
        } else if (!instruments && !instrumentType) {
            _instrumentType = PROP_INSTRUM;
        }
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    Config *copy = [[[self class]alloc]init];
    if (copy) {
        copy.port = self.port;
        copy.instrumentType = self.instrumentType;
        copy.mapType = self.mapType;
    }
    return copy;
}

-(void)persist {
    //Save data
    NSString *error;
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"save.plist"];
    
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                               [NSArray arrayWithObjects:
                                @"1.5",
                                [NSNumber numberWithInt:_port],
                                [NSNumber numberWithInt:_instrumentType],
                                [NSNumber numberWithInt:_mapType],
                                nil]
                                                          forKeys:[NSArray arrayWithObjects: @"version", @"port", @"instrumentType", @"mapType", nil]];
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    } else {
        NSLog(@"Error writing data: %@",error);
    }
}

@end
