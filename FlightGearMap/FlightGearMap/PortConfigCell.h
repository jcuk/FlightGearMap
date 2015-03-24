//
//  PortConfigCell.h
//  FlightGearMap
//
//  Created by Jason Crane on 22/03/2015.
//
//

#import <UIKit/UIKit.h>

@protocol PortUpdater <NSObject>

-(void)updatePort:(int)port;

@end

@interface PortConfigCell : UITableViewCell <UITextFieldDelegate> {

}

@property (nonatomic, strong) IBOutlet UITextField *portField;
@property (nonatomic, weak) NSObject<PortUpdater> *portUpdater;

@end
