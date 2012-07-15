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
#import "PlaneData.h"

#define START_LAT 39.281516
#define START_LON -76.580806

#define INFO_TEXT @"<html><head><style>body{background-color:transparent; font-family:helvetica} h3{text-align:center;}</style></head><body><h3>Flight Gear Map</h3><p>Live map for use with <a href=""http://www.flightgear.org"">FlightGear</a>, the open source flight simulator</p><p>To use flight gear map, you must have FlightGear running with the Telnet option enabled e.g.:</p><code>fgfs --telnet={port number}</code><p>where <code>{port number}</code> is the telnet port number you wish to use. (If you are unsure try port 9999) On the configuration screen, enter the name or IP address of the machine flight gear is running on, and the telnet port number. Tap Done and FlightGear Map will connect to your FlightGear instance.<br><center>Jason Crane 2012</center></br></body></html>"


@implementation FGMViewController
@synthesize _mapView,_planeView,_altitudeLabel,_instrumentView, _titleLabel;

TelnetPositionClient *client;
PlaneData *planeData;

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
    
    //TODO: this should not be here. Move it to UDP code
    [planeData addData:alt dataType:ALTITUDE];
    [_instrumentView updatePlaneData:planeData];
    
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
        
//        NSString *version = [temp objectForKey:@"version"];
        NSString *port = [temp objectForKey:@"port"];
        NSString *machine = [temp objectForKey:@"machine"];
        NSString *instruments = [temp objectForKey:@"instruments"];
        NSNumber *mapType = [temp objectForKey:@"mapType"];
        
        if (mapType) {
            _mapView.mapType = [mapType intValue];
        } else {
            _mapView.mapType = MKMapTypeStandard;
        }
        
        [self updatePosition:START_LON lat:START_LAT altitudeInFt:0 updateZoom:YES];
        [self makeInstrumentsVisible:![@"N" isEqualToString:instruments]];
        
        client = [[TelnetPositionClient alloc]init:self];
        
        if ([port length] > 0 && [machine length] > 0) {
            [self reconnectClient:machine port:port];
        }
    
        [NSTimer scheduledTimerWithTimeInterval:1 target:client selector:@selector(requestNewPosition) userInfo:nil repeats:YES]; 
    } else {
        [client stop];
        [client start];
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
    
    planeData = [[PlaneData alloc]init];
    
    [self.view addSubview:infoView];
    infoView.hidden = YES;
    [infoView setUserInteractionEnabled:NO];

    
}

- (void)viewDidUnload
{
    [infoView removeFromSuperview];
    [self set_mapView:nil];
    [super viewDidUnload];
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
    //Rotate info view
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        infoView.frame = infoRectV;
    } else {
        infoView.frame = infoRectH;
    }
    [infoView setNeedsDisplay];
    
    return YES;
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

-(void) makeInstrumentsVisible:(bool)visible {
    //TODO: animate
    _instrumentView.hidden = !visible;
    if (visible) {
        _mapView.frame = CGRectMake(_instrumentView.frame.size.width, _mapView.frame.origin.y,
            _mapView.frame.size.width-_instrumentView.frame.size.width, _mapView.frame.size.height);
    } else {
        //TODO adjust for orientation
        _mapView.frame = CGRectMake(0, _mapView.frame.origin.y,
            self.view.frame.size.width, _mapView.frame.size.height);
    }
    
    _planeView.center = _mapView.center;
    
    _titleLabel.center = CGPointMake(_mapView.center.x, _titleLabel.center.y);
    

}

- (void)configViewControllerDidSave:(UIConfigController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //Save data
    NSString *error;
        
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"save.plist"];
        
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                [NSArray arrayWithObjects: @"1.1", controller.port.text, controller.machineAddress.text, controller.instruments.isOn?@"Y":@"N", [NSNumber numberWithInt:controller.mapType.selectedSegmentIndex], nil]
                forKeys:[NSArray arrayWithObjects: @"version", @"port", @"machine", @"instruments", @"mapType", nil]];
        
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
        
    if(plistData) {
            
        [plistData writeToFile:plistPath atomically:YES];
            
    } else {
        NSLog(@"Error writing data: %@",error);
            
    }
    
    [self makeInstrumentsVisible:controller.instruments.isOn];
    
    if ([controller.machineAddress.text length] > 0 && [controller.port.text length] > 0) {
    
        [self reconnectClient:[controller.machineAddress text] port:[controller.port text]];
    }   
        
    _mapView.mapType = controller.mapType.selectedSegmentIndex;
    
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
        [configViewController.instruments setOn:!_instrumentView.isHidden];
        configViewController.mapType.selectedSegmentIndex = _mapView.mapType;
        
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
