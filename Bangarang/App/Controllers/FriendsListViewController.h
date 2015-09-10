//
//  FriendsListViewController.h
//  Bangarang
//
//  Created by Thales Pereira on 8/27/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GenderTableViewCell.h"

@interface FriendsListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, GenderCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)logoutButtonPressed:(id)sender;

@end
