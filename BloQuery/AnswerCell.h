//
//  AnswerCell.h
//  BloQuery
//
//  Created by Jonathan on 8/4/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Answer, AnswerCell;

@protocol AnswerCellDelegate <NSObject>

- (void)cellDidPressVoteButton:(AnswerCell *)cell;

@end


@interface AnswerCell : UITableViewCell

@property (nonatomic, weak) id <AnswerCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *answerProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *answerLikesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic, strong) Answer *answer;


@end
