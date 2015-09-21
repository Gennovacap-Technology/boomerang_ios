//
//  FriendsListViewController.m
//  Bangarang
//
//  Created by Thales Pereira on 8/27/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "FriendsListViewController.h"

#import <UIView+Rounded.h>
#import <SDWebImage/SDWebImageDownloader.h>

#import "FriendTableViewCell.h"
#import "GenderTableViewCell.h"

#import "ChatViewController.h"
#import "MakeLoveAgainViewController.h"

#import "ParseUtils.h"

#import "FriendsManager.h"

#import "UIView+LoadingScreen.h"
#import "UIView+WaitingScreen.h"

@implementation FriendsListViewController {
    NSInteger selectedRow;
    
    RequestManager *requestManager;
    FriendsManager *friendsManager;
    
    NSUInteger currentNumberOfRequests;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Status Bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // Navigation Bar
    UIImage* logoImage = [UIImage imageNamed:@"Browse"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    [self updateRequestsBarButtomItem:0];
    
    // Friends Manager
    friendsManager = [FriendsManager sharedManager];
    
    [self updateRequests];
    
    [friendsManager loadFriends:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self tableView] reloadData];
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        
    // Request Manager
    requestManager = [[RequestManager alloc] init];
    requestManager.delegate = self;
    [requestManager requestReceivedObserver];
    
    [[self tableView] reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [requestManager destroy];
}

- (void)updateRequests {
    [friendsManager loadRequests:^(NSUInteger requestsReceived){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self updateRequestsBarButtomItem:requestsReceived];
        });
    }];
}

#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[friendsManager getFriendsOfCurrentGender] count] + 1;
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
        
        PFUser *friend = [friendsManager getFriendOfCurrentGenderAtIndex:indexPath.row - 1];
        
        cell.name.text = [NSString stringWithFormat:@"%@ %@", friend[kUserFirstNameKey], friend[kUserLastNameKey]];
        
        NSString *profileUrl = [NSString stringWithFormat:kFacebookProfilePictureUrl, friend[kUserFacebookIdKey]];
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:profileUrl]
                                                            options:0
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
         }
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             if (image && finished)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     cell.avatarImage.image = [UIImage imageWithData:data];
                     [cell.avatarImage circleWithBorderWidth:0 andBorderColor:[UIColor whiteColor]];
                 });
             }
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        return;
    }
    
    selectedRow = indexPath.row - 1;
    
    PFUser *friend = [friendsManager getFriendOfCurrentGenderAtIndex:selectedRow];
    
    switch ([friendsManager friendRelation:friend]) {
        case kFriendHookRequestSent:
            [self.view showWaitingFor:friend[kUserFirstNameKey]
                    andHideAfterDelay:kDefaultWaitingViewHideInterval];
            break;
            
        case kFriendBangRequestSent:
            [self.view showWaitingFor:friend[kUserFirstNameKey]
                    andHideAfterDelay:kDefaultWaitingViewHideInterval];
            break;
            
        case kFriendHookRelation:
            [self performSegueWithIdentifier:@"chatSegue" sender:self];
            
            break;
            
        case kFriendBangRelation:
            [self performSegueWithIdentifier:@"makeLoveAgainSegue" sender:self];
            
            break;
            
        case kFriendNoRelation:
            
            break;
            
        default:
            break;
    }
}

# pragma mark - Request Manager Delegate

- (void)requestReceived {
    NSLog(@"Request received, updating Requests");
    
    [friendsManager loadRequests:^(NSUInteger requestsReceived) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self updateRequestsBarButtomItem:requestsReceived];
        });
        
        NSLog(@"Finished requests update");
    }];
}

#pragma mark - FriendCell Delegate

- (void)requestButtonPressed:(NSInteger)cellIndex fromSender:(id)sender {
    selectedRow = cellIndex;
    
    PFUser *friend = [friendsManager getFriendOfCurrentGenderAtIndex:cellIndex];
    kFriendRelationIndex friendRelation = [friendsManager friendRelation:friend];
    
    UIButton *button = sender;
    
    // When your friend has sent a hook up request
    if ([friendsManager receivedHookRequestFromFriend:friend]) {
        [self performSegueWithIdentifier:@"makeLoveAgainSegue" sender:self];
        
    // When your friend has sent a bang request
    } else if ([friendsManager receivedBangRequestFromFriend:friend]) {
        [self confirmBangRequestFromAFriend:friend withButton:button];
        
    // When you send a hook up to a friend
    } else if (friendRelation == kFriendBangRelation) {
        [self performSegueWithIdentifier:@"makeLoveAgainSegue" sender:self];
    
    // When you remove a bang request sent to a friend
    } else if (friendRelation == kFriendBangRequestSent) {
        [self removeBangRequestToAFriend:friend withButton:button];
    
    // When you already sent a hook request to a friend
    } else if (friendRelation == kFriendHookRequestSent) {
        [self.view showWaitingFor:friend[kUserFirstNameKey]
                andHideAfterDelay:kDefaultWaitingViewHideInterval];
        [self updateRequests];
    
    // When you send a bang to a friend
    } else if (friendRelation == kFriendNoRelation) {
        [self.view showWaitingFor:friend[kUserFirstNameKey]
                andHideAfterDelay:kDefaultWaitingViewHideInterval];
        
        [self sendBangRequestToAFriend:friend withButton:button];
    }
}

