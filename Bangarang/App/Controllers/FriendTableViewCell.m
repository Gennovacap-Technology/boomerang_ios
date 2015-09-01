//
//  FriendTableViewCell.m
//  Bangarang
//
//  Created by Thales Pereira on 8/29/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

- (IBAction)bombAction:(id)sender {
    [_bombButton setImage:[UIImage imageNamed:@"BombPinkBackground"] forState:UIControlStateNormal];    
}

@end
