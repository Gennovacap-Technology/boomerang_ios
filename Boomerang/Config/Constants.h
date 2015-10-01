//
//  Constants.h
//  Bangarang
//
//  Created by Thales Pereira on 9/6/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - iPhone model detection macros

typedef enum {
    kFriendNoRelation = 0,
    kFriendBangRequestSent = 1,
    kFriendBangRelation = 2,
    kFriendHookRequestSent = 3,
    kFriendHookRelation = 4,
} kFriendRelationIndex;

extern NSTimeInterval const kDefaultWaitingViewHideInterval;

#pragma mark - UITableViewCellIdentifier

extern NSString *const kFriendsListGenderCell;
extern NSString *const kFriendsListFriendCell;

#pragma mark - User Class

extern NSString *const kUserFirstNameKey;
extern NSString *const kUserLastNameKey;
extern NSString *const kUserEmailKey;
extern NSString *const kUserFacebookIdKey;
extern NSString *const kUserGenderKey;
extern NSString *const kUserPhotoURLKey;
extern NSString *const kUserBangsKey;
extern NSString *const kUserHooksKey;

#pragma mark - Request Class

extern NSString *const kRequestClass;

extern NSString *const kRequestFromUser;
extern NSString *const kRequestToUser;
extern NSString *const kRequestType;
extern NSString *const kRequestAccepted;
extern NSString *const kRequestFromUserRead;
extern NSString *const kRequestToUserRead;

extern NSString *const kRequestTypeBang;
extern NSString *const kRequestTypeHook;

#pragma mark - Facebook Attributes

extern NSString *const kFacebookMaleString;
extern NSString *const kFacebookFemaleString;
extern NSString *const kFacebookProfilePictureUrl;

#pragma mark - Parse

extern NSString *const kParseApplicationId;
extern NSString *const kParseClientKey;

#pragma mark - Firebase

extern NSString *const kFirebaseUrl;

#pragma mark - Friends List Relation Button Image

extern NSString *const kFriendsListRequestButtonImageInitialState;
extern NSString *const kFriendsListRequestButtonImageBangRequestPending;
extern NSString *const kFriendsListRequestButtonImageBangList;
extern NSString *const kFriendsListRequestButtonImageHookRequestPending;
extern NSString *const kFriendsListRequestButtonImageHookList;