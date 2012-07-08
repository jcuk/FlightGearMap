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

#define TIMEOUT_NONE -1

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
    if (status == CONNECTED) {
        NSLog(@"Requesting new position / orientation");
        NSData* data=[orientation dataUsingEncoding:NSUTF8StringEncoding];
    
        [socket writeData:data withTimeout:TIMEOUT_NONE tag:TAG_ORIENTATION];
        [socket readDataWithTimeout:TIMEOUT_NONE tag:TAG_ORIENTATION ];
    
        data=[position dataUsingEncoding:NSUTF8StringEncoding];
        [socket writeData:data withTimeout:TIMEOUT_NONE tag:TAG_POSITION];
        [socket readDataWithTimeout:TIMEOUT_NONE tag:TAG_POSITION ];
    } else if (status != NO_CONFIG) {
        NSLog(@"Attempting re-connect");
        [self start];
    }
    
}

-(void)socketDidDisconnect:(GCDAsyncSocket *) caller withError:(NSError *)error {
    NSLog(@"Socket did close stream");
    [self stop];
    
}

-(void)start {
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    int portNum = [[formatter numberFromString:port] intValue];
    
    if ([address length] == 0 || [port length] ==0) {
        [self updateStatus:NO_CONFIG];
    } else {
    
        [self updateStatus:CONNECTING];

        NSError *err = nil;
        if (![socket connectToHost:address onPort:portNum error:&err])
        {
            [self updateStatus:CANT_CONNECT];
            NSLog(@"Error connecting to telnet host: %@", err);
            [self stop];
        } else {
            NSLog(@"connected");
        }
    }
}

-(void)stop {
    [self updateStatus:DISCONNECTED];
    [socket disconnect];
    socket = nil;
}

- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)portNum
{
    NSLog(@"Connected to FlightGear telnet host %@:%d",host,portNum);
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
    
    if (error) {
        NSLog(@"Error parsing incoming xml %@",error);
    }
     
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
