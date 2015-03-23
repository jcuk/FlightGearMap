//
//  UIConfigController.m
//  FlightGearMap
//
//  Created by Jason Crane on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIConfigController.h"
#import "ifaddrs.h"
#import <arpa/inet.h>

#import "PortConfigCell.h"
#import "StartCommandCell.h"
#import "Constants.h"

#define COMMAND_OPTION @"fgfs --generic=socket,out,5,%@,%d,udp,mobatlas"
#define ERROR @"error"

@implementation UIConfigController

bool inEmail = NO;

@synthesize delegate, port, mapType, commandOption;

enum groupTypes {NETWORK, INSTRUMENTS, MAP};
enum networkCells {PORT, RUN, CONFIG};

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:nil];
    
        [ok setNavigationButtonWithColor: [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f]];
    
        [cancel setNavigationButtonWithColor: [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f]];
    
        [email setNavigationButtonWithColor: [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f]];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    
    return (interfaceOrientation==UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    return (orientation==UIDeviceOrientationPortrait);
}

//This should fix the keyboard not being dismissed 
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}


#pragma mark - Buttons

- (IBAction)cancel:(id)sender
{
	[self.delegate configViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
	[self.delegate configViewControllerDidSave:self];
}

+ (NSString *)getIPAddress {
    
    NSString *address = ERROR;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
} 

-(NSString *)fgfsCommand {
    NSString *ipAddress = [UIConfigController getIPAddress];
    return [NSString stringWithFormat:COMMAND_OPTION , ipAddress, _config.port];
}

//TODO remove this
-(void)updateCommandOptionsLabel {
    NSString *ipAddress = [UIConfigController getIPAddress];
    
    if ([ipAddress isEqualToString:ERROR]) {
        [commandOption setText:@"You need to connect to WiFi to talk to FlightGear!"];
    } else {
        [commandOption setText:[self fgfsCommand]];
    }
}

-(NSString *)getCommandOption {
    NSString *ipAddress = [UIConfigController getIPAddress];
    
    if ([ipAddress isEqualToString:ERROR]) {
        return @"You need to connect to WiFi to talk to FlightGear!";
    } else {
        return [self fgfsCommand];
    }
}


-(IBAction)portValueChanged:(id)sender {
    [self updateCommandOptionsLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -- Text field delegate methods

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder]; 
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    //Only copes with one field. Need to get superview, to get cell then look up in table if >1 text field is used
    
    NSLog(@"%@",[textField text]);
}

- (void)addButtonToKeyboard {
	// create custom button
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(0, 163, 106, 53);
	doneButton.adjustsImageWhenHighlighted = NO;
    [doneButton setImage:[UIImage imageNamed:@"DoneUp"] forState:UIControlStateNormal];
    [doneButton setImage:[UIImage imageNamed:@"DoneDown"] forState:UIControlStateHighlighted];
	[doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
	// locate keyboard view
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView* keyboard;
	for(int i=0; i<[tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard found, add the button
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
			if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
				[keyboard addSubview:doneButton];
		} else {
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
				[keyboard addSubview:doneButton];
		}
	}
}

-(void)doneButton:(id)sender {
    [port resignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification *)note {
    //Only use extra Done button on config screen for iPhone, not on wmail screen or for iPad at all
    if (!inEmail &&  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self addButtonToKeyboard];
    }
}

#pragma mark -- Email delegate methods

-(IBAction)emailConfig:(id)sender {
    inEmail = YES;
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = self;
    [picker setSubject:@"mobatlas.xml confg file for FlightGear"];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mobatlas" ofType:@"xml"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [picker addAttachmentData:fileData mimeType:@"application/xml" fileName:@"mobatlas.xml"];
    
    NSString *emailBody = [NSString stringWithFormat:@"<p>This is the mobatlas.xml config file for FlightGear to connect with the FlightGear Map mobile app. Place this file in the FG_ROOT/Protocol directory, and start flight gear with the command:</p><p><code>%@</code></p><p> NB this command needs to change if the IP address of your device changes or you change the UDP port on FlightGearMap. The correct command is always listed on the FlightGearMap setup page on your iPhone or iPad.</p><p>For tips, support or to report a bug or request a new feature, please visit the FlightGearMap thread on the FlightGear support forums at:</p><p><a href='http://www.flightgear.org/forums/viewtopic.php?f=31&t=16900'>http://www.flightgear.org/forums/viewtopic.php?f=31&t=16900</a></p><p>Happy Landings!</p>",[self fgfsCommand]];
    [picker setMessageBody:emailBody isHTML:YES];
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if (result == MFMailComposeResultSent) {
        NSLog(@"Mail sent");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil]; 
    
    inEmail = NO;
}

#pragma mark data table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case NETWORK:
            return 3;
        case INSTRUMENTS:
            return 3;
        case MAP:
            return 4;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    
    //Calculate cell type
    if (indexPath.section == NETWORK) {
        switch (indexPath.row) {
            case PORT:
                cellIdentifier = @"PortCell";
                break;
            case RUN:
                cellIdentifier = @"StartCommandCell";
                break;
            case CONFIG:
                cellIdentifier = @"EmailConfigCell";
                break;
        }
        
    } else {
        cellIdentifier = @"CheckboxCell";
    }
    
    //Get correct cell type
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil) {
        if([cellIdentifier isEqualToString:@"PortCell"]) {
            cell=[[PortConfigCell alloc]
                  initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
        } else if ([cellIdentifier isEqualToString:@"StartCommandCell"]) {
            cell=[[StartCommandCell alloc]
                  initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
        } else {
            cell=[[UITableViewCell alloc]
              initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
        }
    }
    
    //Update cells with current value
    switch (indexPath.section) {
        case NETWORK:
            switch (indexPath.row) {
                case PORT:
                    [((PortConfigCell *)cell).portField setText:[NSString stringWithFormat:@"%d",_config.port]];
                    break;
                case RUN:
                    [((StartCommandCell *)cell).label setText:[self getCommandOption]];
                    break;
                case CONFIG:
                    break;
            }
            break;
        case INSTRUMENTS:
            if (indexPath.row == _config.instrumentType) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            switch (indexPath.row) {
                case NO_INSTRUMENTS:
                    cell.textLabel.text = @"No Instruments";
                    break;
                case PROP_INSTRUM:
                    cell.textLabel.text = @"Prop";
                    break;
                case JET_INSTRUM:
                    cell.textLabel.text = @"Jet";
                    break;
            }
            break;
        case MAP:
            if (indexPath.row == _config.mapType) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            switch (indexPath.row) {
                case SATELLITE:
                    cell.textLabel.text = @"Satellite";
                    break;
                case STANDARD:
                    cell.textLabel.text = @"Standard";
                    break;
                case HYBRID:
                    cell.textLabel.text = @"Hybrid";
                    break;
                case FULLSCREEN:
                    cell.textLabel.text = @"Full Screen";
                    break;
            }
            break;
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Network";
        case 1:
            return @"Instruments";
        case 2:
            return @"Map";
        default:
            return @"";
            
    }
}


@end
