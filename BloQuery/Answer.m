//
//  Answer.m
//  BloQuery
//
//  Created by Jonathan on 8/3/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "Answer.h"

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface Answer ()

@property (nonatomic, strong) FIRDatabaseReference *firRef;

@end

@implementation Answer

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        //TODO: parse dictionary into question object
        self.answerUID = dictionary[@"UID"];
        self.answerText = dictionary[@"answerText"];
    }
    
    
    return self;
}


- (instancetype)initWithUser:(FIRUser *)user andAnswerText:(NSString *)answerText{
    self = [super init];
    
    if (self) {
        self.answerUID = user.uid;
        self.answerText = answerText;
    }
    
    return self;
}

- (NSDictionary *)dictionary {
    return @{@"UID" : self.answerUID, @"answerText" : self.answerText};
}

- (void)saveToFirebaseWithKey:(NSString *)key andCompletionHandler:(void (^)(NSError *))block {
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
    
    // get question.firKey and use for new child node
    
    
    [[[[self.firRef child:@"answers"] child:key] childByAutoId] setValue:[self dictionary]];
    
    block(nil);
    
    
}


@end
