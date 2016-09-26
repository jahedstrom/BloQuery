//
//  QuestionManager.h
//  BloQuery
//
//  Created by Jonathan on 8/3/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QuestionManager : NSObject

@property (nonatomic, strong, readonly) NSArray *questions;

+ (instancetype)sharedInstance;

- (void)retrieveQuestionsWithCompletionHandler:(void (^)(NSArray *questions, NSError *error))block;

- (void)reverseArray;

@end
