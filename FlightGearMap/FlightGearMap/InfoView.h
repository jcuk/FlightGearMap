//
//  InfoView.h
//  DiceGL
//
//  Created by Jason Crane on 27/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoView : UIView {
    UIWebView *webView;
    UIButton *dismissButton;
    UIViewController *superViewController;
    BOOL transparentUserAction;
    
}

-(void)setText:(NSString *)text;
- (id)initWithFrame:(CGRect)frame;
- (void)transparentInteraction;

@end
