//
//  UIConfigController.h
//  FlightGearMap
//
//  Created by Jason Crane on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "UIGlossyButton.h"
#import "Constants.h"
#import "Config.h"
#import "PortConfigCell.h"

@class UIConfigController;

@protocol UIConfigControllerDelagate <NSObject>
- (void)configViewControllerDidCancel:(UIConfigController *)controller;
- (void)configViewControllerDidSave:(UIConfigController *)controller;
@end

@interface UIConfigController : UIViewController <MFMailComposeViewControllerDelegate, PortUpdater> {

}

@property (nonatomic, weak) id <UIConfigControllerDelagate> delegate;

@property Config *config;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

+ (NSString *)getIPAddress;

@end
