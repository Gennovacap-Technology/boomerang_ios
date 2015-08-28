//
//  User.h
//  Bangarang
//
//  Created by Nielson Rolim on 8/24/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "ParseModelUser.h"

@interface User : ParseModelUser

@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* gender;
@property (nonatomic, strong) NSString* facebookId;
@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSString* photoURL;

+ (User*) currentUser;
+ (void) setCurrentUser:(PFUser *)parseUser;
+ (void) facebookLoginWithCompletion:(MYCompletionBlock)completion;
+ (void) logout;

@end
