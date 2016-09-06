//
//  Question.h
//  BloQuery
//
//  Created by Jonathan on 8/2/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class Answer;

@interface Question : NSObject


@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *questionText;
@property (nonatomic, assign) NSInteger numberOfAnswers;
@property (nonatomic, strong) NSArray *answers;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithUser:(User *)user andQuestionText:(NSString *)questionText;

- (Answer *)getAnswerForIndex:(NSInteger)index;
- (void)loadAnswers;

- (void)saveToFirebase;

@end
