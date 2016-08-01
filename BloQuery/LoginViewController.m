//
//  LoginViewController.m
//  BloQuery
//
//  Created by Jonathan on 7/26/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
@import Firebase;
@import FirebaseStorage;

@interface LoginViewController ()

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

@end

@implementation LoginViewController

- (BOOL)isInLoginMode {
    return (self.loginRegisterSegmentedControl.selectedSegmentIndex == 0);
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.inputsContainerView.layer.cornerRadius = 5;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
//    self.profileImageView.image = image selected from UIImagePickerController
    
}

- (IBAction)didPressLoginRegisterButton:(id)sender {
    
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
                NSLog(@"User email: %@", user.email);
                NSLog(@"User uid: %@", user.uid);
                
                
                
                // Store user profile image into Firebase storage, then update user.photoURL to point to that location
                //Create UUID for profile image name
                NSString *profileImageUUID = [NSUUID UUID].UUIDString;
                NSString *profileImageName = [profileImageUUID stringByAppendingString:@".jpg"];
                
                // store a compressed version to reduce network traffic
                NSData *profileImageData = UIImageJPEGRepresentation(profileImage, 0.1);
                
                //TODO: figure out a way to chain these together?
                FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:@"gs://bloquery-a45f7.appspot.com"];
                
                FIRStorageReference *profileImagesRef = [storageRef child:@"profile_images"];
                
                FIRStorageReference *profileImageNameRef = [profileImagesRef child:profileImageName];
                
                
                // Upload the file to the path "profile_images/image-name.png"
                [profileImageNameRef putData:profileImageData metadata:nil completion:^(FIRStorageMetadata *metadata,NSError *error) {
                    if (error != nil) {
                        NSLog(@"File upload error: %@", error);
                    } else {
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
                        NSURL *downloadURL = [metadata downloadURL];
                        changeRequest.photoURL = downloadURL;
                        [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                            if (error) {
                                // An error happened.
                            } else {
                                // Profile updated.
                                NSLog(@"Profile Updated");
                            }
                        }];
                    }
                }];

                
                [self dismissViewControllerAnimated:YES completion:nil];

            }

        }];
    }
}

@end
