//
//  FIRAuth+User.m
//  BloQuery
//
//  Created by Jonathan on 9/6/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "FIRAuth+User.h"
#import "Constants.h"

@import FirebaseAuth;
@import FirebaseStorage;

@implementation FIRAuth (User)

- (void)addUserData:(NSDictionary *)userData {
    
//    FIRDatabaseReference *userRef = [[self.reference child:@"users"] child:user.uid];
//
//    NSDictionary *userDict = @{@"name" : fullName, @"email" : email, @"profile_image_url" : [downloadURL absoluteString]};
//    
//    [userRef updateChildValues:userDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
//        if (error != nil) {
//            NSLog(@"User save error: %@", error);
//        } else {
//            NSLog(@"Successfully saved user");
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//    }];
    
}

- (NSURL *)addProfilePicture:(UIImage *)image {
    
    __block NSURL *profileImageURL;
    // Store user profile image into Firebase storage, then update user.photoURL to point to that location
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
            profileImageURL = nil;
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            
            
            profileImageURL = [metadata downloadURL];
           
        }
    }];
    
    return profileImageURL;
}


@end
