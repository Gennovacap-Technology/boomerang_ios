//
//  NRDateField.h
//
//  Created by Nielson Rolim on 8/27/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
A custom TextField to input done button in NumberPad and use mask for date
*/

@interface NRDateField : UITextField <UITextFieldDelegate>

//Categories Picker View Keyboard
@property (strong, nonatomic) UIDatePicker* datePicker;

@end
