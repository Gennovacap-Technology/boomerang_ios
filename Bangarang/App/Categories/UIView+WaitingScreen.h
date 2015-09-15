//
//  UIView+WaitingScreen.h
//  Bangarang
//
//  Created by Thales Pereira on 9/15/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_WaitingScreen)

- (void)showWaitingWithName:(NSString *)name;
- (void)hideLoading;

@end
