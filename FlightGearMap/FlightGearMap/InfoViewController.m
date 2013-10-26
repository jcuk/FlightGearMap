//
//  InfoViewController.m
//  FlightGearMap
//
//  Created by Jason Crane on 08/09/2013.
//
//

#import "InfoViewController.h"

#define INFO_TEXT @"Live map for use with FlightGear, the open source flight simulator.\nTo use flight gear map, you must first copy the mobatlas.xml file into the 'Protocol' directory of your FlightGear application. On the config screen of this app you will see the IP address of your device. You can now start FlightGear with the UDP option enabled e.g.:\n\nfgfs --generic=socket,out,5, %@,%d,udp,mobatlas\n\nTap Done and FlightGear Map will connect to your FlightGear instance.\n\nhttp://www.flightgear.org/\n\n© Jason Crane 2012\n"

@interface InfoViewController ()

@end

@implementation InfoViewController

-(void)viewDidLoad {
    
    UIFont *boldFont = [UIFont fontWithName:@"Courier-Bold" size:[infoView font].pointSize];

    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           boldFont,        NSFontAttributeName,
                           nil];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:INFO_TEXT, _ipAddress,
        _port]];
    
    int start = [[text string] rangeOfString:@"fgfs"].location;
    int end = [[text string] rangeOfString:@",mobatlas"].location + 9;
    const NSRange range = NSMakeRange(
        start,
        end - start);
    
    [text setAttributes:attrs range:range];
    
    [text addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, [[text string] length])];
    
    infoView.attributedText = text;
    
    [freeStuffButton setNavigationButtonWithColor: [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [infoView setNeedsLayout];
}

#pragma mark RevMobAds

- (void)revmobAdDidFailWithError:(NSError *)error {
    
}

-(IBAction)getFreeStuff:(id)sender {
    [[RevMobAds session] openAdLinkWithDelegate:self];
}

@end
