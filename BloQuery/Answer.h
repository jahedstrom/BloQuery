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

@property (nonatomic, strong) NSString *answerText;
@property (nonatomic, strong) NSString *answerUID;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithUser:(FIRUser *)user andAnswerText:(NSString *)answerText;

- (void)saveToFirebaseWithCompletionHandler:(void (^)(NSError *error))block;

@end
