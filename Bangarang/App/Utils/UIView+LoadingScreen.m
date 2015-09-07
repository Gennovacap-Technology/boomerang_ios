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
    
    NSInteger randomNumber = [self randomNumberBetween:1 maxNumber:2];
    NSString *backgroundImageName = [NSString stringWithFormat:@"LoadingBackground-%ld", (long)randomNumber];
    
    mainView.background.image = [UIImage imageNamed:backgroundImageName];
    
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

- (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random_uniform(max - min + 1);
}

@end
