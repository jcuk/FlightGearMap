//
//  Config.h
//  FlightGearMap
//
//  Created by Jason Crane on 23/03/2015.
//
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@interface Config : UITableViewCell {
    
}

@property InstrumentType instrumentType;
@property MapType mapType;
@property int port;

-(id)initFromDictionary:(NSDictionary *)dictionary;
-(void)persist;

@end
