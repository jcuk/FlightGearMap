//
//  InfoViewController.h
//  FlightGearMap
//
//  Created by Jason Crane on 08/09/2013.
//
//

#import <UIKit/UIKit.h>
#import <RevMobAds/RevMobAds.h>
#import "UIGlossyButton.h"

@interface InfoViewController : UIViewController <RevMobAdsDelegate> {
    @private IBOutlet UITextView *infoView;
    @private IBOutlet UIGlossyButton *freeStuffButton;
}

@property (nonatomic, retain) NSString *ipAddress;
@property int port;

@end
