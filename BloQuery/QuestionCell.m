//
//  QuestionCell.m
//  BloQuery
//
//  Created by Jonathan on 8/1/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "QuestionCell.h"
#import "Question.h"
#import "User.h"

@interface QuestionCell ()

@property (weak, nonatomic) IBOutlet UIView *QuestionBackgroundView;



@end

@implementation QuestionCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.QuestionBackgroundView.layer.cornerRadius = 5;
    self.profileImage.layer.cornerRadius = 32;
    self.profileImage.clipsToBounds = YES;
}

- (void)setQuestion:(Question *)question {
    _question = question;
    //TODO: get profile image for user (something like this?)
    [question getUserWithCompletion:^(User *user, NSError *error) {
        if (error == nil) {
            _question.user = user;
            [_question.user getProfileImageforUserWithCompletionHandler:^(UIImage *image, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == nil && image) {
                        self.profileImage.image = image;
                    } else {
                        self.profileImage.image = nil;
                    }
                    
                });
            }];
        }
    }];
    
    if (question.numberOfAnswers == 1) {
        self.numberOfAnswers.text = [NSString stringWithFormat:@"%ld Answer", (long) question.numberOfAnswers];
    } else {
        self.numberOfAnswers.text = [NSString stringWithFormat:@"%ld Answers", (long) question.numberOfAnswers];
    }
    // assign 1,2, or 3 thumbs up depending on how many likes there are
    if (question.numberOfAnswers == 0) {
        self.likeLabel.text = nil;
    } else if (question.numberOfAnswers >= 1 && question.numberOfAnswers <= 3) {
        NSString *likeSeries = [NSString stringWithUTF8String:"\xF0\x9F\x91\x8D"];
        self.likeLabel.text = likeSeries;
    } else if (question.numberOfAnswers > 3 && question.numberOfAnswers <= 10) {
        NSString *likeSeries = [NSString stringWithUTF8String:"\xF0\x9F\x91\x8D \xF0\x9F\x91\x8D"];
        self.likeLabel.text = likeSeries;
    } else {
        NSString *likeSeries = [NSString stringWithUTF8String:"\xF0\x9F\x91\x8D \xF0\x9F\x91\x8D \xF0\x9F\x91\x8D"];
        self.likeLabel.text = likeSeries;
    }
    
    self.questionLabel.text = question.questionText;
    
}

@end
