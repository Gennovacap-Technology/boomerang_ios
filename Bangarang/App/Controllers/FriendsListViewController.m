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

#import "FriendTableViewCell.h"
#import "GenderTableViewCell.h"

#import "ChatViewController.h"

#import "ParseUtils.h"

#import "UIView+WaitingScreen.h"

@implementation FriendsListViewController {
    NSMutableArray *friends;
    NSMutableArray *friendsOfGender;
    
    NSMutableArray *bangRequestsSent;
    NSMutableArray *hookRequestsSent;
    
    NSMutableArray *bangRequestsReceived;
    NSMutableArray *hookRequestsReceived;
    
    NSMutableArray *bangs;
    NSMutableArray *hooks;
    
    NSString *currentGender;
    NSInteger selectedRow;
    
    RequestManager *requestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentGender = kFacebookMaleString;
    
    friends = [[NSMutableArray alloc] init];
    friendsOfGender = [[NSMutableArray alloc] init];

    bangRequestsSent = [[NSMutableArray alloc] init];
    hookRequestsSent = [[NSMutableArray alloc] init];

    bangRequestsReceived = [[NSMutableArray alloc] init];
    hookRequestsReceived = [[NSMutableArray alloc] init];
    
    bangs = [[NSMutableArray alloc] init];
    hooks = [[NSMutableArray alloc] init];
    
    UIImage* logoImage = [UIImage imageNamed:@"Browse"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    requestManager = [[RequestManager alloc] init];
    requestManager.delegate = self;
    [requestManager receivedRequestObserver];
    
    [self updateRequestsBarButtomItem:0];
    
    [self loadRequests];
    [self loadRelations];
    [self loadFriends];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [requestManager destroy];
}

- (void)receiveRequest {
    NSLog(@"Updating Requests");
    [self loadRequests];
}

- (UIButton *)requestsButton:(NSInteger)requests {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (IS_STANDARD_IPHONE_6_PLUS) {
        button.frame = CGRectMake(0, 0, 50, 50);
        button.layer.cornerRadius = 25.0;
    } else {
        button.frame = CGRectMake(0, 0, 30, 30);
        button.layer.cornerRadius = 15.0;
    }
    
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [button setBackgroundColor:[UIColor colorWithRed:1.000 green:0.000 blue:0.506 alpha:1.000]];
    [button setTitle:[NSString stringWithFormat:@"%ld", (long)requests] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(openRequests) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIButton *)bombButton {
    UIImage *image = [UIImage imageNamed:@"BombBlack"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (IS_STANDARD_IPHONE_6_PLUS) {
        button.frame = CGRectMake(0, 0, 50, 50);
    } else {
        button.frame = CGRectMake(0, 0, 30, 30);
    }
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(openRequests) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)openRequests {
    NSLog(@"asd");
}

- (void)updateRequestsBarButtomItem:(NSInteger)requests {
    UIButton *bombButton = [self bombButton];
    UIBarButtonItem *barButtonItemBomb = [[UIBarButtonItem alloc] initWithCustomView:bombButton];
    
    if (requests > 0) {
        UIButton *requestsButton = [self requestsButton:requests];
        UIBarButtonItem *barButtonItemRequests = [[UIBarButtonItem alloc] initWithCustomView:requestsButton];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barButtonItemBomb, barButtonItemRequests, nil];
    } else {
        self.navigationItem.rightBarButtonItem = barButtonItemBomb;
    }
}

#pragma mark - TableView Delegate Methods

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
        
        cell.delegate = self;
        cell.cellIndex = indexPath.row - 1;
        
        [self loadButton:cell.bombButton forFriend:friend];
        
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
    selectedRow = indexPath.row - 1;
    
    PFUser *friend = [friendsOfGender objectAtIndex:selectedRow];
    
    //[self performSegueWithIdentifier:@"chatSegue" sender:self];
    
    [self.view showWaitingFor:friend[kUserFirstNameKey] andHideAfterDelay:kWaitingViewDefaultHideInterval];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - View Helpers

- (void)loadButton:(UIButton *)button forFriend:(PFUser *)friend {
    if ([self array:bangRequestsSent containsPFObjectById:friend]) {
        [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageBangRequestPending]
                forState:UIControlStateNormal];
        
        [button setTag:kFriendBangRequestSent];
    } else if ([self array:hookRequestsSent containsPFObjectById:friend]) {
        [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageHookRequestPending]
                forState:UIControlStateNormal];
        
        [button setTag:kFriendHookRequestSent];
    } else if ([self array:bangs containsPFObjectById:friend]) {
        [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageBangList]
                forState:UIControlStateNormal];
        
        [button setTag:kFriendBangRelation];
    } else if ([self array:hooks containsPFObjectById:friend]) {
        [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageHookList]
                forState:UIControlStateNormal];
        
        [button setTag:kFriendHookRelation];
    } else {
        [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageInitialState]
                forState:UIControlStateNormal];
        
        [button setTag:kFriendNoRelation];
    }
}

