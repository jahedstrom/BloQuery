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

@interface Question : NSObject


@property (nonatomic, strong) NSString *questionUID;
@property (nonatomic, strong) NSString *questionText;
@property (nonatomic, assign) NSInteger numberOfAnswers;
@property (nonatomic, strong) NSArray *answers;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithUser:(FIRUser *)user andQuestionText:(NSString *)questionText;

- (Answer *)getAnswerForIndex:(NSInteger)index;
- (void)loadAnswers;

- (void)saveToFirebaseWithCompletionHandler:(void (^)(NSError *error))block;

@end
