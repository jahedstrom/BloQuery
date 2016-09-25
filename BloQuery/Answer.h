//
//  Answer.h
//  BloQuery
//
//  Created by Jonathan on 8/3/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class FIRUser;

@interface Answer : NSObject

@property (nonatomic, strong) NSString *firKey;  // used to locate an answer in database for updating
@property (nonatomic, strong) NSString *answerText;
@property (nonatomic, strong) NSString *answerUID;
@property (nonatomic, assign) NSInteger numberOfVotes;
@property (nonatomic, strong) NSDictionary *voters;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andKey:(NSString *)key;
- (instancetype)initWithUser:(FIRUser *)user andAnswerText:(NSString *)answerText;

- (void)saveToFirebaseWithKey:(NSString *)key andCompletionHandler:(void (^)(NSError *error))block;
- (void)getUserWithCompletion:(void (^)(User *user, NSError *error))block;
- (void)changeVoteCountOnAnswerWithKey:(NSString *)key andCompletionHandler:(void (^)(NSError *error))block;

@end
