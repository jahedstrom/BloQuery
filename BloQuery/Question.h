//
//  Question.h
//  BloQuery
//
//  Created by Jonathan on 8/2/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FIRUser;
@class Answer;
@class User;

@interface Question : NSObject

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *questionUID;
@property (nonatomic, strong) NSString *questionText;
@property (nonatomic, strong) NSString *firKey;
@property (nonatomic, assign) NSInteger numberOfAnswers;
@property (nonatomic, strong) NSArray *answers;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andKey:(NSString*)key;
- (instancetype)initWithUser:(FIRUser *)user andQuestionText:(NSString *)questionText;

- (Answer *)getAnswerForIndex:(NSInteger)index;
- (void)addAnswerToQuestion:(Answer *)answer;

- (void)getUserWithCompletion:(void (^)(User *user, NSError *error))block;

- (void)saveToFirebaseWithCompletionHandler:(void (^)(NSError *error))block;
- (void)retrieveAnswersWithCompletionHandler:(void (^)(NSArray *answers, NSError *error))block;

@end
