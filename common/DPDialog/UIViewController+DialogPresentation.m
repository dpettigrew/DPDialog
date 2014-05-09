//
//  UIViewController+DialogPresentation.m
//  NumberPress
//
//  Created by David Pettigrew on 5/9/13.
//  Copyright (c) 2013 LifeCentrics, LLC. All rights reserved.
//

#import "UIViewController+DialogPresentation.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static char const * const kIsDisplayingModalDialogKey = "kIsDisplayingModalDialog";
static char const * const kPresentationStartDateKey = "kPresentationStartDateKey";

@implementation UIViewController (DialogPresentation)

@dynamic isDisplayingModalDialog;

- (BOOL)isDisplayingModalDialog {
    return ((NSNumber *)objc_getAssociatedObject(self, kIsDisplayingModalDialogKey)).boolValue;
}

- (void)setIsDisplayingModalDialog:(BOOL)isDisplayingModalDialog {
    objc_setAssociatedObject(self, kIsDisplayingModalDialogKey, @(isDisplayingModalDialog), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)presentationStartDate {
    return objc_getAssociatedObject(self, kPresentationStartDateKey);
}

-(void)setPresentationStartDate:(NSDate *)minimimPresentationDuration {
    objc_setAssociatedObject(self, kPresentationStartDateKey, minimimPresentationDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGPoint)getStartingCenterForSide:(Side)side {
    CGPoint center = CGPointZero;
    switch (side) {
        case Left:
            center = CGPointMake(-200, CGRectGetMidY(self.view.bounds));
            break;
        case Top:
            center = CGPointMake(CGRectGetMidX(self.view.bounds), -200);
            break;
        case Right:
            center = CGPointMake(CGRectGetWidth(self.view.bounds) + 200, CGRectGetMidY(self.view.bounds));
            break;
        case Bottom:
            center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetHeight(self.view.bounds) + 200);
            break;
        case Random: {
            int side = arc4random_uniform(4);
            center = [self getStartingCenterForSide:side];
            break;
        }
        default:
            break;
    }
    return center;
}

#pragma mark Dialog presentation
- (void)presentDialogFromSide:(DialogView *)dialogView {
    [self presentDialog:dialogView fromSide:Random];
}

- (void)presentDialog:(DialogView *)dialogView fromSide:(Side)side {
    self.presentationStartDate = [NSDate date];
    [dialogView show];
    
    // Prepare for the animation (inital position & transform)
    dialogView.center = [self getStartingCenterForSide:side];
    dialogView.transform = CGAffineTransformMakeScale(1., 1.);
    
    // Animate!
    [UIView animateWithDuration:.7 animations:^{        
        [dialogView setEasingFunction:ElasticEaseOut forKeyPath:@"center"];
        [dialogView setEasingFunction:ElasticEaseOut forKeyPath:@"transform"];
        
        dialogView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        dialogView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [dialogView removeEasingFunctionForKeyPath:@"center"];
        [dialogView removeEasingFunctionForKeyPath:@"transform"];        
    }];
    self.isDisplayingModalDialog = YES;
}

- (void)dismissDialog:(DialogView *)dialogView toSide:(Side)side withCompletion:(void (^)(BOOL finished))completion {
    self.presentationStartDate = [NSDate date];
    [UIView animateWithDuration:.5 animations:^{
        [dialogView setEasingFunction:BackEaseIn forKeyPath:@"center"];
        [dialogView setEasingFunction:QuinticEaseOut forKeyPath:@"transform"];
        
        // Move the view away
        dialogView.center = [self getStartingCenterForSide:side];
        
        // ...and rotate it along the way
        CGAffineTransform t = CGAffineTransformMakeRotation(M_PI * (arc4random_uniform(2) == 0 ? .3 : -.3));
        dialogView.transform = t;
    } completion:^(BOOL finished) {
        [dialogView removeEasingFunctionForKeyPath:@"center"];
        [dialogView removeEasingFunctionForKeyPath:@"transform"];
        dialogView.transform = CGAffineTransformIdentity;
        
        [dialogView dismiss];
        
        if (completion) {
            completion(YES);
        }
    }];
    self.isDisplayingModalDialog = NO;
}

- (void)dismissDialog:(DialogView *)dialogView withCompletion:(void (^)(BOOL finished))completion {
    [self dismissDialog:dialogView toSide:Random withCompletion:completion];
}

- (void)animatedPresentation:(UIView *)uiView {
    [UIView animateWithDuration:0.1 animations:^{uiView.alpha = 1.0;}];
    
    uiView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 0.3;
    bounceAnimation.removedOnCompletion = NO;
    [uiView.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    uiView.layer.transform = CATransform3DIdentity;
    self.isDisplayingModalDialog = YES;
}

- (void)animatedDismissal:(UIView *)uiView withCompletion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.25 animations:^{
        uiView.layer.transform = CATransform3DMakeScale(0.0, 0.0, 1.0);
    } completion:^(BOOL finished) {
        uiView.layer.transform = CATransform3DIdentity;
        if (completion) {
            completion(YES);
        }
    }];
    self.isDisplayingModalDialog = NO;
}

