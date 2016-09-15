//
//  FIRUser+User.m
//  BloQuery
//
//  Created by Jonathan on 9/6/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "FIRUser+User.h"
#import "Constants.h"

@import FirebaseAuth;
@import FirebaseStorage;

@implementation FIRUser(User)

- (void)addUserData:(NSDictionary *)userData complete:(void (^)(NSError *error))block {
    
    [self addProfilePicture:userData[@"image"] complete:^(NSURL *profileImageURL, NSError *error) {
        if (error != nil) {
            NSLog(@"failed to get imageURL");
            block(error);
        } else {
            FIRUser *user = [FIRAuth auth].currentUser;
            FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
            
            changeRequest.displayName = userData[@"name"];
            changeRequest.photoURL = profileImageURL;
            [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                if (error) {
                    // An error happened.
                    block(error);
                } else {
                    // Profile updated.
                    NSLog(@"Profile updated successfully");
                    block(nil);
                }
            }];
        }
    }];
}

- (void)addProfilePicture:(UIImage *)image complete:(void (^)(NSURL *profileImageURL, NSError *error))block {

    // Store user profile image into Firebase storage
    //Create UUID for profile image name
    NSString *profileImageUUID = [NSUUID UUID].UUIDString;
    NSString *profileImageName = [profileImageUUID stringByAppendingString:@".jpg"];
    
    // store a compressed version to reduce network traffic
    NSData *profileImageData = UIImageJPEGRepresentation(image, 0.1);
    
    //TODO: figure out a way to chain these together?
    FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:kFirebaseURL];
    
    FIRStorageReference *profileImagesRef = [storageRef child:@"profile_images"];
    
    FIRStorageReference *profileImageNameRef = [profileImagesRef child:profileImageName];
    
    
    // Upload the file to the path "profile_images/image-name.png"
    [profileImageNameRef putData:profileImageData metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            NSLog(@"File upload error: %@", error);
            block(nil, error);
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            NSURL *profileImageURL = [metadata downloadURL];
            block(profileImageURL, nil);
           
        }
    }];

}

- (void)getProfilePicture:(NSURL *)imageURL complete:(void (^)(UIImage *, NSError *))block {
    
}


@end
