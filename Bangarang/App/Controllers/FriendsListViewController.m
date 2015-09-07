//
//  FriendsListViewController.m
//  Bangarang
//
//  Created by Thales Pereira on 8/27/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "FriendsListViewController.h"

#import <UIView+Rounded.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "Constants.h"

#import "FriendTableViewCell.h"
#import "GenderTableViewCell.h"

#import "PINCache.h"

@implementation FriendsListViewController {
    NSMutableArray *friends;
    NSMutableArray *friendsOfGender;
    NSString *currentGender;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentGender = kFacebookMaleString;
    
    friends = [[NSMutableArray alloc] init];
    friendsOfGender = [[NSMutableArray alloc] init];
    
    [self loadFriends];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friendsOfGender count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        GenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendsListGenderCell];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        return cell;
    } else {
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendsListFriendCell];
        
        if (cell == nil) {
            cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFriendsListFriendCell];
        }
        
        PFUser *friend = [friendsOfGender objectAtIndex:indexPath.row - 1];
        
        cell.name.text = [NSString stringWithFormat:@"%@ %@", friend[kUserFirstNameKey], friend[kUserLastNameKey]];
        
        [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:friend[kUserPhotoURLKey]]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

            // Rounded UIImageView
            [cell.avatarImage circleWithBorderWidth:0 andBorderColor:[UIColor whiteColor]];
        }];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 154.0;
    } else {
        return 93.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Parse Query

- (void)loadFriends {
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id" forKey:@"fields"];
    
    FBSDKGraphRequest *requestFriends = [[FBSDKGraphRequest alloc]
                                         initWithGraphPath:@"/me/friends"
                                         parameters:parameters
                                         HTTPMethod:@"GET"];
    
    [requestFriends startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                 id result,
                                                 NSError *error) {
        
        if (error) {
            // We must erase the cache
            //[[PINCache sharedCache] setObject: forKey:@"facebookFriends" block:nil];
        } else {
            NSArray *data = [result objectForKey:@"data"];
            NSMutableArray *facebookFriends = [[NSMutableArray alloc] initWithCapacity:[data count]];
            
            for (NSDictionary *friendData in data) {
                if (friendData[@"id"]) {
                    [facebookFriends addObject:friendData[@"id"]];
                }
            }
            
            //[[PINCache sharedCache] setObject:facebookFriends forKey:@"facebookFriends" block:nil];
            
           // NSArray *facebookFriendsFromCache = [[PINCache sharedCache] objectForKey:@"facebookFriends"];
            
            PFQuery *query = [PFUser query];
            //[query whereKey:@"facebookId" containedIn:facebookFriendsFromCache];
            [query whereKey:kUserFacebookIdKey containedIn:facebookFriends];
            query.cachePolicy = kPFCachePolicyNetworkElseCache;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (PFObject *object in objects) {
                        [friends addObject:object];
                    }
                    
                    friendsOfGender = [friends mutableCopy];
                    
                    // Show dudes by default
                    [self dudesButtonPressed];
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];
}

#pragma mark - GenderTabDelegate

- (void)dudesButtonPressed {
    [friendsOfGender removeAllObjects];
    
    for (PFUser *friend in friends) {
        if ([friend[kUserGenderKey] isEqual:kFacebookMaleString]) {
            [friendsOfGender addObject:friend];
        }
    }
    
    currentGender = kFacebookMaleString;
    
    [[self tableView] reloadData];
}

- (void)ladiesButtonPressed {
    [friendsOfGender removeAllObjects];
    
    for (PFUser *friend in friends) {
        if ([friend[kUserGenderKey] isEqual:kFacebookFemaleString]) {
            [friendsOfGender addObject:friend];
        }
    }
    
    currentGender = kFacebookFemaleString;
    
    [[self tableView] reloadData];
}

@end
