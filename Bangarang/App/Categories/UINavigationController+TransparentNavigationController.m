//
//  UINavigationController+TransparentNavigationController.m
//  Bangarang
//
//  Created by Thales Pereira on 9/16/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "UINavigationController+TransparentNavigationController.h"

@implementation UINavigationController (TransparentNavigationController)

- (void)presentTransparentNavigationBar
{
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)hideTransparentNavigationBar
{
    [self.navigationBar setBackgroundImage:[[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UINavigationBar appearance] shadowImage]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

@end
