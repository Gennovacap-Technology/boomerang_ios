//
//  Constants.m
//  Bangarang
//
//  Created by Thales Pereira on 9/6/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "Constants.h"

NSTimeInterval const kWaitingViewDefaultHideInterval = 3.0f;

#pragma mark - UITableViewCellIdentifier

// FriendsListViewController
NSString *const kFriendsListGenderCell = @"genderCell";
NSString *const kFriendsListFriendCell = @"friendCell";

#pragma mark - User Class

NSString *const kUserFirstNameKey  = @"firstName";
NSString *const kUserLastNameKey   = @"lastName";
NSString *const kUserEmailKey      = @"email";
NSString *const kUserFacebookIdKey = @"facebookId";
NSString *const kUserGenderKey     = @"gender";
NSString *const kUserPhotoURLKey   = @"photoURL";
NSString *const kUserBangsKey      = @"bangs";
NSString *const kUserHooksKey      = @"hooks";

#pragma mark - Request Class

NSString *const kRequestClass    = @"Request";

NSString *const kRequestFromUser = @"fromUser";
NSString *const kRequestToUser   = @"toUser";
NSString *const kRequestType     = @"type";
NSString *const kRequestAccepted = @"accepted";

NSString *const kRequestTypeBang = @"bangs";
NSString *const kRequestTypeHook = @"hooks";

#pragma mark - Facebook Attributes

NSString *const kFacebookMaleString   = @"male";
NSString *const kFacebookFemaleString = @"female";

#pragma mark - Parse

NSString *const kParseApplicationId = @"oUWt7oahon42aIrWTi6LebwTO6AXuRZ6tfVZjzV2";
NSString *const kParseClientKey     = @"2BotsOMQoBU1xU8Qk1RSIGbLSJ7vGUf8rCkVvJvC";

#pragma mark - Firebase

NSString *const kFirebaseUrl = @"https://appcraft-chat-test.firebaseio.com";

#pragma mark - Friends List Relation Button Image

NSString *const kFriendsListRequestButtonImageInitialState = @"Bomb";
NSString *const kFriendsListRequestButtonImageBangRequestPending = @"BombPinkBackground";
NSString *const kFriendsListRequestButtonImageBangList = @"Boomerang";
NSString *const kFriendsListRequestButtonImageHookRequestPending = @"BoomerangPinkBackground";
NSString *const kFriendsListRequestButtonImageHookList = @"HeartPinkBackground";