- (BOOL)array:(NSArray *)array containsPFObjectById:(PFObject *)object {
    for (PFObject *arrayObject in array){
        if ([[arrayObject objectId] isEqual:[object objectId]]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)removeFriend:(PFUser *)friend FromArray:(NSMutableArray *)array {
    for (int i = 0; i < [array count]; i++) {
        if ([[array[i] objectId] isEqual:[friend objectId]]) {
            [array removeObjectAtIndex:i];
        }
    }
}

#pragma mark - Parse Query

- (void)loadRelations {
    PFUser *currentUser = [PFUser currentUser];
    
    PFRelation *relation = [currentUser relationForKey:kUserBangsKey];
    PFQuery *query = [relation query];
    
    [bangs addObjectsFromArray:[query findObjects]];
    
    relation = [currentUser relationForKey:kUserHooksKey];
    query = [relation query];
    
    [hooks addObjectsFromArray:[query findObjects]];
}

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
            NSLog(@"Facebook Request Error");
        } else {
            NSArray *data = [result objectForKey:@"data"];
            NSMutableArray *facebookFriends = [[NSMutableArray alloc] initWithCapacity:[data count]];
            
            for (NSDictionary *friendData in data) {
                if (friendData[@"id"]) {
                    [facebookFriends addObject:friendData[@"id"]];
                }
            }
            
            PFQuery *query = [PFUser query];
            [query whereKey:kUserFacebookIdKey containedIn:facebookFriends];
            //query.cachePolicy = kPFCachePolicyNetworkElseCache;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (PFObject *object in objects) {
                        [friends addObject:object];
                    }
                    
                    if (currentGender == kFacebookMaleString) {
                        [self dudesButtonPressed];
                    } else {
                        [self ladiesButtonPressed];
                    }
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];
}

- (void)loadRequests {
    [[ParseUtils requests] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [bangRequestsSent removeAllObjects];
        [hookRequestsSent removeAllObjects];
        [bangRequestsReceived removeAllObjects];
        [hookRequestsReceived removeAllObjects];
        
        NSString *currentUserId = [[PFUser currentUser] objectId];
        NSInteger requestsReceived = 0;
        
        if (!error) {
            for (PFObject *request in objects) {
                NSString *fromUserId = [request[kRequestFromUser] objectId];
                
                // Requests sent
                if ([currentUserId isEqualToString:fromUserId]) {
                    PFUser *friend = request[kRequestToUser];
                    
                    if ([request[kRequestType] isEqualToString:kRequestTypeBang]) {
                        
                        if ([request[kRequestAccepted] boolValue]) {
                            [ParseUtils makeRelation:kRequestTypeBang withFriend:friend];
                            
                            [bangs addObject:friend];
                            
                            [request delete];
                        } else {
                            [bangRequestsSent addObject:friend];
                        }
                        
                    } else if([request[kRequestType] isEqualToString:kRequestTypeHook]) {
                        
                        if ([request[kRequestAccepted] boolValue]) {
                            [ParseUtils makeRelation:kRequestTypeHook withFriend:friend];

                            [self removeFriend:friend FromArray:bangs];
                            [hooks addObject:friend];
                            
                            [request delete];
                        } else {
                            [hookRequestsSent addObject:friend];
                        }
                        
                    }
                    
                // Request received
                } else {
                    if ([request[kRequestType] isEqualToString:kRequestTypeBang]) {
                        PFUser *friend = request[kRequestFromUser];
                        [bangRequestsReceived addObject:friend];
                    } else if([request[kRequestType] isEqualToString:kRequestTypeHook]) {
                        PFUser *friend = request[kRequestFromUser];
                        [hookRequestsReceived addObject:friend];
                    }
                    
                    // Count unconfirmed requests
                    if (![request[kRequestAccepted] boolValue]) {
                        requestsReceived++;
                    }
                }
            }
            
            [[self tableView] reloadData];
            [self updateRequestsBarButtomItem:requestsReceived];
        } else {
            NSLog(@"Failed load requests");
        }
    }];
}

#pragma mark - FriendCell Delegate

- (void)requestButtonPressed:(NSInteger)cellIndex fromSender:(id)sender {
    PFUser *friend = [friendsOfGender objectAtIndex:cellIndex];
    
    UIButton *button = sender;
    
    // When your friend has sent a bang request
    if ([self array:bangRequestsReceived containsPFObjectById:friend]) {
        [ParseUtils confirmRequest:friend];
        [self removeFriend:friend FromArray:bangRequestsReceived];
        
        [bangs addObject:friend];
        
        [requestManager createRequest:[friend objectId]];
        
        [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageBangList]
                forState:UIControlStateNormal];
    
    // When your friend has sent a hook up request
    } else if ([self array:hookRequestsReceived containsPFObjectById:friend]) {
        [ParseUtils confirmRequest:friend];
        
        [self removeFriend:friend FromArray:bangs];
        [self removeFriend:friend FromArray:hookRequestsReceived];
        
        [hooks addObject:friend];
        
        [requestManager createRequest:[friend objectId]];
        
        [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageHookList]
                forState:UIControlStateNormal];
        
    // When you send a bang to a friend
    } else if (button.tag == kFriendNoRelation) {
        [ParseUtils request:kRequestTypeBang ToFriend:friend];
        [requestManager createRequest:[friend objectId]];
        [bangRequestsSent addObject:friend];
        
        [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageBangRequestPending]
                forState:UIControlStateNormal];
    
    // When you send a hook up to a friend
    } else if (button.tag == kFriendBangRelation) {
        [ParseUtils request:kRequestTypeHook ToFriend:friend];
        [requestManager createRequest:[friend objectId]];
        [hookRequestsSent addObject:friend];
        
        [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageHookRequestPending]
                forState:UIControlStateNormal];
    }
    
    [[self tableView] reloadData];
}

#pragma mark - GenderCell Delegate

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

#pragma mark - Navigation Bar Actions

- (IBAction)logoutButtonPressed:(id)sender {
    [PFUser logOut];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *scene = [storyboard instantiateInitialViewController];
    
    [self presentViewController:scene animated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {    
    if([[segue identifier] isEqualToString:@"chatSegue"]) {
        ChatViewController *destinationController = [segue destinationViewController];
        destinationController.friendUser = [friendsOfGender objectAtIndex:selectedRow];
    }
}

@end