#pragma mark - Friend Relations Actions

- (void)sendBangRequestToAFriend:(PFUser *)friend withButton:(UIButton *)button {
    [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageBangRequestPending]
            forState:UIControlStateNormal];
    
    [friendsManager addFriendToBangRequestsSent:friend];
    
    [ParseUtils request:kRequestTypeBang toFriend:friend onSuccess:^{
        [requestManager createRequest:[friend objectId]];
    } onRequestAlreadySent:^{
        [friendsManager removeFriendFromBangRequestsSent:friend];
        
        [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageBangRequestPending]
                forState:UIControlStateNormal];
    } onRequestAlreadyReceived:^{
        [friendsManager removeFriendFromBangRequestsSent:friend];
        
        [self confirmBangRequestFromAFriend:friend withButton:button];
    }];
}

- (void)removeBangRequestToAFriend:(PFUser *)friend withButton:(UIButton *)button {
    [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageInitialState]
            forState:UIControlStateNormal];
    
    [friendsManager removeFriendFromBangRequestsSent:friend];
    
    [ParseUtils removeRequest:kRequestTypeBang toFriend:friend onSuccess:^{
        [requestManager createRequest:[friend objectId]];
    }];
}

- (void)confirmBangRequestFromAFriend:(PFUser *)friend withButton:(UIButton *)button {
    [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageBangList]
            forState:UIControlStateNormal];
    
    [ParseUtils confirmRequest:kRequestTypeBang ofFriend:friend onSuccess:^{
        [friendsManager removeFriendFromBangRequestsReceived:friend];
        
        [friendsManager addFriendToBangs:friend];
        
        [requestManager createRequest:[friend objectId]];
    } onRequestNotFound:^{
        [friendsManager removeFriendFromBangRequestsReceived:friend];
        
        [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageInitialState]
                forState:UIControlStateNormal];
    }];
}

#pragma mark - GenderCell Delegate

- (void)dudesButtonPressed {
    [friendsManager setCurrentGender:kFacebookMaleString];
    
    [[self tableView] reloadData];
}

- (void)ladiesButtonPressed {
    [friendsManager setCurrentGender:kFacebookFemaleString];
    
    [[self tableView] reloadData];
}

#pragma mark - View Helpers

- (void)loadButton:(UIButton *)button forFriend:(PFUser *)friend {
    switch ([friendsManager friendRelation:friend]) {
        case kFriendHookRequestSent:
            [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageHookRequestPending]
                    forState:UIControlStateNormal];
            break;
        
        case kFriendBangRequestSent:
            [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageBangRequestPending]
                    forState:UIControlStateNormal];
            break;
            
        case kFriendHookRelation:
            [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageHookList]
                    forState:UIControlStateNormal];
            break;
            
        case kFriendBangRelation:
            [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageBangList]
                    forState:UIControlStateNormal];
            break;
            
        case kFriendNoRelation:
            [button setImage:[UIImage imageNamed:kFriendsListRequestButtonImageInitialState]
                    forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

#pragma mark - Navigation Bar Requests Button

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

- (void)updateRequestsBarButtomItem:(NSInteger)requests {
    currentNumberOfRequests = requests;
    
    UIButton *bombButton = [self navigationBarRequestsButton];
    UIBarButtonItem *barButtonItemBomb = [[UIBarButtonItem alloc] initWithCustomView:bombButton];
    
    if (requests > 0) {
        UIButton *requestsButton = [self requestsButton:requests];
        UIBarButtonItem *barButtonItemRequests = [[UIBarButtonItem alloc] initWithCustomView:requestsButton];
        
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barButtonItemBomb, barButtonItemRequests, nil];
    } else {
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = barButtonItemBomb;
    }
}

- (UIButton *)navigationBarRequestsButton {
    UIImage *image = [UIImage imageNamed:@"ButtonBombBlack"];
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
    if (currentNumberOfRequests > 0) {
        [self performSegueWithIdentifier:@"requestsSegue" sender:self];
        [self updateRequestsBarButtomItem:0];
    }
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
        destinationController.friendUser = [friendsManager getFriendOfCurrentGenderAtIndex:selectedRow];
    } else if ([[segue identifier] isEqualToString:@"makeLoveAgainSegue"]) {
        MakeLoveAgainViewController *destinationController = [segue destinationViewController];
        destinationController.delegate = self;
        destinationController.friend = [friendsManager getFriendOfCurrentGenderAtIndex:selectedRow];
    }
}

@end
