//
//  QuestionCell.m
//  BloQuery
//
//  Created by Jonathan on 8/1/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "QuestionCell.h"
#import "Question.h"
#import "FIRUser+User.h"

@import FirebaseAuth;

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
    FIRUser *firUser = [question getUserForQuestionUID:question.questionUID];
    [firUser getProfilePicture:firUser.photoURL complete:^(UIImage *profileImage, NSError *error) {
        self.profileImage.image = profileImage;
    }];
    
    if (question.numberOfAnswers == 1) {
        self.numberOfAnswers.text = [NSString stringWithFormat:@"%ld Answer", (long) question.numberOfAnswers];
    } else {
        self.numberOfAnswers.text = [NSString stringWithFormat:@"%ld Answers", (long) question.numberOfAnswers];
    }
    
    //TODO: assign 1,2, or 3 thumbs up depending on how many likes there are
    NSString *likeSeries = [NSString stringWithUTF8String:"\xF0\x9F\x91\x8D \xF0\x9F\x91\x8D"];
    self.likeLabel.text = likeSeries;
    
    self.questionLabel.text = question.questionText;
    
}

@end
