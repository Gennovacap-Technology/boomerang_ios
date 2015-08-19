//
//  NRPickerField.h
//
//  Created by Nielson Rolim on 9/4/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRPickerField : UITextField <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

//Categories Picker View Keyboard
@property (strong, nonatomic) UIPickerView* pickerView;

//Categories for the Picker View (Should be replaced in the class that's using MLPickerField)
@property (strong, nonatomic) NSDictionary* options;

//Default option value
@property (nonatomic) NSString* defaultOptionValue;

//Default option index
@property (nonatomic, readonly) NSInteger defaultOptionIndex;

//Selected option key
@property (nonatomic) NSString* selectedKey;

//Selected option value
@property (nonatomic) NSString* selectedValue;




@end
