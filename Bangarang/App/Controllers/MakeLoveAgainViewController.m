//
//  MakeLoveAgainViewController.m
//  Bangarang
//
//  Created by Thales Pereira on 9/16/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "MakeLoveAgainViewController.h"

#import "UIView+WaitingScreen.h"

#import "RequestManager.h"
#import "FriendsManager.h"

#import "ParseUtils.h"

@interface MakeLoveAgainViewController () {
    FriendsManager *friendsManager;
}

@end

@implementation MakeLoveAgainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    friendsManager = [FriendsManager sharedManager];
    
    [_makeLoveAgainView.layer setCornerRadius:5.0f];
    
    _friendName.numberOfLines = 1;
    _friendName.adjustsFontSizeToFitWidth = YES;
    
    _friendNameBack.numberOfLines = 1;
    _friendNameBack.adjustsFontSizeToFitWidth = YES;
    
    _friendName.text = _friend[kUserFirstNameKey];
    _friendNameBack.text = _friend[kUserFirstNameKey];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
}

- (IBAction)buttonYes:(id)sender {
    RequestManager *requestManager = [[RequestManager alloc] init];
    
    [ParseUtils request:kRequestTypeHook toFriend:_friend onSuccess:^{
        [friendsManager addFriendToHookRequestsSent:_friend];
        
        [requestManager createRequest:[_friend objectId]];
        
        [self.view showWaitingFor:_friend[kUserFirstNameKey]
                andHideAfterDelay:kDefaultWaitingViewHideInterval onFinish:^{
                    [self dismissViewControllerAnimated:NO completion:nil];
                }];
    } onRequestAlreadyReceived:^{
        [ParseUtils confirmRequest:kRequestTypeHook ofFriend:_friend onSuccess:^{
            [friendsManager removeFriendFromHookRequestsReceived:_friend];
            [friendsManager removeFriendFromBangs:_friend];
            
            [friendsManager addFriendToHooks:_friend];
            
            [requestManager createRequest:[_friend objectId]];
            
            [self dismissViewControllerAnimated:NO completion:nil];
        } onRequestNotFound:^{
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }];
}

- (IBAction)buttonNo:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)buttonBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
