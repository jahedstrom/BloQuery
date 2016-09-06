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
@property (nonatomic, strong) NSString *uid;
@end


@implementation User

+ (User *)currentUser {
    return nil;
}

+ (void)setCurrentUser:(User *)user {
    
}

- (instancetype)initWithFIRUser:(FIRUser *)user {
    if (self = [super init]) {
        
        self.uid = user.uid;
        self.name = user.displayName;
        self.email = user.email;
        self.profileImageURL = user.photoURL;
        
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
