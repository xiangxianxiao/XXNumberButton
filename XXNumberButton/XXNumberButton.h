//
//  XXNumberButton.h
//
//  Created by Mac on 2018/8/28.
//  Copyright © 2018年 xiangxx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockCurrentNumber)(NSString *currentNumber);

@interface XXNumberButton : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, copy) BlockCurrentNumber blockCurrentNumber;

/** 加按钮背景图片 */
@property (nonatomic, strong ) IBInspectable UIImage *increaseImage;
/** 减按钮背景图片 */
@property (nonatomic, strong ) IBInspectable UIImage *decreaseImage;
/** 加按钮标题 */
@property (nonatomic, copy   ) IBInspectable NSString *increaseTitle;
/** 减按钮标题 */
@property (nonatomic, copy   ) IBInspectable NSString *decreaseTitle;



/** 加减按钮的字体大小 */
@property (nonatomic, assign ) IBInspectable CGFloat buttonTitleFont;

/** 输入框中的字体大小 */
@property (nonatomic, assign ) IBInspectable CGFloat inputFieldFont;

/** 输入框中的字体颜色 */
@property (nonatomic, strong) IBInspectable UIColor *inputFieldColor;



/** 最小值, default is 0 */
@property (nonatomic, assign ) IBInspectable CGFloat minValue;
/** 最大值 */
@property (nonatomic, assign ) CGFloat maxValue;
/** 递增步长，默认步长为1 */
@property (nonatomic, assign ) CGFloat stepValue;




/** 为YES时,初始化时减号按钮隐藏(饿了么/百度外卖/美团外卖按钮模式), default is NO*/
@property (nonatomic, assign ) IBInspectable BOOL decreaseHide;

/** 是否可以使用键盘输入, default is YES*/
@property (nonatomic, assign, getter=isEditing) IBInspectable BOOL editing;


@end

#pragma mark - NSString分类
@interface NSString (XXNumberButton)
/**
 字符串 nil, @"", @"  ", @"\n" Returns NO;
 其他 Returns YES.
 */
- (BOOL)isNotBlank;
@end

