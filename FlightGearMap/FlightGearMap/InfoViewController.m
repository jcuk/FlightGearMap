//
//  InfoViewController.m
//  FlightGearMap
//
//  Created by Jason Crane on 08/09/2013.
//
//

#import "InfoViewController.h"

#define INFO_TEXT @"Live map for use with FlightGear, the open source flight simulator.\nTo use flight gear map, you must first copy the mobatlas.xml file into the 'Protocol' directory of your FlightGear application. On the config screen of this app you will see the IP address of your device. You can now start FlightGear with the UDP option enabled e.g.:\n\nfgfs --generic=socket,out,5, %@,%d,udp,mobatlas\n\nTap Done and FlightGear Map will connect to your FlightGear instance.\n\n© Jason Crane 2012\n"

@interface InfoViewController ()

@end

@implementation InfoViewController

-(void)viewDidLoad {
    
    UIFont *boldFont = [UIFont fontWithName:@"Courier-Bold" size:[infoView font].pointSize];
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           boldFont, NSFontAttributeName, nil];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:INFO_TEXT, _ipAddress,
        _port]];
    
    int start = [[text string] rangeOfString:@"fgfs"].location;
    int end = [[text string] rangeOfString:@",mobatlas"].location + 9;
    const NSRange range = NSMakeRange(
        start,
        end - start);
    
    [text setAttributes:attrs range:range];
    
    infoView.attributedText = text;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [infoView setNeedsLayout];
}

@end
