//
//  QuestionsViewController.m
//  BloQuery
//
//  Created by Jonathan on 7/26/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "QuestionsViewController.h"
@import Firebase;


@implementation QuestionsViewController

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
    
    [[FIRAuth auth] signOut:nil];
    NSLog(@"User logged out");
    [self loadLoginViewController];
    
}

@end
