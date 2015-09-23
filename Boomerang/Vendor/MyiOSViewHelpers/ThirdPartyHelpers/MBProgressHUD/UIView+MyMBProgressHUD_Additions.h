//
//  UIView+MyMBProgressHUD_Additions.h
//  Pods
//
//  Created by Vincil Bishop on 4/16/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (MyMBProgressHUD_Additions)

- (void) showProgressHUD;
- (void) showProgressHUDWithMessage:(NSString*)message;
- (void) showProgressHUDWithMessage:(NSString*)message type:(MBProgressHUDMode)mode;
- (void) hideProgressHUD;
@end