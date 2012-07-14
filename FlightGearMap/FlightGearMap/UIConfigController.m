//
//  UIConfigController.m
//  FlightGearMap
//
//  Created by Jason Crane on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIConfigController.h"

@implementation UIConfigController

@synthesize delegate, machineAddress, port, instruments;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        machineAddress = [[UITextField alloc]init];
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

@end
