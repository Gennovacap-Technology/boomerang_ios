//
//  UIColor+Helper.h
//

#import <UIKit/UIKit.h>

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface UIColor (Helper)

@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;


- (BOOL)canProvideRGBComponents;
- (NSString *)toHexString;

+ (UIColor *)colorWithHexString:(NSString *)hexToConvert;
+ (UIColor *)colorWithHexString:(NSString *)hexToConvert alpha:(CGFloat)opacity;
+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)opacity;

+ (UIColor *)colorWithRGBA:(NSUInteger)color;
+ (UIColor *) colorRgbWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha;

@end
