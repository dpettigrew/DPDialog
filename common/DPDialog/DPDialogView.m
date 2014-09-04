//
//  DialogView.m
//  DPDialog
//
//  Created by David Pettigrew on 6/3/13.
//  Copyright (c) 2013 LifeCentrics. All rights reserved.
//

#import "DPDialogView.h"
#import <QuartzCore/QuartzCore.h>

@interface DPDialogView ()

@property (nonatomic, strong) UIView *windowView;

@end

@implementation DPDialogView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self registerNotifications];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self registerNotifications];
    }
    return self;
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(position:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)show {
    self.windowView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.windowView addSubview:self];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.windowView];
    [self position:nil];
}

- (void)dismiss {
    [self removeFromSuperview];
    [self.windowView removeFromSuperview];
}


 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     [super drawRect:rect];
     UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
     self.layer.masksToBounds = NO;
     self.layer.shadowColor = [UIColor blackColor].CGColor;
     self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
     self.layer.shadowOpacity = 0.5f;
     self.layer.shadowPath = shadowPath.CGPath;
}

- (void)position:(NSNotification*)notification {
    CGRect orientationFrame = self.window.bounds;
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    // no transforms applied to window in iOS 8
    BOOL ignoreOrientation = [[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)];

    if(!ignoreOrientation && UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
        
        temp = statusBarFrame.size.width;
        statusBarFrame.size.width = statusBarFrame.size.height;
        statusBarFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height;
    CGFloat posY = floor(activeHeight*0.45);
    CGFloat posX = orientationFrame.size.width/2;
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    if (ignoreOrientation) {
        rotateAngle = 0.0;
        newCenter = CGPointMake(posX, posY);
    }
    else {
        switch (orientation) {
            case UIInterfaceOrientationPortraitUpsideDown:
                rotateAngle = M_PI;
                newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                rotateAngle = -M_PI/2.0f;
                newCenter = CGPointMake(posY, posX);
                break;
            case UIInterfaceOrientationLandscapeRight:
                rotateAngle = M_PI/2.0f;
                newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
                break;
            default: // as UIInterfaceOrientationPortrait
                rotateAngle = 0.0;
                newCenter = CGPointMake(posX, posY);
                break;
        }
    }
    
    [self moveToPoint:newCenter rotateAngle:rotateAngle];
}

- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle {
    self.center = CGPointMake(newCenter.x, newCenter.y);
    self.windowView.transform = CGAffineTransformMakeRotation(angle);
}


@end
