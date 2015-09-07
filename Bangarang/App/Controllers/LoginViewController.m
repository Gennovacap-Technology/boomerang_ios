//
//  LoginViewController.m
//  Bangarang
//
//  Created by Nielson Rolim on 8/24/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Perform segue if user is already logged
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"loginSuccessful" sender:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    [self.view showProgressHUD];
    [User facebookLoginWithCompletion:^(id sender, BOOL success, NSError *error, id result) {
        //
        if (success) {
            [self.view hideProgressHUD];
            [self performSegueWithIdentifier:@"loginSuccessful" sender:self];
        } else {
            [self.view hideProgressHUD];
            NSLog(@"Error trying to log in with Facebook");
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
