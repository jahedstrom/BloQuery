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
@property (nonatomic, strong) NSString *descriptionText;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andUID:(NSString *)uid;
- (instancetype)initWithFIRUser:(FIRUser *)user;

- (void)getProfileImageforUserWithCompletionHandler:(void (^)(UIImage *image, NSError *error))block;
- (void)getUserDataWithCompletion:(void (^)(User *, NSError *))block;



@end
