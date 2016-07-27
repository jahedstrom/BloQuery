//
//  LoginViewController.h
//  BloQuery
//
//  Created by Jonathan on 7/26/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *inputsContainerView;
@property (weak, nonatomic) IBOutlet UIButton *loginRegisterButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *loginRegisterSegmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputsContainerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameFieldHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userFullName;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@end
