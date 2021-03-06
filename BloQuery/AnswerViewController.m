//
//  AnswerTableViewController.m
//  BloQuery
//
//  Created by Jonathan on 8/4/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerCell.h"
#import "Answer.h"
#import "QuestionManager.h"
#import "Question.h"
#import "User.h"
#import "NewAnswerController.h"

@interface AnswerViewController () <UITableViewDelegate, UITableViewDataSource, AnswerCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *questionBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *questionProfileImage;

@property (weak, nonatomic) IBOutlet UITableView *answerTableView;

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.answerTableView.delegate = self;
    self.answerTableView.dataSource = self;
    
    self.questionBackgroundView.layer.cornerRadius = 5;
    self.questionProfileImage.layer.cornerRadius = 32;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    self.questionLabelHeightConstraint.constant = height;
    self.questionLabel.text = self.question.questionText;
    
    [self.question retrieveAnswersWithCompletionHandler:^(NSArray *answers, NSError *error) {
        if (error == nil ) {
            [self.answerTableView reloadData];
        } else {
            if (error.code == -1) {
            NSLog(@"an error occured: %@", error.userInfo);
            }
        }
    }];
    
    [self.question.user getProfileImageforUserWithCompletionHandler:^(UIImage *image, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil && image) {
                self.questionProfileImage.image = image;
            } else {
                self.questionProfileImage.image = nil;
            }
            
        });
    }];
    
}

#pragma mark - AnswerCell Delegate Methods

- (void)cellDidPressVoteButton:(AnswerCell *)cell {
    Answer *answer = cell.answer;
    
    [answer changeVoteCountOnAnswerWithKey:self.question.firKey andCompletionHandler:^(NSError *error) {
        if (cell.answer == answer) {
            cell.answer = answer;
        }
    }];
    
//    cell.answer = answer;
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
    
    cell.delegate = self;
    cell.answer = [self.question getAnswerForIndex:indexPath.row];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showNewAnswerController"]) {
        
        NewAnswerController *controller = (NewAnswerController *)segue.destinationViewController;
        
        controller.question = self.question;
    }
}

@end
