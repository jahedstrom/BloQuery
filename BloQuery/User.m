//
//  User.m
//  BloQuery
//
//  Created by Jonathan on 9/15/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "User.h"

@import FirebaseAuth;

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.name = dictionary[@"name"];
        self.email = dictionary[@"email"];
        self.profileImageURL = dictionary[@"profileImageURL"];
    }
    
    
    return self;
}

- (instancetype)initWithFIRUser:(FIRUser *)user {
    self = [super init];
    
    if (self) {
        self.name = user.displayName;
        self.email = user.email;
        self.profileImageURL = [user.photoURL absoluteString];
    }
    
    
    return self;
}


- (void)getProfileImageforUserWithCompletionHandler:(void (^)(UIImage *, NSError *))block {
    
    NSURL *profileImageURL = [NSURL URLWithString:self.profileImageURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:profileImageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
        // want to return UIImage...
        UIImage *profileImage = [UIImage imageWithData:data];
        block(profileImage, nil);
        } else {
            block(nil, error);
        }
    }];
    
    [dataTask resume];
}


@end
