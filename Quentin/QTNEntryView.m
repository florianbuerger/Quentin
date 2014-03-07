//
// Created by Florian Bürger on 19/02/14.
// Copyright (c) 2014 keslcod. All rights reserved.
//

#import "QTNEntryView.h"

@interface QTNEntryView ()
@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation QTNEntryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        [self addSubview:label];

        CGRect maxBounds = CGRectInset(frame, 10, 10);
        CGFloat maxWidth = CGRectGetWidth(maxBounds);
        NSDictionary *metrics = @{
            @"maxWidth" : @(maxWidth)
        };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[label(<=maxWidth)]-10-|"
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:metrics
                                                                       views:NSDictionaryOfVariableBindings(label)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:label
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];

        self.infoLabel = label;
    }

    return self;
}

- (void)showSuccess:(NSString *)success
{
    self.infoLabel.textColor = [UIColor grayColor];
    self.infoLabel.text = success;
}

- (void)showError:(NSString *)error
{
    self.infoLabel.textColor = [UIColor redColor];
    self.infoLabel.text = error;
}

@end
