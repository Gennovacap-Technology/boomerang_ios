//
//  MakeLoveAgainViewController.m
//  Bangarang
//
//  Created by Thales Pereira on 9/16/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "MakeLoveAgainViewController.h"

#import "UINavigationController+TransparentNavigationController.h"

#import "UIView+WaitingScreen.h"

#import "ParseUtils.h"

@interface MakeLoveAgainViewController ()

@end

@implementation MakeLoveAgainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_makeLoveAgainView.layer setCornerRadius:10.0f];
    
    self.navigationItem.title = _friend[kUserFirstNameKey];
        
    [self.navigationController.navigationBar
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIFont fontWithName:@"Wolf in the City" size:60], NSFontAttributeName,
                             [UIColor colorWithRed:1.000 green:0.000 blue:0.506 alpha:1.000], NSForegroundColorAttributeName, nil]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController hideTransparentNavigationBar];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonYes:(id)sender {
    [ParseUtils request:kRequestTypeHook ToFriend:_friend];
    
    [_friendsManager addFriendToHookRequestsSent:_friend];
    
    RequestManager *requestManager = [[RequestManager alloc] init];
    [requestManager createRequest:[_friend objectId]];
    
    [self.view showWaitingFor:_friend[kUserFirstNameKey]
            andHideAfterDelay:kDefaultWaitingViewHideInterval];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonNo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
