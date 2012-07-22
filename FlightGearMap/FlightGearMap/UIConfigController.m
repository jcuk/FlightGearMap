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

#define COMMAND_OPTION @"fgfs --generic=socket,out,5,%@,%@,udp,mobatlas"
#define ERROR @"error"

@implementation UIConfigController

bool inEmail = NO;

@synthesize delegate, port, instruments, mapType, commandOption;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:nil];	
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (NSString *)getIPAddress {
    
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

-(void)updateCommandOptionsLabel {
    NSString *ipAddress = [self getIPAddress];
    
    if ([ipAddress isEqualToString:ERROR]) {
        [commandOption setText:@"You need to connect to WiFi to talk to FlightGear!"];
    } else {
        [commandOption setText:[NSString stringWithFormat:COMMAND_OPTION , ipAddress, port.text]];
    }
    
    
}

-(IBAction)portValueChanged:(id)sender {
    [self updateCommandOptionsLabel];
}

#pragma mark -- Text field delegate methods

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder]; 
    return YES;
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
    [picker setSubject:@"Mobatlas.xml confg file for FlightGear"];
    
    NSData *fileData = [NSData dataWithContentsOfFile:@"mobatlas.xml"];
    [picker addAttachmentData:fileData mimeType:@"application/xml" fileName:@"mobatlas.xml"];
    
    NSString *emailBody = @"<p>This is the mobatlas.xml config file for FlightGear to connect with the FlightGear Map mobile app. Place this file in the FG_ROOT/Protocol directory, and start flight gear with the command:</p><code>fgfs --generic=socket,out,5,{ip address of your device},{port number},udp,mobatlas</code><p>To find the ip address and port number your device is using then open the config screen on FlightGear on your iPhone or iPad. This will show the exact option to start FlightGear with.</p>";
    [picker setMessageBody:emailBody isHTML:YES];
    
    [self presentModalViewController:picker animated:YES];
    
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
    
    inEmail = NO;
}


@end
