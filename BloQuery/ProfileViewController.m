//
//  ProfileViewController.m
//  BloQuery
//
//  Created by Jonathan on 9/21/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"

@import FirebaseAuth;

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (nonatomic) BOOL isInEditMode;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileImageView.layer.cornerRadius = 50;
    self.profileImageView.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    
    if (self.user.uid == currentUser.uid) {
        self.logoutButton.hidden = NO;
        self.isInEditMode = YES;
        User *user = [[User alloc] initWithFIRUser:currentUser];
        
        self.usernameTextField.text = user.name;
        self.emailTextField.text = user.email;
        
        [user getProfileImageforUserWithCompletionHandler:^(UIImage *image, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil && image) {
                    self.profileImageView.image = image;
                } else {
                    self.profileImageView.image = nil;
                }
            });
        }];
        
    } else {
        self.logoutButton.hidden = YES;
        self.isInEditMode = NO;
        
        self.usernameTextField.borderStyle = UITextBorderStyleNone;
        self.emailTextField.borderStyle = UITextBorderStyleNone;
        self.descriptionTextField.borderStyle = UITextBorderStyleNone;
        
        self.usernameTextField.text = self.user.name;
        self.emailTextField.text = self.user.email;
        self.descriptionTextField.text = self.user.descriptionText;
        
        [self.user getProfileImageforUserWithCompletionHandler:^(UIImage *image, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil && image) {
                    self.profileImageView.image = image;
                } else {
                    self.profileImageView.image = nil;
                }
            });
        }];
    }
}

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logoutButtonPressed:(UIButton *)sender {
    NSError *error = nil;
    [[FIRAuth auth] signOut:&error];
    if (error) {
        //TODO: Notify the user that sign out has failed
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.isInEditMode) {
        return YES;
    } else {
        return NO;
    }
}
@end
