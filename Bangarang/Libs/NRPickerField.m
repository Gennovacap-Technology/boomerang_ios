//
//  NRPickerField.m
//
//  Created by Nielson Rolim on 9/4/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "NRPickerField.h"

@interface NRPickerField ()

//Sorted options
@property (strong, nonatomic) NSMutableArray *sortedOptions;

@end

@implementation NRPickerField

@synthesize options = _options;
@synthesize defaultOptionIndex = _defaultOptionIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.inputView = self.pickerView;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        self.inputView = self.pickerView;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.inputView = self.pickerView;
    }
    return self;
}

//- (NSDictionary*) options {
//    if (!_options) {
//        _options = @{@"Option #1": @"1",@"Option #2": @"2", @"Option #3": @"3",@"Option #4": @"4"};
//    }
//    return _options;
//}

- (void) setOptions:(NSDictionary *)options {
    NSMutableDictionary* tempDict = [NSMutableDictionary new];
    [tempDict setObject:@"" forKey:@"-"];
    for (NSString* key in options.allKeys) {
        NSString* value = [options objectForKey:key];
        [tempDict setObject:key forKey:value];
    }
    _options = (NSDictionary*)tempDict;
}

- (NSMutableArray*) sortedOptions {
    _sortedOptions = [NSMutableArray arrayWithArray:self.options.allKeys];
    [_sortedOptions sortUsingSelector:@selector(localizedStandardCompare:)];
    return _sortedOptions;
}

- (UIPickerView*) pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}


- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if (self.selectedValue == nil) {
        NSString* value;
        int i;
        for (i = 0; i < self.sortedOptions.count; i++) {
            value = self.sortedOptions[i];
            if ([value isEqualToString:self.defaultOptionValue]) {
                _defaultOptionIndex = i;
                break;
            } else {
                _defaultOptionIndex = 0;
            }
        }
        self.text = self.sortedOptions[self.defaultOptionIndex];
        [self.pickerView selectRow:self.defaultOptionIndex inComponent:0 animated:NO];
    }
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.options.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.sortedOptions[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
//    self.selectedValue = self.options.allValues[row];
//    self.selectedKey = self.options.allKeys[row];
    
    self.selectedKey = [self.options objectForKey:self.sortedOptions[row]];
    self.selectedValue = self.sortedOptions[row];
    
    self.text = self.selectedValue;
}



@end
