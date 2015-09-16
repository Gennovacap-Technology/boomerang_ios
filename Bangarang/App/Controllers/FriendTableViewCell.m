    //
//  FriendTableViewCell.m
//  Bangarang
//
//  Created by Thales Pereira on 8/29/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

@synthesize delegate;

- (IBAction)bombAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestButtonPressed:fromSender:)]) {
        [self.delegate requestButtonPressed:_cellIndex fromSender:sender];
    }
}

@end
