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

@import FirebaseAuth;

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
    NSString *currentUserUID = [FIRAuth auth].currentUser.uid;
    
    self.answerLabel.text = answer.answerText;
   [self.answer getUserWithCompletion:^(User *user, NSError *error) {
       if (error == nil) {
           [user getProfileImageforUserWithCompletionHandler:^(UIImage *image, NSError *error) {
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   if (error == nil && image) {
                       self.answerProfileImage.image = image;
                   } else {
                       self.answerProfileImage.image = nil;
                   }
                   
               });
           }];
       }
   }];
    
    if (answer.numberOfVotes == 1) {
        self.answerLikesLabel.text = [NSString stringWithFormat:@"%ld Vote", (long) answer.numberOfVotes];
    } else {
        self.answerLikesLabel.text = [NSString stringWithFormat:@"%ld Votes", (long) answer.numberOfVotes];
    }
    
    
    if ([answer.voters objectForKey:currentUserUID]) {
        UIImage *likeButtonSelected = [UIImage imageNamed:@"likebutton_selected"];
        [self.likeButton setImage:likeButtonSelected forState:UIControlStateNormal];
    } else {
        UIImage *likeButtonUnselected = [UIImage imageNamed:@"likebutton_unselected"];
        [self.likeButton setImage:likeButtonUnselected forState:UIControlStateNormal];
    }
}

- (IBAction)likeButtonTapped:(UIButton *)sender {
    NSLog(@"like button tapped");
    [self.delegate cellDidPressVoteButton:self];
}

@end
