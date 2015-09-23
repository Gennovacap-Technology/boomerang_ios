//
//  UIView+MyMBProgressHUD_Additions.m
//  Pods
//
//  Created by Vincil Bishop on 4/16/14.
//
//

#import "UIView+MyMBProgressHUD_Additions.h"

@implementation UIView (MyMBProgressHUD_Additions)

- (void) showProgressHUD
{
    [self showProgressHUDWithMessage:@"Loading..."];
}

- (void) showProgressHUDWithMessage:(NSString*)message
{
    [self showProgressHUDWithMessage:message type:MBProgressHUDModeIndeterminate];
}

- (void) showProgressHUDWithMessage:(NSString*)message type:(MBProgressHUDMode)mode
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
    progressHUD.mode = mode;
    progressHUD.labelText = message;
}

- (void) hideProgressHUD
{
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}

@end