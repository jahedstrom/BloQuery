//
//  AnswerCell.h
//  BloQuery
//
//  Created by Jonathan on 8/4/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Answer;

@interface AnswerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *answerProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *answerLikesLabel;

@property (nonatomic, strong) Answer *answer;


@end
