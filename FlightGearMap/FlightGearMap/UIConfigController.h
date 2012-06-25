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
@end

@interface UIConfigController : UIViewController {
    IBOutlet UITextField *machineAddress;
    IBOutlet UITextField *port;
}

@property (nonatomic, weak) id <UIConfigControllerDelagate> delegate;
@property (strong) IBOutlet UITextField *machineAddress;
@property (strong) IBOutlet UITextField *port;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;


@end