//
//  LoginViewController.m
//  Bangarang
//
//  Created by Nielson Rolim on 8/24/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

#import "UIView+LoadingScreen.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Perform segue if user is already logged
    if ([PFUser currentUser]) {
        [self loginSuccessfull];
    }
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    //[self.view showProgressHUD];
    [self.view showLoading];
    
    [User facebookLoginWithCompletion:^(id sender, BOOL success, NSError *error, id result) {
        if (success) {
            //[self.view hideProgressHUD];
            [self.view hideLoading];
            
            [self loginSuccessfull];
        } else {
            //[self.view hideProgressHUD];
            [self.view hideLoading];
            
            NSLog(@"Error trying to log in with Facebook");
        }
    }];
}

- (void)loginSuccessfull {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Booms" bundle:nil];
    UIViewController *scene = [storyboard instantiateInitialViewController];
    
    [self presentViewController:scene animated:YES completion:nil];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
