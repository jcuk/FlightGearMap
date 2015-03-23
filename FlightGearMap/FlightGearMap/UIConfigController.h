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

@class UIConfigController;

@protocol UIConfigControllerDelagate <NSObject>
- (void)configViewControllerDidCancel:(UIConfigController *)controller;
- (void)configViewControllerDidSave:(UIConfigController *)controller;
@end

@interface UIConfigController : UIViewController <UITextFieldDelegate,
MFMailComposeViewControllerDelegate> {
    @private IBOutlet UIGlossyButton *ok;
    @private IBOutlet UIGlossyButton *cancel;
    @private IBOutlet UIGlossyButton *email;
}

@property (nonatomic, weak) id <UIConfigControllerDelagate> delegate;

//TODO: replace old with new
//Old config
@property (strong) IBOutlet UITextField *port;
@property (strong) IBOutlet UISegmentedControl *instrumentType;
@property (strong) IBOutlet UISegmentedControl *mapType;
@property (strong) IBOutlet UILabel *commandOption;

@property Config *config;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)portValueChanged:(id)sender;

-(void)updateCommandOptionsLabel;
+ (NSString *)getIPAddress;

@end
