//
//  GenderTableViewCell.h
//  Bangarang
//
//  Created by Thales Pereira on 8/30/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GenderTabDelegate

- (void)dudesButtonPressed;
- (void)ladiesButtonPressed;

@end

@interface GenderTableViewCell : UITableViewCell

@property (nonatomic, assign) id  delegate;

@property (weak, nonatomic) IBOutlet UIButton *dudesButton;
@property (weak, nonatomic) IBOutlet UIButton *ladiesButton;

- (IBAction)dudesButtonAction:(id)sender;
- (IBAction)ladiesButtonAction:(id)sender;

@end
