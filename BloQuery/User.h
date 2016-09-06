//
//  User.h
//  BloQuery
//
//  Created by Jonathan on 7/27/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FIRUser;

@interface User : NSObject

@property (nonatomic, readonly) NSString *uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSURL *profileImageURL;

- (instancetype)initWithFIRUser:(FIRUser *)user;

- (void)addProfilePicture:(UIImage *)image;

@end
