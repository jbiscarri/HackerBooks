//
//  NSLayoutConstraint+Lazy.m
//  BeGroup
//
//  Created by Joan Biscarri on 4/11/14.
//  Copyright (c) 2014 ProtectFive. All rights reserved.
//

#import "NSLayoutConstraint+Lazy.h"

@implementation NSLayoutConstraint (Lazy)


+ (NSLayoutConstraint *)leadingConstraintForView:(UIView *)view superview:(UIView *)superview {
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)trailingConstraintForView:(UIView *)view superview:(UIView *)superview {
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)topConstraintForView:(UIView *)view superview:(UIView *)superview {
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)bottomConstraintForView:(UIView *)view superview:(UIView *)superview {
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
}

+ (void)fitView:(UIView *)view inSuperview:(UIView *)superview {
    NSAssert(view.superview == superview, @"%@ should be subview of %@", view, superview);
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *constraints = @[
                             [self leadingConstraintForView:view superview:superview],
                             [self trailingConstraintForView:view superview:superview],
                             [self topConstraintForView:view superview:superview],
                             [self bottomConstraintForView:view superview:superview]
                             ];
    [superview addConstraints:constraints];
}


@end
