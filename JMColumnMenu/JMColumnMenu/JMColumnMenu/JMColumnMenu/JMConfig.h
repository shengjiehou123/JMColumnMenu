//
//  JMConfig.h
//  JMCollectionView
//
//  Created by 刘俊敏 on 2017/12/7.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JMConfig : NSObject
#define kSCRATIO(x)   ceil(((x) * ([UIScreen mainScreen].bounds.size.width / 375)))
#define IS_IPHONE_X [[UIApplication sharedApplication] statusBarFrame].size.height>20

#define kNavHeight (IS_IPHONE_X ? 88 : 64)
#define kStatusBarHeight (IS_IPHONE_X ? 44 : 20)

#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

//16进制颜色转换
+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color Alpha:(CGFloat)alpha;


@end