- (void)presentDialogView:(DialogView *)dialogView fromPoint:(CGPoint)point {
    self.presentationStartDate = [NSDate date];
    // Prepare for the animation (inital position & transform)
    dialogView.center = point;
    dialogView.alpha = 1.0;
    [dialogView show];
    
    // Animate!
    
    [UIView animateWithDuration:0.1 animations:^{dialogView.alpha = 1.0;}];
    
    dialogView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 0.3;
    bounceAnimation.removedOnCompletion = NO;
    [dialogView.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    dialogView.layer.transform = CATransform3DIdentity;
    self.isDisplayingModalDialog = YES;
    [dialogView setNeedsDisplay];
}

- (void)dismissDialogByShrinking:(DialogView *)dialogView withCompletion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.25 animations:^{
        dialogView.layer.transform = CATransform3DMakeScale(0.0, 0.0, 1.0);
    } completion:^(BOOL finished) {
        dialogView.layer.transform = CATransform3DIdentity;
        [dialogView dismiss];
        if (completion) {
            completion(YES);
        }
    }];
    self.isDisplayingModalDialog = NO;
}

- (void)presentRoundedDialogView:(RoundedDialog *)roundedDialog fromPoint:(CGPoint)point {
    self.presentationStartDate = [NSDate date];
    // Prepare for the animation (inital position & transform)
    roundedDialog.center = point;
    roundedDialog.alpha = 0.0;
    [roundedDialog.dialogView show];
    
    // Animate!
    
    [UIView animateWithDuration:0.1 animations:^{roundedDialog.alpha = 1.0;}];
    
    roundedDialog.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 0.3;
    bounceAnimation.removedOnCompletion = NO;
    [roundedDialog.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    roundedDialog.layer.transform = CATransform3DIdentity;
    self.isDisplayingModalDialog = YES;
}

- (void)dismissRoundedDialogByShrinking:(RoundedDialog *)roundedDialog withCompletion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.25 animations:^{
        roundedDialog.layer.transform = CATransform3DMakeScale(0.0, 0.0, 1.0);
    } completion:^(BOOL finished) {
        roundedDialog.layer.transform = CATransform3DIdentity;
        [roundedDialog.dialogView dismiss];
        if (completion) {
            completion(YES);
        }
    }];
    self.isDisplayingModalDialog = NO;
}

#pragma mark 
- (void)dismissDialogByShrinking:(DialogView *)dialogView afterMinimumTime:(NSTimeInterval)minTimeInterval withCompletion:(void (^)(BOOL finished))completion {
    NSTimeInterval timeInterval = fabsf([self.presentationStartDate timeIntervalSinceNow]);
    if (timeInterval > minTimeInterval) {
        [self dismissDialogByShrinking:dialogView withCompletion:completion];
    }
    else {
        double delayInSeconds = minTimeInterval - timeInterval;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self dismissDialogByShrinking:dialogView withCompletion:completion];
        });
    }
}

@end
