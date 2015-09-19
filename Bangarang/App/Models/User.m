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
            
            // User info request

            NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
            [parameters setValue:@"id,email,gender,first_name,last_name" forKey:@"fields"];
            
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:@"me"
                                          parameters:parameters];
            
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
            
            // Friends Request
            /*[parameters setValue:@"id" forKey:@"fields"];
            
            FBSDKGraphRequest *requestFriends = [[FBSDKGraphRequest alloc]
                                                 initWithGraphPath:@"/me/friends"
                                                 parameters:parameters
                                                 HTTPMethod:@"GET"];
            
            [requestFriends startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                         id result,
                                                         NSError *error) {
                
                if (error) {
                    // We must erase the cache
                    //[[PINCache sharedCache] setObject: forKey:@"facebookFriends" block:nil];
                } else {
                    NSArray *data = [result objectForKey:@"data"];
                    NSMutableArray *facebookFriends = [[NSMutableArray alloc] initWithCapacity:[data count]];
                    
                    for (NSDictionary *friendData in data) {
                        if (friendData[@"id"]) {
                            [facebookFriends addObject:friendData[@"id"]];
                        }
                    }
                    
                    [[PINCache sharedCache] setObject:facebookFriends forKey:@"facebookFriends" block:nil];
                    
                    NSArray *facebookFriendsFromCache = [[PINCache sharedCache] objectForKey:@"facebookFriends"];
                    
                    PFQuery *friends = [PFUser query];
                    [friends whereKey:@"facebookId" containedIn:facebookFriendsFromCache];
                    
                    [friends findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            // The find succeeded.
                            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
                            // Do something with the found objects
                            for (PFObject *object in objects) {
                                NSLog(@"%@", object.objectId);
                            }
                        } else {
                            // Log details of the failure
                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                        }
                    }];
                }
                
                
            }];*/
        }
    }];
}

+ (void) logout {
    _currentUser = nil;
    [PFUser logOut];
}

@end
