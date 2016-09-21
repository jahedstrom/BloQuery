//
//  User.h
//  BloQuery
//
//  Created by Jonathan on 9/15/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FIRUser;

@interface User : NSObject

@property (nonatomic, readonly) NSString *uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *profileImageURL;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithFIRUser:(FIRUser *)user;

- (void)getProfileImageforUserWithCompletionHandler:(void (^)(UIImage *image, NSError *error))block;


@end
