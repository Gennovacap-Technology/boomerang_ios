//
//  RequestsViewController.m
//  Bangarang
//
//  Created by Thales Pereira on 9/16/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "RequestsViewController.h"

#import <UIView+Rounded.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "FriendTableViewCell.h"

@interface RequestsViewController () {
    NSMutableArray *requests;
}

@end

@implementation RequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [requests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendsListFriendCell];
    
    if (cell == nil) {
        cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFriendsListFriendCell];
    }
    
    PFUser *friend = [friendsManager getFriendOfCurrentGenderAtIndex:indexPath.row - 1];
    
    cell.name.text = [NSString stringWithFormat:@"%@ %@", friend[kUserFirstNameKey], friend[kUserLastNameKey]];
    
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:friend[kUserPhotoURLKey]]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   
                                   // Rounded UIImageView
                                   [cell.avatarImage circleWithBorderWidth:0 andBorderColor:[UIColor whiteColor]];
                               }];
    
    cell.delegate = self;
    cell.cellIndex = indexPath.row - 1;
    
    [self loadButton:cell.bombButton forFriend:friend];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
