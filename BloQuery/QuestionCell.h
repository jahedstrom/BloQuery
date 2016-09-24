//
//  QuestionCell.h
//  BloQuery
//
//  Created by Jonathan on 8/1/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Question;

@interface QuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfAnswers;
@property (weak, nonatomic) IBOutlet UIButton *didTapUserProfileImage;
@property (weak, nonatomic) IBOutlet UITextField *numberOfAnswersTextField;

@property (nonatomic, strong) Question *question;

@end
