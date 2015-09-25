//
//  UIView+LoadingScreen.m
//  Bangarang
//
//  Created by Thales Pereira on 9/7/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "UIView+LoadingScreen.h"

#import "LoadingViewController.h"

@implementation UIView (LoadingScreen)

- (void)showLoading {
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LoadingScreen" owner:self options:nil];
    
    LoadingViewController *mainView = [subviewArray objectAtIndex:0];
    
    mainView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self addSubview:mainView];
}

- (void)hideLoading {
    NSArray *subviews = self.subviews;
    
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:[LoadingViewController class]]) {
            [aView removeFromSuperview];
        }
    }
}

@end
