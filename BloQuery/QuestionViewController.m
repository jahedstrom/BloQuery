//
//  QuestionViewController.m
//  BloQuery
//
//  Created by Jonathan on 9/6/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "QuestionViewController.h"
#import "Question.h"

@import FirebaseAuth;

@interface QuestionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *questionTextField;

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //To make a border
//    [self.questionTextField.layer setBorderColor:[[[UIColor blackColor] colorWithAlphaComponent:0.5] CGColor]];
//    [self.questionTextField.layer setBorderWidth:2.0];
//    self.questionTextField.layer.cornerRadius = 5;
//    self.questionTextField.clipsToBounds = YES;
    
}


- (IBAction)submitButtonPressed:(UIButton *)sender {
    
    
    FIRUser *firUser = [FIRAuth auth].currentUser;

    // create question
    Question *newQuestion = [[Question alloc] initWithUser:firUser andQuestionText:self.questionTextField.text];
    
    [newQuestion saveToFirebaseWithCompletionHandler:^(NSError *error) {
        if (error == nil) {
            // go back to Questions table view controller
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            //TODO something with error
        }
    }];
}

@end
