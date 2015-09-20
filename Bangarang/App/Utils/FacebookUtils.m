//
//  FacebookUtils.m
//  Bangarang
//
//  Created by Thales Pereira on 9/20/15.
//  Copyright © 2015 Gennovacap. All rights reserved.
//

#import "FacebookUtils.h"

@implementation FacebookUtils

+ (void)loginWithFacebookWithBlock:(void (^)(void))onSuccess
                           onError:(void (^)(void))onError {
    
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends", @"user_photos", @"user_relationships"];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            onError();
        } else if (user.isNew) {
            [self updateUserInfo:user];
            onSuccess();
        } else {
            [self updateUserInfo:user];
            onSuccess();
        }
    }];
}

+ (void)updateUserInfo:(PFUser *)user {
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:@"id,email,gender,first_name,last_name" forKey:@"fields"];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me"
                                  parameters:parameters];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookId = userData[@"id"];
            NSString *email = userData[@"email"];
            NSString *gender = userData[@"gender"];
            NSString *firstName = userData[@"first_name"];
            NSString *lastName = userData[@"last_name"];
            NSString* photoURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookId];
            
            user[kUserFacebookIdKey] = facebookId;
            user[kUserEmailKey] = email;
            user[kUserGenderKey] = gender;
            user[kUserFirstNameKey] = firstName;
            user[kUserLastNameKey] = lastName;
            user[kUserPhotoURLKey] = photoURL;
            
            [user saveInBackground];
        }
    }];
}

@end
