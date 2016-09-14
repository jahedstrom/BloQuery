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
#import "AnswerView.h"
#import <UIKit/UIKit.h>

@interface AnswerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *questionBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *questionProfileImage;

@property (nonatomic, strong) UIView *testView;
@property (weak, nonatomic) IBOutlet UITableView *answerTableView;
@property (weak, nonatomic) IBOutlet AnswerView *answerView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *answerTableViewTopConstraint;

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.questionBackgroundView.layer.cornerRadius = 5;
    self.questionProfileImage.layer.cornerRadius = 32;
    

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.questionLabel.text = self.question.questionText;
    self.answerView.tableView = self.answerTableView;
}

- (IBAction)addAnswerButtonPressed:(UIBarButtonItem *)sender {
    
    [self.answerView displayAnswerWindow];
//    [self.view insertSubview:self.testView aboveSubview: self.answerTableView];
//    [self.testView.topAnchor constraintEqualToAnchor:self.answerTableView.topAnchor constant:200];
    
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
