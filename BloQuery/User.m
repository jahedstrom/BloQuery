//
//  User.m
//  BloQuery
//
//  Created by Jonathan on 7/27/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "User.h"
@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;

@interface User ()

@property (nonatomic, strong) FIRUser *firUser;

@end


@implementation User

- (instancetype)initWithFIRUser:(FIRUser *)user {
    if (self = [super init]) {
    }
    
    return self;
}

- (NSString *)uid {
    return self.firUser.uid;
}


// go get user from firebase for uid
- (void)addProfilePicture:(UIImage *)image {
    
}

@end
