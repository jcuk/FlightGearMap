#import <UIKit/UIKit.h>

@class CAGradientLayer;

@interface UIGlossyButton : UIButton {
    CAGradientLayer *_gradientLayer;
}

@property (retain) UIColor *shadowColor;
@property (retain) NSArray *colors;
@property (retain) NSArray *reversedColors;
@property (retain) NSArray *flatColors;
@property (retain) NSArray *locations;

@end
