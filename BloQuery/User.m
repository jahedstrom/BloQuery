//
//  User.m
//  BloQuery
//
//  Created by Jonathan on 9/15/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "User.h"

@import FirebaseAuth;
@import FirebaseDatabase;

@interface User ()

@property (nonatomic, strong) NSString *uid;

@end

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andUID:(NSString *)uid {
    self = [super init];
    
    if (self) {
        self.uid = uid;
        self.name = dictionary[@"name"];
        self.email = dictionary[@"email"];
        self.profileImageURL = dictionary[@"profileImageURL"];
        self.descriptionText = dictionary[@"description"];
    }
    
    
    return self;
}

- (instancetype)initWithFIRUser:(FIRUser *)user {
    self = [super init];
    
    if (self) {
        self.uid = user.uid;
        self.name = user.displayName;
        self.email = user.email;
        self.profileImageURL = [user.photoURL absoluteString];
    }
    
    
    return self;
}

- (void)getUserDataWithCompletion:(void (^)(User *, NSError *))block {
    
    FIRDatabaseReference *userRef = [[[[FIRDatabase database] reference] child:@"users"] child:self.uid];
    
    [userRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]) {
            User *user = [[User alloc] initWithDictionary:snapshot.value andUID:snapshot.key];
            block(user, nil);
        }
    }];
    
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
