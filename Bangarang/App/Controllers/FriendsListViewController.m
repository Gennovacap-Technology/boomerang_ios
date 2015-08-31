//
//  FriendsListViewController.m
//  Bangarang
//
//  Created by Thales Pereira on 8/27/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "FriendsListViewController.h"

#import "FriendTableViewCell.h"
#import "GenderTableViewCell.h"

#import "SVSegmentedControl.h"

@implementation FriendsListViewController
{
    NSArray *tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize table data
    tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
    //self.tableView.estimatedRowHeight = 130.0;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *genderCellIdentifier = @"genderCell";
    static NSString *friendCellIdentifier = @"friendCell";
        
    if (indexPath.row == 0) {
        GenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:genderCellIdentifier];
        
        return cell;
    } else {
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellIdentifier];
        
        if (cell == nil) {
            cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendCellIdentifier];
        }
        
        cell.name.text = [tableData objectAtIndex:indexPath.row - 1];
        [cell.bombImage setHighlighted:YES];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100.0;
    } else {
        return 93.0;
    }
}

@end
