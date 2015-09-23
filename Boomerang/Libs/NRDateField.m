//
//  NRDateField.m
//
//  Created by Nielson Rolim on 8/27/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "NRDateField.h"

@interface NRDateField ()

@end

@implementation NRDateField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.inputView = self.datePicker;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        self.inputView = self.datePicker;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.inputView = self.datePicker;
    }
    return self;
}


- (UIDatePicker*) datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    return _datePicker;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.text isEqualToString:@""]) {
        [self updateTextField:nil];
    }
    
}

-(void)updateTextField:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.text = [dateFormatter stringFromDate:self.datePicker.date];
}


@end
