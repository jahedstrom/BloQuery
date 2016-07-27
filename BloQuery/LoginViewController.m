//
//  LoginViewController.m
//  BloQuery
//
//  Created by Jonathan on 7/26/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "LoginViewController.h"
@import Firebase;

@interface LoginViewController ()

@property (nonatomic, assign) NSInteger segmentedControlIndex;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    self.inputsContainerView.layer.cornerRadius = 5;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateInputsContainerView];
}

- (IBAction)didPressLoginRegisterSegmentedControl:(id)sender {
    
    UISegmentedControl *loginRegisterSegmentedControl = (UISegmentedControl *)sender;
    
    self.segmentedControlIndex = loginRegisterSegmentedControl.selectedSegmentIndex;
    
    NSString *loginButtonTitle = [loginRegisterSegmentedControl titleForSegmentAtIndex:self.segmentedControlIndex];
    
    
    [self updateInputsContainerView];
//    self.loginRegisterButton.titleLabel.text = loginButtonTitle;  // text was clipped doing it this way?
    [self.loginRegisterButton setTitle:loginButtonTitle forState:UIControlStateNormal];
    
    // didn't like how the text on the button "jumps" so tried this
//    self.loginRegisterButton.alpha = 0;
//    
//    [UIView animateWithDuration:0.5
//                          delay:0
//                        options:UIViewAnimationOptionTransitionCrossDissolve
//                     animations:^{
//                         self.loginRegisterButton.alpha = 1.0;
//                         [self.loginRegisterButton setTitle:loginButtonTitle forState:UIControlStateNormal];
//                     }
//                     completion:^(BOOL finished){
//                     }];
}

- (void)updateInputsContainerView {
    if (self.segmentedControlIndex == 0) {
        self.nameFieldHeightConstraint.constant = 0;
        self.inputsContainerViewHeightConstraint.constant = 100;
    } else {
        self.nameFieldHeightConstraint.constant = 50;
        self.inputsContainerViewHeightConstraint.constant = 150;
    }

}

- (IBAction)didPressLoginRegisterButton:(id)sender {
    
    NSString *email = self.userEmail.text;
    NSString *password = self.userPassword.text;
    
    if (self.segmentedControlIndex == 0) {
        // Process Login
        NSLog(@"sending login to Firebase..");
        [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            
            if (error) {
                // add alert view with the error
                NSLog(@"%@", error);
            }
            if (user != nil) {
                NSLog(@"successfully logged in");
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }];
    } else {
        [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            
            if (error) {
                // add an alert view with the error
                NSLog(@"%@", error);
            }
            if (user != nil) {
                NSLog(@"successfully logged in");
                NSLog(@"User email: %@", user.email);
                NSLog(@"User uid: %@", user.uid);
                
                // send user back to login screen? or directly to tableview?
                
                // Store user into Firebase database

            }

        }];
    }
}

@end
