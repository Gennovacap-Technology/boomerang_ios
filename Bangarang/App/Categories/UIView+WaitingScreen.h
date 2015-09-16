//
//  UIView+WaitingScreen.h
//  Bangarang
//
//  Created by Thales Pereira on 9/15/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_WaitingScreen)

- (void)showWaitingFor:(NSString *)name andHideAfterDelay:(NSTimeInterval)delay;
- (void)showWaitingFor:(NSString *)name;
- (void)hideLoading;

@end
