//
//  UIViewController+DialogPresentation.h
//  NumberPress
//
//  Created by David Pettigrew on 5/9/13.
//  Copyright (c) 2013 LifeCentrics, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DialogView.h"
#import "RoundedDialog.h"

typedef enum Side {
    Left, Top, Right, Bottom, Random
} Side;

@interface UIViewController (DialogPresentation)

@property BOOL isDisplayingModalDialog;
@property (nonatomic, retain) NSDate *presentationStartDate;

- (void)presentDialog:(DialogView *)dialogView fromSide:(Side)side;
- (void)presentDialogFromSide:(DialogView *)dialogView;
- (void)dismissDialog:(DialogView *)dialogView toSide:(Side)side withCompletion:(void (^)(BOOL finished))completion;
- (void)dismissDialog:(DialogView *)dialogView withCompletion:(void (^)(BOOL finished))completion;

- (void)presentDialogView:(DialogView *)dialogView fromPoint:(CGPoint)point;
- (void)dismissDialogByShrinking:(DialogView *)dialogView withCompletion:(void (^)(BOOL finished))completion;

- (void)presentRoundedDialogView:(RoundedDialog *)dialogView fromPoint:(CGPoint)point;
- (void)dismissRoundedDialogByShrinking:(RoundedDialog *)dialogView withCompletion:(void (^)(BOOL finished))completion;

- (void)animatedPresentation:(UIView *)uiView;
- (void)animatedDismissal:(UIView *)uiView withCompletion:(void (^)(BOOL finished))completion;

- (void)dismissDialogByShrinking:(DialogView *)dialogView afterMinimumTime:(NSTimeInterval)minTimeInterval withCompletion:(void (^)(BOOL finished))completion;

@end
