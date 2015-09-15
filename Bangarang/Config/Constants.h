//
//  Constants.h
//  Bangarang
//
//  Created by Thales Pereira on 9/6/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#pragma mark - iPhone model detection macros

#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 568.0) && ((IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale) || !IS_OS_8_OR_LATER))
#define IS_STANDARD_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0  && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale)
#define IS_ZOOMED_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale)
#define IS_STANDARD_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_ZOOMED_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale < [UIScreen mainScreen].scale)

typedef enum {
    kFriendNoRelation = 0,
    kFriendBangRequestSent = 1,
    kFriendBangRelation = 2,
    kFriendHookRequestSent = 3,
    kFriendHookRelation = 4,
} kFriendRelationIndex;

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

extern NSString *const kRequestTypeBang;
extern NSString *const kRequestTypeHook;

#pragma mark - Facebook Attributes

extern NSString *const kFacebookMaleString;
extern NSString *const kFacebookFemaleString;

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