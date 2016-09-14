//
//  NewAnswerController.m
//  BloQuery
//
//  Created by Jonathan on 9/14/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "NewAnswerController.h"
#import "Answer.h"
#import "Question.h"

@import FirebaseAuth;

@interface NewAnswerController ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *theNewAnswerTextField;


@end

@implementation NewAnswerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.questionLabel.text = self.question.questionText;
}

- (IBAction)submitNewAnswerButtonPressed:(UIButton *)sender {
    FIRUser *firUser = [FIRAuth auth].currentUser;
    
    // create answer
    Answer *newAnswer = [[Answer alloc] initWithUser:firUser andAnswerText:self.theNewAnswerTextField.text];
    
    [self.question addAnswerToQuestion:newAnswer];
    
    [newAnswer saveToFirebaseWithKey:self.question.firKey andCompletionHandler:^(NSError *error) {
        if (error == nil) {
            // go back to Answer view controller
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            //TODO something with error
        }
    }];
}

@end
