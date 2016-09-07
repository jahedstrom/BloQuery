//
//  LoginViewController.m
//  BloQuery
//
//  Created by Jonathan on 7/26/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "User.h"
#import "Constants.h"
#import "FIRUser+User.h"

@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;

@interface LoginViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *inputsContainerView;
@property (weak, nonatomic) IBOutlet UIButton *loginRegisterButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *loginRegisterSegmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputsContainerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameFieldHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userFullName;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@property (nonatomic, readonly) BOOL isInLoginMode;
@property (nonatomic, strong) FIRDatabaseReference *reference;

@end

@implementation LoginViewController

- (BOOL)isInLoginMode {
    return (self.loginRegisterSegmentedControl.selectedSegmentIndex == 0);
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.inputsContainerView.layer.cornerRadius = 5;
    
    self.reference = [[FIRDatabase database] reference];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.loginRegisterSegmentedControl.selectedSegmentIndex = 1;

    [self updateInputsContainerView];
}

- (IBAction)didPressLoginRegisterSegmentedControl:(UISegmentedControl *)sender {
    
    NSString *loginButtonTitle = [self.loginRegisterSegmentedControl titleForSegmentAtIndex:self.loginRegisterSegmentedControl.selectedSegmentIndex];
    
    [self updateInputsContainerView];

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
    if (self.isInLoginMode) {
        self.nameFieldHeightConstraint.constant = 0;
        self.inputsContainerViewHeightConstraint.constant = 100;
    } else {
        self.nameFieldHeightConstraint.constant = 50;
        self.inputsContainerViewHeightConstraint.constant = 150;
    }

}

- (IBAction)didTapProfileImageView:(UITapGestureRecognizer *)sender {
    //TODO: Handle profile image selection
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (IBAction)didPressLoginRegisterButton:(id)sender {
    
    NSString *fullName = self.userFullName.text;
    NSString *email = self.userEmail.text;
    NSString *password = self.userPassword.text;
    UIImage *profileImage = self.profileImageView.image;
    
    if (self.isInLoginMode) {
        // Process Login
        //TODO: add alert view with the error
        NSLog(@"sending login to Firebase..");
        [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            
            if (error) {
                //TODO: add alert view with the error
                // error.localizedDescription gets human readable string
                NSLog(@"A login error occured: %@", error.localizedDescription);
            }
            if (user != nil) {
                NSLog(@"successfully logged in");
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }];
    } else {
        [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            
            if (error) {
                //TODO: add an alert view with the error
                NSLog(@"%@", error);
            }
            if (user != nil) {
                NSLog(@"successfully logged in");
                
                NSDictionary *userDict = @{@"name" : fullName, @"email" : email, @"image" : profileImage};
                
                [user addUserData:userDict complete:^(NSError *error) {
                    if (error == nil) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        //TODO: Show the error
                    }
                }];
               
            }
        }];
    }
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.profileImageView.image = editedImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
