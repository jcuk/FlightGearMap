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

#define INFO_TEXT @"<html><head><style>body{background-color:transparent; font-family:helvetica} h3{text-align:center;}</style></head><body><h3>Flight Gear Map</h3><p>Live map for use with <a href=""www.flightgear.org"">FlightGear</a>, the open source flight simulator</p><p>To use flight gear map, you must have FlightGear running with the Telnet option enabled e.g.:</p><code>fgfs --telnet={port number}</code><p>where <code>{port number}</code> is the telnet port number you wish to use. (If you are unsure try port 9999) On the configuration screen, enter the name or IP address of the machine flight gear is running on, and the telnet port number. Tap Done and FlightGear Map will connect to your FlightGear instance.<br><center>Jason Crane 2012</center></br></body></html>"


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

-(void)reconnectClient:(NSString *)machine port:(NSString *)portNum {
    client.address  = machine;
    client.port     = portNum;
    [client stop];
    [client start];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    if (!client) {
        //load data
        NSString *errorDesc = nil;
        
        NSPropertyListFormat format;
        
        NSString *plistPath;
        
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        
        plistPath = [rootPath stringByAppendingPathComponent:@"save.plist"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            
            plistPath = [[NSBundle mainBundle] pathForResource:@"save" ofType:@"plist"];
            
        }
        
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                              
                                              propertyListFromData:plistXML
                                              
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              
                                              format:&format
                                              
                                              errorDescription:&errorDesc];
        
        if (!temp) {
            
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
            
        }
        
        NSString *port = [temp objectForKey:@"port"];
        NSString *machine = [temp objectForKey:@"machine"];
        
        [self updatePosition:START_LON lat:START_LAT altitudeInFt:0 updateZoom:YES];
        
        client = [[TelnetPositionClient alloc]init:self];
        
        if ([port length] > 0 && [machine length] > 0) {
            [self reconnectClient:machine port:port];
        }
    
        [client start];
    
        [NSTimer scheduledTimerWithTimeInterval:.5 target:client selector:@selector(requestNewPosition) userInfo:nil repeats:YES]; 
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

- (void)configViewControllerDidSave:(UIConfigController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([controller.machineAddress.text length] > 0 && [controller.port.text length] > 0) {
        //Save data
        NSString *error;
        
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"save.plist"];
        
        NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                [NSArray arrayWithObjects: controller.port.text, controller.machineAddress.text, nil]
                forKeys:[NSArray arrayWithObjects: @"port", @"machine", nil]];
        
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
        
        if(plistData) {
            
            [plistData writeToFile:plistPath atomically:YES];
            
        }
        
        else {
            NSLog(@"Error writing data: %@",error);
            
        }
        [self reconnectClient:[controller.machineAddress text] port:[controller.port text]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Config"])
	{
		UIConfigController  *configViewController = segue.destinationViewController;
		configViewController.delegate = self;
        
        //lForce the view to load
        [configViewController view];
        
        NSLog(@"Machine in segue: %@",client.address);
        
        if (!configViewController) {
            NSLog(@"cvg null");
        }
        
        if (!configViewController.machineAddress) {
            NSLog(@"Machine address null");
        }
        
        [configViewController.machineAddress setText:client.address];
        [configViewController.port setText:client.port];
        
	}
}

-(IBAction) infoPressed:(id)sender {
    [infoView setText:INFO_TEXT];
    if (infoView.hidden) {
        infoView.hidden = NO;
        [infoView setUserInteractionEnabled:YES];
    } else {
        infoView.hidden = YES;
        [infoView setUserInteractionEnabled:NO];
    }
    
}




@end
