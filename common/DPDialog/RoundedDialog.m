//
//  RoundedDialog.m
//  NumberPress
//
//  Created by David Pettigrew on 6/13/13.
//  Copyright (c) 2013 LifeCentrics. All rights reserved.
//

#import "RoundedDialog.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedDialog

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
}

- (void)setDialogView:(DialogView *)dialogView {
    _dialogView = dialogView;
    [self addSubview:dialogView];
}

@end
