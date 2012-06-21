//
//  UIConfigController.h
//  FlightGearMap
//
//  Created by Jason Crane on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIConfigController;

@protocol UIConfigControllerDelagate <NSObject>
- (void)configViewControllerDidCancel:(UIConfigController *)controller;
- (void)configViewControllerDidSave:(UIConfigController *)controller;
- (void)configViewControllerConnect:(UIConfigController *)controller;

@end

@interface UIConfigController : UIViewController {
    IBOutlet UILabel *connectionStatus;
}

@property (nonatomic, weak) id <UIConfigControllerDelagate> delegate;
@property (nonatomic, retain) IBOutlet UITextField *machineAddress;
@property (nonatomic, retain) IBOutlet UITextField *port;

-(IBAction)connect:(id)sender;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;


@end
