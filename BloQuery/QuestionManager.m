//
//  QuestionManager.m
//  BloQuery
//
//  Created by Jonathan on 8/3/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "QuestionManager.h"
#import "Question.h"

@import FirebaseDatabase;

@interface QuestionManager () {
    NSMutableArray *_questions;
}

@property (nonatomic, strong) NSArray *questions;

@end

@implementation QuestionManager

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        self.questions = [NSMutableArray array];
 
//        [self loadTestData];
        
    }
    
    return self;
}

- (void)retrieveQuestionsWithCompletionHandler:(void (^)(NSArray *questions, NSError *error))block {
    FIRDatabaseReference *firRef = [[[FIRDatabase database] reference] child:@"questions"];

        [[firRef queryOrderedByChild:@"numberOfAnswers"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {

//        NSLog(@"snapshot: %@", snapshot.value);

        if ([snapshot exists]) {
            [_questions removeAllObjects];
            for (FIRDataSnapshot *snap in snapshot.children) {
                NSLog(@"snap: %@", snap);
                Question *question = [[Question alloc] initWithDictionary:snap.value andKey:snap.key];
                [_questions addObject:question];
            }
        } else {
//            self.questions = nil;
        }
        //TODO check for errors and if necessary generate NSError object to send back in block
        block(self.questions, nil);
    }];
}

- (void)reverseArray {
    NSArray* reversedArray = [[self.questions reverseObjectEnumerator] allObjects];
    self.questions = reversedArray;
}

- (void)loadTestData {
    for (int i = 0; i < 10; i++) {
        Question *question = [[Question alloc] init];
        
        question.questionText = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris imperdiet ut nunc at blandit. Aliquam vitae quam ut orci tincidunt facilisis ac at enim. Cras rhoncus nisi quis nibh dapibus, vitae rhoncus sapien posuere.";
        
        question.numberOfAnswers = arc4random_uniform(15);
                
        [_questions addObject:question];
    }
}

@end
