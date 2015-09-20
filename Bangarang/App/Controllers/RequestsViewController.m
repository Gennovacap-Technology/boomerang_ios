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

#import "FriendsManager.h"
#import "ParseUtils.h"

#import "RequestFriendTableViewCell.h"

@interface RequestsViewController () {
    FriendsManager *friendsManager;
    
    NSMutableArray *requestsArray;
}

@end

@implementation RequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    friendsManager = [FriendsManager sharedManager];
    
    requestsArray = [[NSMutableArray alloc] init];
    
    [[ParseUtils requests] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *request in objects) {
                if ([friendsManager shouldNotifyCurrentUser:request]) {
                    [requestsArray addObject:request];
                    [friendsManager setRequestAsRead:request];
                }
            }
            
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
}

#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [requestsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendsListFriendCell];
    
    if (cell == nil) {
        cell = [[RequestFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFriendsListFriendCell];
    }
    
    PFObject *request = [requestsArray objectAtIndex:indexPath.row];
    PFUser *friend;
    
    if ([[request[kRequestFromUser] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        friend = (PFUser *)[request[kRequestToUser] fetchIfNeeded];
    } else {
        friend = (PFUser *)[request[kRequestFromUser] fetchIfNeeded];
    }
    
    if ([request[kRequestType] isEqualToString:kRequestTypeBang]) {
        cell.status.text = @"Accepted the bang request";
    } else if([request[kRequestType] isEqualToString:kRequestTypeHook]) {
        if ([[request[kRequestFromUser] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            cell.status.text = @"Accepted make love again";
        } else {
            cell.status.text = @"Wants to make love again";
        }
    }
    
    cell.name.text = [NSString stringWithFormat:@"%@ %@", friend[kUserFirstNameKey], friend[kUserLastNameKey]];
    
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:friend[kUserPhotoURLKey]]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   
                                   // Rounded UIImageView
                                   [cell.avatarImage circleWithBorderWidth:0 andBorderColor:[UIColor whiteColor]];
                               }];
    
    return cell;
}

@end
