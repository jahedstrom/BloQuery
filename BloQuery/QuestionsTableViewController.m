//
//  QuestionsViewController.m
//  BloQuery
//
//  Created by Jonathan on 7/26/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "QuestionsTableViewController.h"
@import Firebase;

@implementation QuestionsTableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil) {
        // User is signed in.
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

#pragma mark - Table View Delegate Methods

#pragma mark - Table View Data Source Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10  ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
    
    return cell;
}

@end
