//
//  ViewController.m
//  Bangarang
//
//  Created by Nielson Rolim on 8/19/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "ViewController.h"
#import "TestObject.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "User.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // Parse - Using Raw PFObject
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];

    // Parse - Using ParseModel
//    TestObject* testObject = [TestObject parseModel];
//    testObject.foo = @"this is a test";
//    [testObject.parseObject saveInBackground];
    
    // Parse - Listing all test objects
//    NSArray* tests = [TestObject findAll];
//    for (TestObject* testObject in tests) {
//        NSLog(@"foo: %@", testObject.foo);
//    }
    
    // Facebook Login test
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
    
    NSLog(@"username: %@", [User currentUser].username);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
