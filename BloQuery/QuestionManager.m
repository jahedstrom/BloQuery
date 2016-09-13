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
    
    [firRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        NSLog(@"snapshot: %@", snapshot.value);
        
        NSDictionary *questionDict = snapshot.value;
        
        if (questionDict != nil) {
//            NSLog(@"snapshot: %@", snapshot.value);
//            Question *question = [[Question alloc] initWithDictionary:snapshot.value];
//            [_questions addObject:question];
            [_questions removeAllObjects];
            [questionDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                //             NSLog(@"%@ => %@", key, obj);
                Question *question = [[Question alloc] initWithDictionary:obj];
                [_questions addObject:question];
            }];
        }
        //TODO check for errors and if necessary generate NSError object to send back in block
        block(self.questions, nil);
    }];
}

- (void)loadTestData {
    for (int i = 0; i < 10; i++) {
        Question *question = [[Question alloc] init];
        
        question.questionText = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris imperdiet ut nunc at blandit. Aliquam vitae quam ut orci tincidunt facilisis ac at enim. Cras rhoncus nisi quis nibh dapibus, vitae rhoncus sapien posuere.";
        
        question.numberOfAnswers = arc4random_uniform(15);
        
        [question loadAnswers];
        
        [_questions addObject:question];
    }
}

@end
