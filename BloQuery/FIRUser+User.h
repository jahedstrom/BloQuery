//
//  FIRUser+User.h
//  BloQuery
//
//  Created by Jonathan on 9/6/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <FirebaseAuth/FIRUser.h>
#import <UIKit/UIKit.h>

@interface FIRUser (User)

- (void)addUserData:(NSDictionary *)userData complete:(void (^)(NSError *error))block;

- (void)addProfilePicture:(UIImage *)image complete:(void (^)(NSURL *profileImageURL, NSError *error))block;
- (void)getProfilePicture:(NSURL *)imageURL complete:(void (^)(UIImage *profileImage, NSError *error))block;

@end
