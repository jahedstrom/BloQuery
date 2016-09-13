//
//  AnswerTableViewController.m
//  BloQuery
//
//  Created by Jonathan on 8/4/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerCell.h"
#import "QuestionManager.h"
#import "Question.h"

@interface AnswerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *questionBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *questionProfileImage;



@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.questionBackgroundView.layer.cornerRadius = 5;
    self.questionProfileImage.layer.cornerRadius = 32;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUInteger r = arc4random_uniform(90) + 60;
    
    CGFloat height = (CGFloat)r;
    
    self.questionLabelHeightConstraint.constant = height;
    NSLog(@"question height = %0.2f", height);
}

#pragma mark - Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

#pragma mark - Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.question numberOfAnswers];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCell"];
    
    cell.answer = [self.question getAnswerForIndex:indexPath.row];
    
    return cell;
}

@end
