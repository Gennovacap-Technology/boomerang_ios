//
//  LoginViewController.m
//  Bangarang
//
//  Created by Nielson Rolim on 8/24/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "LoginViewController.h"
//#import "User.h"

#import "FacebookUtils.h"

#import "UIView+LoadingScreen.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Status Bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    [self.view showLoading];
    
    [FacebookUtils loginWithFacebookWithBlock:^{
        [self.view hideLoading];
        
        [self loginSuccessfull];
    } onError:^{
        [self.view hideLoading];
        
        NSLog(@"Error trying to log in with Facebook");
    }];
}

- (void)loginSuccessfull {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Booms" bundle:nil];
    UIViewController *scene = [storyboard instantiateInitialViewController];
    
    [self presentViewController:scene animated:YES completion:nil];
}

@end
