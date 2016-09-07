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

@property (weak, nonatomic) IBOutlet UITextView *questionTextView;

@end

@implementation QuestionViewController

- (void)viewDidLoad {
  
    //To make a border
    [self.questionTextView.layer setBorderColor:[[[UIColor blackColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.questionTextView.layer setBorderWidth:2.0];
    self.questionTextView.layer.cornerRadius = 5;
    self.questionTextView.clipsToBounds = YES;
}


- (IBAction)submitButtonPressed:(UIButton *)sender {
    
    // create question
    
    // How to get current user?
    FIRUser *firUser = [FIRAuth auth].currentUser;

    Question *newQuestion = [[Question alloc] initWithUser:firUser andQuestionText:self.questionTextView.text];
    
    NSLog(@"Question Text : %@", self.questionTextView.text);
}

@end
