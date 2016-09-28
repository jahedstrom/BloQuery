//
//  Answer.m
//  BloQuery
//
//  Created by Jonathan on 8/3/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "Answer.h"
#import "User.h"

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface Answer ()

@property (nonatomic, strong) FIRDatabaseReference *firRef;

@end

@implementation Answer

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andKey:(NSString *)key {
    self = [super init];
    
    if (self) {
        self.answerUID = dictionary[@"UID"];
        self.answerText = dictionary[@"answerText"];
        self.numberOfVotes = [dictionary[@"numberOfVotes"] integerValue];
        self.firKey = key;
        self.voters = [[NSDictionary alloc] initWithDictionary:dictionary[@"voters"]];
    }
    
    
    return self;
}


- (instancetype)initWithUser:(FIRUser *)user andAnswerText:(NSString *)answerText{
    self = [super init];
    
    if (self) {
        self.answerUID = user.uid;
        self.answerText = answerText;
        self.numberOfVotes = 0;
        self.firKey = nil;
        self.voters = nil;
    }
    
    return self;
}

- (NSDictionary *)dictionary {
    NSNumber *numberOfVotes = [NSNumber numberWithInteger:self.numberOfVotes];
    return @{@"UID" : self.answerUID, @"answerText" : self.answerText, @"numberOfVotes" : numberOfVotes};
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
    
    // Use question.firKey for new child node, all answers under that node will have an AutoID
    [[[[self.firRef child:@"answers"] child:key] childByAutoId] setValue:[self dictionary] withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error == nil) {
            self.firKey = ref.key;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    block(nil);
}

- (void)getUserWithCompletion:(void (^)(User *, NSError *))block {
    
    FIRDatabaseReference *userRef = [[[[FIRDatabase database] reference] child:@"users"] child:self.answerUID];
    
    [userRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]) {
            User *user = [[User alloc] initWithDictionary:snapshot.value andUID:snapshot.key];
            block(user, nil);
        }
    }];
    
}

- (void)changeVoteCountOnAnswerWithKey:(NSString *)key andCompletionHandler:(void (^)(NSError *))block {
    
    // get reference to current answer
    FIRDatabaseReference *currentAnswerRef = [[[[[FIRDatabase database] reference] child:@"answers"] child:key] child:self.firKey];
    
    [currentAnswerRef runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
        NSMutableDictionary *answer = currentData.value;
        if (!answer || [answer isEqual:[NSNull null]]) {
            return [FIRTransactionResult successWithValue:currentData];
        }
        
        NSMutableDictionary *voters = [answer objectForKey:@"voters"];
        if (!voters) {
            voters = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        NSString *uid = [FIRAuth auth].currentUser.uid;
        int numberOfVotes = [answer[@"numberOfVotes"] intValue];
        if ([voters objectForKey:uid]) {
            // Unstar the anser and remove self from voters dictionary
            numberOfVotes--;
            [voters removeObjectForKey:uid];
        } else {
            // Star the answer and add self to voters dictionary
            numberOfVotes++;
            voters[uid] = @YES;
        }
        answer[@"voters"] = voters;
        answer[@"numberOfVotes"] = @(numberOfVotes);
        
        // Set value and report transaction success
        [currentData setValue:answer];
        return [FIRTransactionResult successWithValue:currentData];
    } andCompletionBlock:^(NSError * _Nullable error,
                           BOOL committed,
                           FIRDataSnapshot * _Nullable snapshot) {
        // Transaction completed
        if (error == nil) {
            block(nil);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


@end
