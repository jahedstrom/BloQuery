//
//  AnswerCell.m
//  BloQuery
//
//  Created by Jonathan on 8/4/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "AnswerCell.h"
#import "Answer.h"
#import "User.h"


@interface AnswerCell ()

@property (weak, nonatomic) IBOutlet UIView *answerBackgroundView;

@end

@implementation AnswerCell

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.answerBackgroundView.layer.cornerRadius = 5;
    self.answerProfileImage.layer.cornerRadius = 24;
}

- (void)setAnswer:(Answer *)answer {
    
    _answer = answer;
    
    self.answerLabel.text = answer.answerText;
    //TODO: how to get the actual image from profileImageURL?
//    self.answerProfileImage = answer.user.profileImageURL;
}


@end
