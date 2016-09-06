//
//  Question.m
//  BloQuery
//
//  Created by Jonathan on 8/2/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "Question.h"
#import "User.h"
#import "Answer.h"

@interface Question ()


@end

@implementation Question

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        //TODO: parse dictionary into question object
        }
    
    
    return self;
}


- (instancetype)initWithUser:(User *)user andQuestionText:(NSString *)questionText {
    self = [super init];
    
    if (self) {
        self.user = user;
        self.questionText = questionText;
        self.answers = [[NSArray alloc] init];
        self.numberOfAnswers = 0;
        // [self saveToFirebase] ?
    }
    
    return self;

}

- (instancetype)init {
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

- (NSDictionary *)dictionary {
    NSNumber *numberOfAnswers = [NSNumber numberWithInteger:self.numberOfAnswers];
    return @{@"User" : self.user.name, @"questionText" : self.questionText, @"numberOfAnswers" : numberOfAnswers};
}

- (void)saveToFirebase {
 // store self.user, questionText, answers, and numberOfAnswers into Firebase
    // for flatter data structure organize like this:
    //    questions
    //      -AutoUID
    //          -user.uid [NSString]
    //          -questionText [NSString]
    //          -numberOfAnswers [NSInteger]
    //
    //    answers
    //      -Question AutoUID
    //          - Answer1
    //              -user [NSString]
    //              -Answertext [NSString]
    //          - Answer2 {...}
    //          - Answer3 {...}
    
    // get firebase ref
    // build NSDictionary object
    // call setValues
    
}

- (void)loadAnswers {
    // do something to get the answers for each question
    NSMutableArray *tempAnswers = [NSMutableArray arrayWithCapacity:8];
    for (int i =0; i < self.numberOfAnswers; i++) {
        Answer *tmpAnswer = [[Answer alloc] init];
        NSString *randomAnswer = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce blandit fringilla justo quis euismod. Mauris nec laoreet risus. Nulla facilisi.";
        tmpAnswer.answerText = randomAnswer;
        [tempAnswers addObject:tmpAnswer];
    }
    self.answers = tempAnswers;
}

- (Answer *)getAnswerForIndex:(NSInteger)index {
    return self.answers[index];
}

@end
