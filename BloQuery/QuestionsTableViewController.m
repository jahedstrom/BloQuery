//
//  QuestionsViewController.m
//  BloQuery
//
//  Created by Jonathan on 7/26/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "QuestionsTableViewController.h"
#import "QuestionManager.h"
#import "QuestionCell.h"
#import "AnswerViewController.h"


@import Firebase;

@interface QuestionsTableViewController ()



@end

@implementation QuestionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil) {
        // User is signed in.
        [[QuestionManager sharedInstance] retrieveQuestionsWithCompletionHandler:^(NSArray *questions, NSError *error) {
            [self.tableView reloadData];
        }];
    } else {
        // No user is signed in, present Login View Controller
        
        // use this to prevent warning "Unbalanced calls to begin/end appearance transitions.."
        [self performSelector:@selector(loadLoginViewController) withObject:nil afterDelay:0.0];
    }
}

- (void)loadLoginViewController {
    [self performSegueWithIdentifier:@"LoginViewController" sender:self];

}

- (IBAction)logout:(id)sender {
    NSError *error = nil;
    [[FIRAuth auth] signOut:&error];
    if (error) {
        //TODO: Notify the user that sign out has failed
    }
    NSLog(@"User logged out");
    [self loadLoginViewController];
    
}

- (IBAction)newQuestionButtonPressed:(UIBarButtonItem *)sender {
    
    NSLog(@"New question button pressed");
}

#pragma mark - Table View Delegate Methods

#pragma mark - Table View Data Source Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [QuestionManager sharedInstance].questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
    
    cell.question = [QuestionManager sharedInstance].questions[indexPath.row];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showAnswerView"]) {
        
        NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
        
        AnswerViewController *controller = (AnswerViewController *)segue.destinationViewController;
        
        controller.question = [QuestionManager sharedInstance].questions[selectedPath.row];
    }
    
    
}

@end
