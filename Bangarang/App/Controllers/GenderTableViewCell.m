//
//  GenderTableViewCell.m
//  Bangarang
//
//  Created by Thales Pereira on 8/30/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "GenderTableViewCell.h"

@implementation GenderTableViewCell

- (IBAction)dudesButtonAction:(id)sender {

    [_dudesButton setImage:[UIImage imageNamed:@"DudesOn"] forState:UIControlStateNormal];
    [_ladiesButton setImage:[UIImage imageNamed:@"LadiesOff"] forState:UIControlStateNormal];

}

- (IBAction)ladiesButtonAction:(id)sender {

    [_dudesButton setImage:[UIImage imageNamed:@"DudesOff"] forState:UIControlStateNormal];
    [_ladiesButton setImage:[UIImage imageNamed:@"LadiesOn"] forState:UIControlStateNormal];
    
}

@end
