//
//  TelnetPositionClient.m
//  FlightGearMap
//
//  Created by Jason Crane on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "TelnetPositionClient.h"

#import "TBXML.h"

#define TAG_POSITION 1
#define TAG_ORIENTATION 2

NSString *XML_START =  @"<?xml";
NSString *XML_END = @"</PropertyList>";

NSString* orientation   = @"dump /orientation\r\n";
NSString* position      = @"dump /position\r\n";

NSMutableString *incomingXML;

NSTimer *timer;
NSNumberFormatter *formatter;
NSObject <MapStatusUpdater> *mapStatusUpdater;

@implementation TelnetPositionClient

@synthesize port,address,status;

-(void)updateStatus:(connection)conStatus {
    status = conStatus;
}

-(id)init:(NSObject <MapStatusUpdater> *)updater {
    self = [super init];
    if (self) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        mapStatusUpdater = updater;
                
        [self updateStatus:DISCONNECTED];
        
        NSLog(@"Machine %@",address);
        
        incomingXML = [[NSMutableString alloc]init];

    }
    return self;
}

-(void)requestNewPosition {
    NSLog(@"Requesting new position / orientation");
    NSData* data=[orientation dataUsingEncoding:NSUTF8StringEncoding];
    
    [socket writeData:data withTimeout:-1 tag:TAG_ORIENTATION];
    [socket readDataWithTimeout:-1 tag:TAG_ORIENTATION ];
    
    data=[position dataUsingEncoding:NSUTF8StringEncoding];
    [socket writeData:data withTimeout:-1 tag:TAG_POSITION];
    [socket readDataWithTimeout:-1 tag:TAG_POSITION ];
    
}

-(void)start {
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    int portNum = [[formatter numberFromString:port] intValue];
    
    [self updateStatus:CONNECTING];
    //TODO: handle error
    NSError *err = nil;
    if (![socket connectToHost:address onPort:portNum error:&err])
    {
        [self updateStatus:CANT_CONNECT];
        NSLog(@"Error connecting to telnet host: %@", err);
    } else {
        NSLog(@"connected");
    }
}

-(void)stop {
    [self updateStatus:DISCONNECTED];
    [socket disconnect];
}

- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Connected to FlightGear telnet host %@:%d",host,port);
    [self updateStatus:CONNECTED];
}

-(NSNumber *)getDoubleFromXML:(TBXML*)xml elementName:(NSString *)name {
    NSError * error;
    
    TBXMLElement * pos_long = [TBXML childElementNamed:name parentElement:xml.rootXMLElement];
    NSString * text = [TBXML textForElement:pos_long error:&error];

    return [formatter numberFromString:text];

}

-(void)processIncomingXml:(NSString *)xml {
    NSLog(@"XML to process : %@",xml);
    //TODO: handle errors
    NSError *error;
    TBXML * tbxml = [TBXML newTBXMLWithXMLString:xml error:&error];
     
    NSNumber *lon = [self getDoubleFromXML:tbxml elementName:@"longitude-deg"];
    NSNumber *lat = [self getDoubleFromXML:tbxml elementName:@"latitude-deg"];
    NSNumber *alt = [self getDoubleFromXML:tbxml elementName:@"altitude-ft"];
     
    if (lon && lat) {
    //     NSLog(@"Position %f,%f",[lat doubleValue],[lon doubleValue]);
     
        [mapStatusUpdater updatePosition:[lon doubleValue] lat:[lat doubleValue] altInFt:[alt doubleValue]];
    }
     
    NSNumber *heading = [self getDoubleFromXML:tbxml elementName:@"heading-deg"];
     
    if (heading) {
    //     NSLog(@"Heading %f:", [heading doubleValue]);
     
        [mapStatusUpdater updateHeading:[heading doubleValue]];
    }
     
     
}


- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
   
    NSLog(@"Got response");
    NSString *incoming = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    [incomingXML appendString:incoming];
    
    //get complete xml from partial response
    NSRange end;
    while ((end = [incomingXML rangeOfString:XML_END]).location != NSNotFound) {
   
        //Only process XML from start tag. Ignore any preamble, prompts etc.
        NSRange start = [incomingXML rangeOfString:XML_START];
        NSRange validXMLRange = NSMakeRange(start.location, end.location+end.length-start.location);
        
        [self processIncomingXml:[incomingXML substringWithRange:validXMLRange]];
        
        //Remove all consumed XML including preamble
        NSRange consumedXML = NSMakeRange(0, validXMLRange.location + validXMLRange.length);
        [incomingXML replaceCharactersInRange:consumedXML withString:@""];
        
    }
    

}
    
@end
