//
//  UIViewController+DialogPresentation.h
//  DPDialog
//
//  Created by David Pettigrew on 5/9/13.
//  Copyright (c) 2013 LifeCentrics, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPDialogView.h"
#import "DPRoundedDialog.h"

typedef enum Side {
    Left, Top, Right, Bottom, Random
} Side;

@interface UIViewController (DialogPresentation)

@property BOOL isDisplayingModalDialog;
@property (nonatomic, retain) NSDate *presentationStartDate;

- (void)presentDialog:(DPDialogView *)dialogView fromSide:(Side)side;
- (void)presentDialogFromSide:(DPDialogView *)dialogView;
- (void)dismissDialog:(DPDialogView *)dialogView toSide:(Side)side withCompletion:(void (^)(BOOL finished))completion;
- (void)dismissDialog:(DPDialogView *)dialogView withCompletion:(void (^)(BOOL finished))completion;

- (void)presentDialogView:(DPDialogView *)dialogView fromPoint:(CGPoint)point;
- (void)dismissDialogByShrinking:(DPDialogView *)dialogView withCompletion:(void (^)(BOOL finished))completion;

- (void)animatedPresentation:(UIView *)uiView;
- (void)animatedDismissal:(UIView *)uiView withCompletion:(void (^)(BOOL finished))completion;

- (void)dismissDialogByShrinking:(DPDialogView *)dialogView afterMinimumTime:(NSTimeInterval)minTimeInterval withCompletion:(void (^)(BOOL finished))completion;

@end
