@import UIKit;

// Note: For some reason doing this class in Swift wasn't exposing the methods in Objective-C.
@interface Spacing : NSObject

+ (CGFloat)verySmallSpacing;
+ (CGFloat)smallSpacing;
+ (CGFloat)mediumSpacing;
+ (CGFloat)mediumLargeSpacing;
+ (CGFloat)mediumPlusSpacing;
+ (CGFloat)largeSpacing;
+ (CGFloat)veryLargeSpacing;

+ (CGFloat)spacingXXS;
+ (CGFloat)spacingXS;
+ (CGFloat)spacingS;
+ (CGFloat)spacingM;
+ (CGFloat)spacingL;
+ (CGFloat)spacingXL;
+ (CGFloat)spacingXXL;

@end

