//
//  ProfileViewController.h
//  BloQuery
//
//  Created by Jonathan on 9/21/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (nonatomic) BOOL isCurrentUser;

@end
