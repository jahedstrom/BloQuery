//
//  FIRAuth+User.h
//  BloQuery
//
//  Created by Jonathan on 9/6/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <FirebaseAuth/FirebaseAuth.h>
#import <UIKit/UIKit.h>

@interface FIRAuth (User)

- (void)addUserData:(NSDictionary *)userData;

- (NSURL *)addProfilePicture:(UIImage *)image;

@end
