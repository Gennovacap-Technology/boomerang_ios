//
//  User.m
//  Bangarang
//
//  Created by Nielson Rolim on 8/24/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "User.h"

static User* _currentUser = nil;

@implementation User

@dynamic username;
@dynamic email;
@dynamic gender;
@dynamic facebookId;
@dynamic firstName;
@dynamic lastName;
@dynamic photoURL;

+ (NSString *)parseModelClass {
    return @"User";
}

+ (User*) currentUser {
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _currentUser = [User parseModelUserWithParseUser:[PFUser currentUser]];
    });
    return _currentUser;
}

+ (void) setCurrentUser:(PFUser *)parseUser {
    _currentUser = [User parseModelUserWithParseUser:parseUser];
}

+ (void) facebookLoginWithCompletion:(MYCompletionBlock)completion {
    NSArray *permissions = @[@"public_profile", @"email", @"user_friends", @"user_photos", @"user_relationships"];
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            
            [User logout];
            
            if (completion) {
                completion(self, NO, nil, [User currentUser]);
            }
            
        } else {
            [User setCurrentUser:user];
            
            if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
            } else {
                NSLog(@"User logged in through Facebook!");
            }

            NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
            [parameters setValue:@"id,email,gender,first_name,last_name" forKey:@"fields"];
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // result is a dictionary with the user's Facebook data
                    NSDictionary *userData = (NSDictionary *)result;
                    NSString *facebookId = userData[@"id"];
                    NSString *email = userData[@"email"];
                    NSString *gender = userData[@"gender"];
                    NSString *firstName = userData[@"first_name"];
                    NSString *lastName = userData[@"last_name"];
                    NSString* photoURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookId];

                    User* currentUser = [User currentUser];
                    
                    currentUser.facebookId = facebookId;
                    currentUser.email = email;
                    currentUser.gender = gender;
                    currentUser.firstName = firstName;
                    currentUser.lastName = lastName;
                    currentUser.photoURL = photoURL;
                    
                    [currentUser.parseUser saveInBackground];
                    
                    if (completion) {
                        completion(self, error == nil, error, [User currentUser]);
                    }
                }
            }];
        }
    }];
}

+ (void) logout {
    _currentUser = nil;
    [PFUser logOut];
}

@end
