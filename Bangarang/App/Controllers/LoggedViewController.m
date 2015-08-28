//
//  LoggedViewController.m
//  Bangarang
//
//  Created by Nielson Rolim on 8/24/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "LoggedViewController.h"
#import "User.h"

@interface LoggedViewController ()

@property (weak, nonatomic) IBOutlet UILabel *greetingsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;

@end

@implementation LoggedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    User* currentUser = [User currentUser];
    
    self.greetingsLabel.text = [NSString stringWithFormat:@"Hello, %@!", currentUser.firstName];
    [self.userPhoto setImageWithURL:[NSURL URLWithString:currentUser.photoURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(UIButton *)sender {
    [User logout];
    [self dismissViewControllerAnimated:YES completion:nil];
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
