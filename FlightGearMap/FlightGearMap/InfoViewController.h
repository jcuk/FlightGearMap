//
//  InfoViewController.h
//  FlightGearMap
//
//  Created by Jason Crane on 08/09/2013.
//
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController {
    @private IBOutlet UITextView *infoView;
}

@property (nonatomic, retain) NSString *ipAddress;
@property int port;

@end
