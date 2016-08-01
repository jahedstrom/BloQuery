//
//  QuestionCell.m
//  BloQuery
//
//  Created by Jonathan on 8/1/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "QuestionCell.h"

@interface QuestionCell ()

@property (weak, nonatomic) IBOutlet UIView *QuestionBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImage;



@end

@implementation QuestionCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.QuestionBackgroundView.layer.cornerRadius = 5;
    self.ProfileImage.layer.cornerRadius = 32;
    self.ProfileImage.clipsToBounds = YES;
}

@end
