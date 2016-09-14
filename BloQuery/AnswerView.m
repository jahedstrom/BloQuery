//
//  AnswerView.m
//  BloQuery
//
//  Created by Jonathan on 9/13/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "AnswerView.h"

@interface AnswerView ()

@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) UITextField *answerTextField;


@end

@implementation AnswerView

- (void)commonInit
{
    CGRect viewRect = CGRectMake(20, 200, CGRectGetWidth(self.bounds) - 40, 300);
    self.testView = [[UIView alloc] initWithFrame:viewRect];
    self.testView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    
    CGRect answerTextFieldFrame = CGRectMake(self.testView.frame.origin.x + 10, self.testView.frame.origin.y + 10, self.testView.frame.size.width - 20, self.testView.frame.size.height - 50);
    self.answerTextField = [[UITextField alloc] initWithFrame:answerTextFieldFrame];
    [self.testView addSubview:self.answerTextField];
    
}

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}
- (void)displayAnswerWindow {
    
    [self.superview addSubview:self.testView];
    
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.testView.topAnchor constraintEqualToAnchor:self.tableView.topAnchor constant:200];
}

@end
