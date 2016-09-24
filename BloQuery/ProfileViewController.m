//
//  ProfileViewController.m
//  BloQuery
//
//  Created by Jonathan on 9/21/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "ProfileViewController.h"
#import "FIRUser+User.h"
#import "User.h"

@import FirebaseAuth;

@interface ProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionTextViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *imageTapGestureRecognizer;

@property (nonatomic) BOOL isInEditMode;

@property (nonatomic, strong) UIImage *profileImage;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileImageView.layer.cornerRadius = 75;
    self.profileImageView.clipsToBounds = YES;
    
    // Setup TextView with border for displaying in editing mode
    [self.descriptionTextView.layer setBorderColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] CGColor]];
    self.descriptionTextView.layer.cornerRadius = 5;
    self.descriptionTextView.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isInEditMode = NO;
    self.submitButton.hidden = YES;
    self.usernameTextField.borderStyle = UITextBorderStyleNone;
    self.emailTextField.borderStyle = UITextBorderStyleNone;
    self.imageTapGestureRecognizer.enabled = NO;
    
    if (self.isCurrentUser) {
        self.logoutButton.hidden = NO;
        self.editButton.hidden = NO;
        [self getRealUserData];
    } else {
        self.logoutButton.hidden = YES;
        self.editButton.hidden = YES;
        [self getRealUserData];
    }
}

- (void)getRealUserData {
    [self.user getUserDataWithCompletion:^(User *user, NSError *error) {
        if (error == nil) {
            self.user = user;
            self.usernameTextField.text = self.user.name;
            self.emailTextField.text = self.user.email;
            self.descriptionTextView.text = self.user.descriptionText;
            [self resizeTextView];
            if (!self.profileImage) {
                [self.user getProfileImageforUserWithCompletionHandler:^(UIImage *image, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error == nil && image) {
                            self.profileImage = image;
                            self.profileImageView.image = image;
                        } else {
                            self.profileImageView.image = nil;
                        }
                    });
                }];
            } else {
                self.profileImageView.image = self.profileImage;
            }
        }
    }];
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
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

- (IBAction)didTapProfileImageView:(UITapGestureRecognizer *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];

}

- (IBAction)editButtonPressed:(UIButton *)sender {
    if (self.isInEditMode) {
        self.isInEditMode = NO;
        self.submitButton.hidden = YES;
        self.usernameTextField.borderStyle = UITextBorderStyleNone;
        self.emailTextField.borderStyle = UITextBorderStyleNone;
        [self.descriptionTextView.layer setBorderWidth:0];
    } else {
        self.isInEditMode = YES;
        self.submitButton.hidden = NO;
        self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self.descriptionTextView.layer setBorderWidth:0.5];
        self.imageTapGestureRecognizer.enabled = YES;
    }
}

- (IBAction)submitButonPressed:(UIButton *)sender {
    if (self.isInEditMode ) {
        NSLog(@"Submit button pressed");
        FIRUser *currentUser = [FIRAuth auth].currentUser;
        NSDictionary *userDict = @{@"name" : self.usernameTextField.text, @"email" : self.emailTextField.text, @"image" : self.profileImage, @"description" : self.descriptionTextView.text};
        
        [currentUser addUserData:userDict complete:^(NSError *error) {
            if (error == nil) {
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"Success"
                                             message:@"Changes submitted successfully"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* okButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                            }];
                
                
                [alert addAction:okButton];
                
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                // User loggin to too long, need to re-authenticate before changing email
                if (error.code == 17014) {
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@"Re-authenticate"
                                                 message:@"Please provide login credentials"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* loginButton = [UIAlertAction
                                                  actionWithTitle:@"Login"
                                                  style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action) {
                                                      NSLog(@"Login Button Pressed");
                                                      FIRUser *firUser = [FIRAuth auth].currentUser;
                                                      FIRAuthCredential *credential = [FIREmailPasswordAuthProvider credentialWithEmail:alert.textFields[0].text password:alert.textFields[1].text];
                                          [firUser reauthenticateWithCredential:credential completion:^(NSError * _Nullable error) {
                                              // TODO Present error
                                          }];

                                                      
                                                  }];
                    UIAlertAction* cancelButton = [UIAlertAction
                                                   actionWithTitle:@"Cancel"
                                                   style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {}];
                    
                    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = @"Email Address";
                    }];
                    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = @"Password";
                        textField.secureTextEntry = YES;
                    }];
                    [alert addAction:loginButton];
                    [alert addAction:cancelButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        }];
    }
}

- (void)resizeTextView {
    CGSize sizeThatShouldFitTheContent = [self.descriptionTextView sizeThatFits:self.descriptionTextView.frame.size];
    self.descriptionTextViewHeightConstraint.constant = sizeThatShouldFitTheContent.height;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self resizeTextView];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.isInEditMode) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    self.profileImage = editedImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
