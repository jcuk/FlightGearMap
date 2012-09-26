#import "UIGlossyButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIGlossyButton

@synthesize shadowColor=_shadowColor;
@synthesize colors=_colors;
@synthesize reversedColors=_reversedColors;
@synthesize flatColors=_flatColors;
@synthesize locations=_locations;

static NSArray *__defaultColors;
static NSArray *__defaultReversedColors;
static NSArray *__defaultFlatColors;
static NSArray *__defaultLocations;

+(void)initialize {
      if ([self class] == [UIGlossyButton class]) {
            __defaultColors = [NSArray arrayWithObjects:
                (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                nil];
            __defaultReversedColors = [[__defaultColors reverseObjectEnumerator] allObjects];
            __defaultFlatColors = [NSArray arrayWithObjects:
                (id)[UIColor colorWithWhite:0.1f alpha:0.4f].CGColor,
                (id)[UIColor colorWithWhite:0.1f alpha:0.4f].CGColor,
                (id)[UIColor colorWithWhite:0.1f alpha:0.4f].CGColor,
                (id)[UIColor colorWithWhite:0.1f alpha:0.4f].CGColor,
                (id)[UIColor colorWithWhite:0.1f alpha:0.4f].CGColor,
                nil];
            __defaultLocations = [NSArray arrayWithObjects:
            [NSNumber numberWithFloat:0.0f],
                [NSNumber numberWithFloat:0.5f],
                [NSNumber numberWithFloat:0.5f],
                [NSNumber numberWithFloat:0.8f],
                [NSNumber numberWithFloat:1.0f],
                nil];
          }
}

-(void)setupView {
      // configure the colors and the locations for the gradient layer
      if (_colors == nil) {
        _colors = __defaultColors;
        _reversedColors = __defaultReversedColors;
      } else {
        _reversedColors = [[_colors reverseObjectEnumerator] allObjects];
      }
      _flatColors = __defaultFlatColors; 
      _locations = __defaultLocations;
    
      NSAssert2([_colors count] == [_reversedColors count], @"colors(%d) != reversedColors(%d)", [_colors count], [_reversedColors count]);
      NSAssert2([_colors count] == [_flatColors count], @"colors(%d) != flatColors(%d)", [_colors count], [_flatColors count]);
      NSAssert2([_colors count] == [_locations count], @"colors(%d) != locations(%d)", [_colors count], [_locations count]);
     
      _gradientLayer = [[CAGradientLayer alloc] init];
      _gradientLayer.frame = self.layer.bounds;
     
      // if we don't make the button's bg clear, then the bg color
      // will shine thru nice corners we're going to make
      _gradientLayer.backgroundColor = self.backgroundColor.CGColor;
      self.backgroundColor = [UIColor clearColor];
       
      _gradientLayer.colors = _colors;
      _gradientLayer.locations = _locations;
      _gradientLayer.cornerRadius = 8;
      _gradientLayer.masksToBounds = true;
    
      // make sure the gradient is the bottom layer
      [self.layer insertSublayer:_gradientLayer atIndex:0];
     
      if (_shadowColor == nil) {
            _shadowColor = [UIColor blackColor];
          }
     
      self.layer.shadowColor = _shadowColor.CGColor;
      self.layer.shadowOffset = CGSizeMake(5, 5);
      self.layer.shadowRadius = 5;
      self.layer.shadowOpacity = .5;
     
}

-(id)initWithFrame:(CGRect)frame {
      if ((self = [super initWithFrame:frame])) {
            [self setupView];
          }
      return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
      if ((self = [super initWithCoder:aDecoder])) {
            [self setupView];
          }
      return self;
}

-(void)layoutSubviews {
      [super layoutSubviews];
     
      // we have to disable the actions, otherwise, the
      // changes to the gradient layer below will animate
      // (and have a delayed pressing effect)
      [CATransaction begin];
      [CATransaction setValue:(id)kCFBooleanTrue
                             forKey:kCATransactionDisableActions];
     
      if (self.enabled) {
            if (self.highlighted) {
                  if (_gradientLayer.colors == _colors) {
                        // when highlighted (pressed), show the reversed
                        // colors
                        _gradientLayer.colors = _reversedColors;
                     
                        // and move the shadow up, makes it look like
                        // the button is closer to the surface
                        //self.contentEdgeInsets = UIEdgeInsetsMake(1,1,-1,-1);
                        self.layer.shadowOffset = CGSizeMake(2, 2);
                        self.layer.shadowRadius = 3;
                        self.layer.shadowOpacity = 0.8;
                      }
                } else {
                      if (_gradientLayer.colors != _colors) {
                            // just show the regular gloss
                            _gradientLayer.colors = _colors;
                         
                            // and move the shadow back
                            //self.contentEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
                            self.layer.shadowOffset = CGSizeMake(5, 5);
                            self.layer.shadowRadius = 5;
                            self.layer.shadowOpacity = 0.5;
                          }
                    }
            self.layer.shadowColor = _shadowColor.CGColor;
          } else {
                // show the flat colors and no shadow when disabled
                _gradientLayer.colors = _flatColors;
                self.layer.shadowColor = [UIColor clearColor].CGColor;
              }
      [CATransaction commit];
}

@end
