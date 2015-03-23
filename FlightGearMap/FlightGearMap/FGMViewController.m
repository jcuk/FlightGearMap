//
//  FGMViewController.m
//  FlightGearMap
//
//  Created by Jason Crane on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FGMViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PlaneData.h"
#import "UDPClient.h"
#import "InfoViewController.h"

#define START_LAT 39.281516
#define START_LON -76.580806

#define RESET_PINCH_TIME 2.5f

@implementation FGMViewController
@synthesize _mapView,_planeView,_instrumentView;

PlaneData *planeData;
UDPClient *udpClient;

bool  _touchInProgress = NO;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //Handle pinch gestures for interuppting map updates while zooming
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [pinchGesture setDelegate:self];
        [_mapView addGestureRecognizer:pinchGesture];
    }
    return self;
}

-(void)updatePosition:(float)lon lat:(float)latitude altitudeInFt:(float)alt updateZoom:(bool)zoom
{
    //Zoom in progress. Supress updating position - it will override the zoom
    if (_touchInProgress) {
        return;
    }
    
    CLLocationCoordinate2D newLocation;
    newLocation.latitude = latitude;
    newLocation.longitude= lon;
    
    CLLocationCoordinate2D currentLocation = _mapView.camera.centerCoordinate;
    CLLocation *loc1 = [[CLLocation alloc]initWithLatitude:latitude longitude:lon];
    CLLocation *loc2 = [[CLLocation alloc]initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
    
    //Dont animate large jumps in distance. Speed is meters per 1/5s (update period)
    bool bigJump = ([loc1 distanceFromLocation:loc2] > 2000);
        
    if (zoom) {
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation, 2*METERS_PER_MILE, 2*METERS_PER_MILE);
        
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:NO];
                
    } else {
        
        [_mapView setCenterCoordinate:newLocation animated:!bigJump];
    }

}

-(void)updateFlightData:(PlaneData *)planeData {
    [_instrumentView updatePlaneData:planeData];
    
    float lat = [[planeData getDataValue:LATITUDE] floatValue];
    float lon = [[planeData getDataValue:LONGITUDE] floatValue];
    float alt = [[planeData getDataValue:ALTITUDE] floatValue];
    
    float head = [[planeData getDataValue:HEADING] floatValue];
    
    [self updatePosition:lon lat:lat altitudeInFt:alt updateZoom:false];
    
    [self updateHeading:head];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    if (!udpClient) {
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
            
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, (int)format);
            
        }
        
        _config = [[Config alloc]initFromDictionary:temp];
        
        [self updatePosition:START_LON lat:START_LAT altitudeInFt:0 updateZoom:YES];
        
        UIImage *plane = [UIImage imageNamed:@"plane"];
        _planeView.image = plane;
        
        [self updateStateFromConfig];

    }
    
    planeData = [[PlaneData alloc]init];
    
}

-(void)updateStateFromConfig {
    udpClient = [[UDPClient alloc]init:_config.port mapStatusUpdater:self] ;
    
    if (_config.mapType != FULLSCREEN) {
        _mapView.mapType = (MKMapType)_config.mapType;
    } else {
        _mapView.mapType = MKMapTypeStandard;
    }
    
    [self updateInstruments:_config.instrumentType];
}

- (void)viewDidUnload
{
    [self set_mapView:nil];
    [super viewDidUnload];
}

-(void)viewWillLayoutSubviews {
    [_instrumentView setNeedsLayout];
        
    int xOffset = _instrumentView.hidden?0:_instrumentView.frame.size.width / 2;
    
    CGFloat mapWidth = self.view.frame.size.width;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait ||
            [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
            mapWidth = 768;
        } else {
            mapWidth = 1024;
        }
        
    }
    
    CGRect mapFrame = CGRectMake(0, _mapView.frame.origin.y,
                                 mapWidth + xOffset,
                                 _mapView.frame.size.height);
    
    _mapView.frame = mapFrame;
    
    //Center plane in map view
    CGRect planeFrame = CGRectMake(mapFrame.size.width /2 - _planeView.frame.size.width /2,
                                   mapFrame.size.height /2 - _planeView.frame.size.height /2,
                                   _planeView.frame.size.width,
                                   _planeView.frame.size.height);
    
    _planeView.frame = planeFrame;
    
    
    [super viewWillLayoutSubviews];
}

-(void)updatePosition:(double)lon lat:(double)latitude altInFt:(double)alt {
    [self updatePosition:lon lat:latitude altitudeInFt:alt updateZoom:NO];
}

-(void)updateHeading:(double)heading {
    CGAffineTransform rotate = CGAffineTransformMakeRotation( heading / 180.0 * 3.14 );
    [_planeView setTransform:rotate];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - delagate methods for config
- (void)configViewControllerDidCancel:(UIConfigController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) makeInstrumentsVisible:(bool)visible {
    _instrumentView.hidden = !visible;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self viewWillLayoutSubviews];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self makeInstrumentsVisible:!_instrumentView.hidden];
}

- (void)configViewControllerDidSave:(UIConfigController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    Config *savedConfig = controller.config;
    
    [savedConfig persist];
    
    _config = savedConfig;
    
    [self updateStateFromConfig];
    
    [self viewWillLayoutSubviews];
    
}

-(void)updateInstruments:(InstrumentType)instrumentType {
    [self makeInstrumentsVisible:instrumentType != NO_INSTRUMENTS];
    
    switch (instrumentType) {
        case NO_INSTRUMENTS:
            break;
        case PROP_INSTRUM:
            [_instrumentView showPropInstruments:false];
            break;
        case JET_INSTRUM:
            [_instrumentView showFastJetInstruments:false];
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Config"])
	{
		UIConfigController *configViewController = segue.destinationViewController;
		configViewController.delegate = self;
        
        //Force the view to load
        [configViewController view];
        
        configViewController.config = _config;
        
	} else if ([segue.identifier isEqualToString:@"InfoView"]) {
        InfoViewController *infoView = segue.destinationViewController;
        infoView.ipAddress = [UIConfigController getIPAddress];
        infoView.port = udpClient._port;
        
    }
}

#pragma mark Touch event handlers
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _touchInProgress = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _touchInProgress = NO;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //Reset touch flag after fixed time. This catches any missed guesture end events
    [self performSelector:@selector(resetTouch:) withObject:self afterDelay:RESET_PINCH_TIME];
}

- (void)handlePinch:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
        gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        _touchInProgress = NO;
    }
}

-(void)resetTouch:(id)sender {
    _touchInProgress = NO;
}


@end
