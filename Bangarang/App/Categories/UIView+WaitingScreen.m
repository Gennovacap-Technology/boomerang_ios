//
//  UIView+WaitingScreen.m
//  Bangarang
//
//  Created by Thales Pereira on 9/15/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "UIView+WaitingScreen.h"

#import "WaitingViewController.h"

@implementation UIView (WaitingScreen)

- (void)showWaitingWithName:(NSString *)name {
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Waiting" owner:self options:nil];
    
    WaitingViewController *mainView = [subviewArray objectAtIndex:0];
    
    mainView.name.numberOfLines = 1;
    mainView.name.adjustsFontSizeToFitWidth = YES;
    
    mainView.nameBack.numberOfLines = 1;
    mainView.nameBack.adjustsFontSizeToFitWidth = YES;
    
    mainView.name.text = name;
    mainView.nameBack.text = name;
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(hideLoading)];
    
    [mainView addGestureRecognizer:singleFingerTap];
    
    [self performSelector:@selector(hideLoading) withObject:nil afterDelay:3.0f];
    
    [self addSubview:mainView];
}

- (void)hideLoading {
    NSArray *subviews = self.subviews;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:[WaitingViewController class]]) {
            [aView removeFromSuperview];
        }
    }
}

@end
