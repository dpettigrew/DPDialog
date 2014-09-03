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
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)show {
    self.windowView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.windowView addSubview:self];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.windowView];
}

- (void)dismiss {
    [self removeFromSuperview];
    [self.windowView removeFromSuperview];
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
