//
//  DialogView.m
//  NumberPress
//
//  Created by David Pettigrew on 6/3/13.
//  Copyright (c) 2013 LifeCentrics. All rights reserved.
//

#import "DialogView.h"
#import <QuartzCore/QuartzCore.h>

@interface DialogView ()

@property (nonatomic, strong, readonly) UIButton *overlayView;

@end

@implementation DialogView

@synthesize overlayView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIButton *)overlayView {
    if(!overlayView) {
        overlayView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.backgroundColor = [UIColor clearColor];
        [overlayView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent) forControlEvents:UIControlEventTouchDown];
        [overlayView setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [overlayView setBackgroundImage:[UIImage new] forState:UIControlStateDisabled];
    }
    return overlayView;
}

- (void)overlayViewDidReceiveTouchEvent {
}

- (void)show {
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.delegate.window;
    if(!self.overlayView.superview){
        self.overlayView.userInteractionEnabled = YES;
        [window addSubview:self.overlayView];
        self.overlayView.frame = window.frame;
    }
    
    self.userInteractionEnabled = YES;
    
    if(!self.superview) {
        [self.overlayView addSubview:self];
    }
}

- (void)dismiss {
    [self removeFromSuperview];
    [overlayView removeFromSuperview];
    overlayView = nil;
}


 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
     [super drawRect:rect];
     UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
     self.layer.masksToBounds = NO;
     self.layer.shadowColor = [UIColor blackColor].CGColor;
     self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
     self.layer.shadowOpacity = 0.5f;
     self.layer.shadowPath = shadowPath.CGPath;
 }

@end
