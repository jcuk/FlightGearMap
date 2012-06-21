//
//  InfoView.m
//  DiceGL
//
//  Created by Jason Crane on 27/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfoView.h"

#define kButtonSize 20.0f

@implementation InfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Init info view %f %f",frame.size.width, frame.size.height);
        webView = [[UIWebView alloc]initWithFrame:self.bounds];
        [webView setBackgroundColor:[UIColor clearColor]];
        [webView setOpaque:NO];
        [webView setAutoresizingMask:( UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight)];
        
        [self addSubview:webView];        
        [self setOpaque:NO];
        [self setUserInteractionEnabled:NO];
        [self setAutoresizesSubviews:YES];
        
        dismissButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-kButtonSize*1.5f, kButtonSize/2.0f, kButtonSize, kButtonSize)];
        
        [self addSubview:dismissButton];
        [dismissButton setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        [dismissButton addTarget:self action:@selector(dismissed:) forControlEvents:UIControlEventTouchDown];
        [dismissButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin];
        [dismissButton setUserInteractionEnabled:YES];
        [self bringSubviewToFront:dismissButton];

    }
    return self;
}

-(void) transparentInteraction {
    [webView setUserInteractionEnabled:NO];
    [dismissButton setUserInteractionEnabled:YES];
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [webView setUserInteractionEnabled:userInteractionEnabled];
    [dismissButton setUserInteractionEnabled:userInteractionEnabled];
}

-(void)dismissed:(id)sender {
    self.hidden = YES;
    [self setUserInteractionEnabled:NO];
}

-(void)setText:(NSString *)text {
    [webView loadHTMLString:text baseURL:[NSURL URLWithString:@""]];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    //now draw the rounded rectangle
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetLineWidth(context,0.0f);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.5f);
    
    //since I need room in my rect for the shadow, make the rounded rectangle a little smaller than frame
    CGRect rrect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGFloat radius = 20;
    // the rest is pretty much copied from Apples example
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    
    // Start at 1
    CGContextMoveToPoint(context, minx, midy);
    // Add an arc through 2 to 3
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    // Add an arc through 4 to 5
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    // Add an arc through 6 to 7
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    // Add an arc through 8 to 9
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    // Close the path
    CGContextClosePath(context);
    // Fill & stroke the path
    CGContextDrawPath(context, kCGPathFillStroke);

    [webView setNeedsDisplayInRect:rect];
}

@end
