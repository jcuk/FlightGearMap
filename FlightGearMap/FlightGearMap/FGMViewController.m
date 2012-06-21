//
//  ASTViewController.m
//  FlightGearMap
//
//  Created by Jason Crane on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FGMViewController.h"
#import "TelnetPositionClient.h"
#import <CoreLocation/CoreLocation.h>

#define START_LAT 39.281516
#define START_LON -76.580806


@implementation FGMViewController
@synthesize _mapView,_planeView,_altitudeLabel;

TelnetPositionClient *client;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)updatePosition:(double)lon lat:(double)latitude altitudeInFt:(double)alt updateZoom:(bool)zoom {
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = latitude;
    zoomLocation.longitude= lon;
    
    if (zoom) {
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 2*METERS_PER_MILE, 2*METERS_PER_MILE);
        
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
    } else {
        
        [_mapView setCenterCoordinate:zoomLocation animated:YES];
    }
    
    _altitudeLabel.text = [NSString stringWithFormat:@"Alt: %dft",(int)alt];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    if (!client) {
        [self updatePosition:START_LON lat:START_LAT altitudeInFt:0 updateZoom:YES];
        
        client = [[TelnetPositionClient alloc]init:self];
    
        [client start];
    
        [NSTimer scheduledTimerWithTimeInterval:.2 target:client selector:@selector(requestNewPosition) userInfo:nil repeats:YES]; 
    }
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
        infoRectV = CGRectMake(200,200,368,500);
        infoRectH = CGRectMake(262,200,500,368);
        
    } else {
        infoRectV = CGRectMake(30,35,260,325);
        infoRectH = CGRectMake(70,7,340,210);
    }
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        infoView = [[InfoView alloc]initWithFrame:infoRectH];
    } else {
        infoView = [[InfoView alloc]initWithFrame:infoRectV];
    }
    
    [self.view addSubview:infoView];
    infoView.hidden = YES;
    [infoView setUserInteractionEnabled:NO];

    
}

- (void)viewDidUnload
{
    [self set_mapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)updatePosition:(double)lon lat:(double)latitude altInFt:(double)alt {
    [self updatePosition:lon lat:latitude altitudeInFt:alt updateZoom:NO];
}

-(void)updateHeading:(double)heading {
    CGAffineTransform rotate = CGAffineTransformMakeRotation( heading / 180.0 * 3.14 );
    [_planeView setTransform:rotate];
    
}

- (void)viewWillAppear:(BOOL)animated {
     
}

#pragma mark - delagate methods for config
- (void)configViewControllerDidCancel:(UIConfigController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)reconnectClient:(NSString *)machine port:(NSString *)portNum {
    client.address  = machine;
    client.port     = portNum;
    [client stop];
    [client start];
    
}

- (void)configViewControllerDidSave:(UIConfigController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self reconnectClient:[controller.machineAddress text] port:[controller.port text]];
}

- (void)configViewControllerConnect:(UIConfigController *)controller {
    [self reconnectClient:[controller.machineAddress text] port:[controller.port text]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Config"])
	{
		UIConfigController  *configViewController = segue.destinationViewController;
		configViewController.delegate = self;
        
        NSLog(@"Machine in seque: %@",client.address);
        [configViewController.machineAddress setText:client.address];
        [configViewController.port setText:client.port];
        
	}
}

//TODO: i button

//infoView.hidden = NO;
//[infoView setUserInteractionEnabled:YES];

-(IBAction) infoPressed:(id)sender {
    
}




@end
