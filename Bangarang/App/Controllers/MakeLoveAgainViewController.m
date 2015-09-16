//
//  MakeLoveAgainViewController.m
//  Bangarang
//
//  Created by Thales Pereira on 9/16/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "MakeLoveAgainViewController.h"

#import "UIView+WaitingScreen.h"

#import "ParseUtils.h"

@interface MakeLoveAgainViewController ()

@end

@implementation MakeLoveAgainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [ParseUtils request:kRequestTypeHook ToFriend:_friend];
    
    [_friendsManager addFriendToHookRequestsSent:_friend];
    
    RequestManager *requestManager = [[RequestManager alloc] init];
    [requestManager createRequest:[_friend objectId]];
    
    [self.view showWaitingFor:_friend[kUserFirstNameKey]
            andHideAfterDelay:kDefaultWaitingViewHideInterval onFinish:^{
                [self dismissViewControllerAnimated:NO completion:nil];
            }];
}

- (IBAction)buttonNo:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)buttonBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
