//
//  Question.m
//  BloQuery
//
//  Created by Jonathan on 8/2/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "Question.h"
#import "Answer.h"

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface Question ()

@property (nonatomic, strong) FIRDatabaseReference *firRef;


@end

@implementation Question

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andKey:(NSString *)key{
    self = [super init];
    
    if (self) {
        self.questionUID = dictionary[@"UID"];
        self.questionText = dictionary[@"questionText"];
        self.firKey = key;
        self.numberOfAnswers = [dictionary[@"numberOfAnswers"] integerValue];
        self.answers = [[NSArray alloc] init];
        }
    
    
    return self;
}


- (instancetype)initWithUser:(FIRUser *)user andQuestionText:(NSString *)questionText {
    self = [super init];
    
    if (self) {
        self.questionUID = user.uid;
        self.questionText = questionText;
        self.firKey = nil;
        self.answers = [[NSArray alloc] init];
        self.numberOfAnswers = 0;
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
    return @{@"UID" : self.questionUID, @"questionText" : self.questionText, @"numberOfAnswers" : numberOfAnswers};
}

- (void)addAnswerToQuestion:(Answer *)answer {
    //get current answer array
    NSMutableArray *addAnswer = [[NSMutableArray alloc] initWithArray:self.answers];
    
    // add the new answer
    [addAnswer addObject:answer];
    
    // assign back to original array
    self.answers = addAnswer;
    
    // increase answer count 
    self.numberOfAnswers += 1;
}


- (void)saveToFirebaseWithCompletionHandler:(void (^)(NSError *))block {
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
    //          - AutoID
    //              -user.uid [NSString]
    //              -answerText [NSString]
    //          - AutoID {...}
    //          - AutoID {...}
    
    // get firebase ref
    // build NSDictionary object
    // call setValues
    
    self.firRef = [[FIRDatabase database] reference];
    
    FIRDatabaseReference *questionRef;
    
    questionRef = [[self.firRef child:@"questions"] childByAutoId];
                   
    [questionRef setValue:[self dictionary] withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error == nil) {
            self.firKey = ref.key;
        } else {
            // TODO something with error
        }
    }];
    
    block(nil);
}

- (void)retrieveAnswersWithCompletionHandler:(void (^)(NSArray *, NSError *))block {
    FIRDatabaseReference *firAnswersRef = [[[[FIRDatabase database] reference] child:@"answers"] child:self.firKey];
    
    [firAnswersRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSDictionary *answerDict = snapshot.value;
        NSMutableArray *tempAnswers = [[NSMutableArray alloc] initWithCapacity:1];
        NSError *error;
        
        if (!(answerDict == (id)[NSNull null])) {
            [answerDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                Answer *answer = [[Answer alloc] initWithDictionary:obj];
                [tempAnswers addObject:answer];
            }];
            self.answers = tempAnswers;
            self.numberOfAnswers = tempAnswers.count;
            error = nil;
        } else {
            self.answers = nil;
            self.numberOfAnswers = 0;
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"There are no answers to the question", nil),
                                       };
            error = [NSError errorWithDomain:@"com.jahedstrom.BloQuery" code:-1 userInfo:userInfo];
        }
        
        block(self.answers, error);
    }];
 
}

- (Answer *)getAnswerForIndex:(NSInteger)index {
    return self.answers[index];
}

@end
