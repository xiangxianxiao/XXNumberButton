//
//  NumberButton.m
//  XXNumberButton
//
//  Created by Mac on 2018/8/28.
//  Copyright © 2018年 xiangxx. All rights reserved.
//

#import "XXNumberButton.h"
#define hr_weakify(var)   __weak typeof(var) weakSelf = var
#define hr_strongify(var) __strong typeof(var) strongSelf = var

@interface XXNumberButton()<UITextFieldDelegate>

@property (nonatomic, assign) CGFloat width;  // 控件自身的宽
@property (nonatomic, assign) CGFloat height; // 控件自身的高


// 减按钮
@property (nonatomic, strong) UIButton *decreaseBtn;

// 加按钮
@property (nonatomic, strong) UIButton *increaseBtn;

// 数量展开输入框
@property (nonatomic, strong) UITextField *textField;

@end

@implementation XXNumberButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        if(CGRectIsEmpty(frame)) {self.frame = CGRectMake(0, 0, 110, 30);};
    }
    return self;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _width =  self.frame.size.width;
    _height = self.frame.size.height;
    _textField.frame = CGRectMake(_height, 0, _width - 2*_height, _height);
    _increaseBtn.frame = CGRectMake(_width - _height, 0, _height, _height);
    
    if (_decreaseHide && _textField.text.floatValue < _minValue) {
        _decreaseBtn.frame = CGRectMake(_width-_height, 0, _height, _height);
    } else {
        _decreaseBtn.frame = CGRectMake(0, 0, _height, _height);
    }
}

/**
 初始化数据
 */
- (void)initData{
    
    self.buttonTitleFont = 17;
    self.inputFieldFont = 15;
    self.minValue = 1;
    self.maxValue = NSIntegerMax;
    self.stepValue = 1;
    
    self.increaseTitle = @"+";
    self.decreaseTitle = @"-";
    
    self.isBorder = YES;
    self.xxBorderColor = [UIColor lightGrayColor];
    self.xxBorderWidth = 0.5f;
    
    self.isRadius = YES;
    self.numberRadius = 0.0f;
    
}

// 初始化界面
- (void)initUI{
    
    _increaseBtn = [self createButton];
    _decreaseBtn = [self createButton];
    
    //数量展示/输入框
    _textField = [[UITextField alloc] init];
    _textField.delegate = self;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.font = [UIFont systemFontOfSize:_inputFieldFont];
    _textField.text = [NSString stringWithFormat:@"%.0f",_minValue];
    _textField.textColor = [UIColor grayColor];
    _textField.enabled = NO;
    
    [self addSubview:_increaseBtn];
    [self addSubview:_decreaseBtn];
    [self addSubview:_textField];
    
    [self initData];
}

// 设置加减 按钮的公共方法
- (UIButton *)createButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:_buttonTitleFont];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - 加减按钮点击响应
- (void)touchDown:(UIButton *)sender
{
    [_textField resignFirstResponder];
    
    if (sender == _increaseBtn) {
        [self increase];
    } else {
        [self decrease];
    }
}

// 加运算
- (void)increase{
    
    CGFloat number = [_textField.text floatValue] + self.stepValue;
    
    if (number <= _maxValue) {
        // 当按钮为"减号按钮隐藏模式",且输入框值==设定最小值,减号按钮展开
        if (_decreaseHide && number==_minValue) {
            
            hr_weakify(self);
            [UIView animateWithDuration:0.3f animations:^{
                weakSelf.decreaseBtn.alpha = 1;
                weakSelf.decreaseBtn.frame = CGRectMake(0, 0, weakSelf.height, weakSelf.height);
            } completion:^(BOOL finished) {
                weakSelf.textField.hidden = NO;
            }];
        }
        _textField.text = [NSString stringWithFormat:@"%.0f",number];
        
        if (self.blockCurrentNumber) {
            self.blockCurrentNumber([NSString stringWithFormat:@"%@",_textField.text]);
        }
        
    } else {
        
        if (self.blockCurrentNumber) {
            self.blockCurrentNumber([NSString stringWithFormat:@"数据已超过最大数量%.0f",_maxValue]);
        }
    }
}

// 减运算
- (void)decrease{
    
    CGFloat number = [_textField.text floatValue] - self.stepValue;
    
    if (number >= _minValue) {
        _textField.text = [NSString stringWithFormat:@"%.0f",number];
    } else {
        // 当按钮为"减号按钮隐藏模式",且输入框值 < 设定最小值,减号按钮隐藏
        if (_decreaseHide && number<_minValue) {
            _textField.hidden = YES;
            _textField.text = [NSString stringWithFormat:@"%.0f",_minValue-1];
            
            hr_weakify(self);
            [UIView animateWithDuration:0.3f animations:^{
                weakSelf.decreaseBtn.alpha = 0;
                weakSelf.decreaseBtn.frame = CGRectMake(weakSelf.width - weakSelf.height, 0, weakSelf.height, weakSelf.height);
            }];
            return;
        }else{
            
            if (self.blockCurrentNumber) {
                self.blockCurrentNumber([NSString stringWithFormat:@"数据不能小于最小值%.0f",_minValue]);
            }
            return;
        }
    }
    
    if (self.blockCurrentNumber) {
        self.blockCurrentNumber([NSString stringWithFormat:@"%@",_textField.text]);
    }
}

#pragma mark - 加减按钮的属性设置  为YES时,初始化时减号按钮隐藏
- (void)setDecreaseHide:(BOOL)decreaseHide
{
    // 当按钮为"减号按钮隐藏模式(饿了么/百度外卖/美团外卖按钮样式)"
    if (decreaseHide) {
        if (_textField.text.floatValue <= _minValue) {
            _textField.hidden = YES;
            _decreaseBtn.alpha = 0;
            
            _textField.text = [NSString stringWithFormat:@"%.0f",_minValue-1];
            _decreaseBtn.frame = CGRectMake(_width-_height, 0, _height, _height);
        }
        self.backgroundColor = [UIColor clearColor];
    } else {
        _decreaseBtn.frame = CGRectMake(0, 0, _height, _height);
    }
    _decreaseHide = decreaseHide;
}

#pragma mark set get 方法
- (void)setIncreaseImage:(UIImage *)increaseImage{
    _increaseImage = increaseImage;
    [_increaseBtn setBackgroundImage:increaseImage forState:UIControlStateNormal];
}

- (void)setDecreaseImage:(UIImage *)decreaseImage{
    _decreaseImage = decreaseImage;
    [_decreaseBtn setBackgroundImage:decreaseImage forState:UIControlStateNormal];
}

- (void)setIncreaseTitle:(NSString *)increaseTitle{
    _increaseTitle = increaseTitle;
    [_increaseBtn setTitle:increaseTitle forState:UIControlStateNormal];
}

- (void)setDecreaseTitle:(NSString *)decreaseTitle{
    _decreaseTitle = decreaseTitle;
    [_decreaseBtn setTitle:decreaseTitle forState:UIControlStateNormal];
}

- (void)setButtonTitleFont:(CGFloat)buttonTitleFont{
    
    _buttonTitleFont = buttonTitleFont;
    _increaseBtn.titleLabel.font = [UIFont systemFontOfSize:buttonTitleFont];
    _decreaseBtn.titleLabel.font = [UIFont systemFontOfSize:buttonTitleFont];
}

- (void)setInputFieldFont:(CGFloat)inputFieldFont{
    _inputFieldFont = inputFieldFont;
    _textField.font = [UIFont systemFontOfSize:inputFieldFont];
}

- (void)setInputFieldColor:(UIColor *)inputFieldColor{
    _inputFieldColor = inputFieldColor;
    _textField.textColor = inputFieldColor;
}

- (void)setEditing:(BOOL)editing{
    _editing = editing;
    _textField.enabled = editing;
}

- (void)setCurrentNumber:(CGFloat)currentNumber {
    _textField.text = [NSString stringWithFormat:@"%.f",currentNumber];
}

- (CGFloat)currentNumber {
    return _textField.text.floatValue;
}

- (void)setMinValue:(CGFloat)minValue{
    _minValue = minValue;
}

- (void)setMaxValue:(CGFloat)maxValue{
    _maxValue = maxValue;
}

- (void)setStepValue:(CGFloat)stepValue{
    _stepValue = stepValue;
}

#pragma mark TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self checkTextFieldNumberWithUpdate];
}

// 检查TextField中数字的合法性,并修正
- (void)checkTextFieldNumberWithUpdate
{
    NSString *minValueString = [NSString stringWithFormat:@"%.0f",_minValue];
    NSString *maxValueString = [NSString stringWithFormat:@"%.0f",_maxValue];
    
    if ([_textField.text isNotBlank] == NO || [_textField.text floatValue] < _minValue) {
        _textField.text = _decreaseHide ? [NSString stringWithFormat:@"%.0f",minValueString.floatValue-self.stepValue]:minValueString;
    }
    
    [_textField.text floatValue] > _maxValue ? _textField.text = maxValueString : nil;
    [_textField.text floatValue] < _minValue ? _textField.text = minValueString : nil;
    
    if (self.blockCurrentNumber) {
        self.blockCurrentNumber([NSString stringWithFormat:@"%@",_textField.text]);
    }
}


- (void)setIsBorder:(BOOL)isBorder{
    _isBorder = isBorder;
}

- (void)setXxBorderColor:(UIColor *)xxBorderColor{
    _xxBorderColor = xxBorderColor;
    if (self.isBorder) {
        self.layer.borderColor = xxBorderColor.CGColor;
        self.textField.layer.borderColor = xxBorderColor.CGColor;
    }
}

- (void)setXxBorderWidth:(CGFloat)xxBorderWidth{
    _xxBorderWidth = xxBorderWidth;
    if (self.isBorder) {
        self.layer.borderWidth =  xxBorderWidth;
        self.textField.layer.borderWidth = xxBorderWidth;
    }
}

- (void)setIsRadius:(BOOL)isRadius{
    _isRadius = isRadius;
}

- (void)setNumberRadius:(CGFloat)numberRadius{
    _numberRadius = numberRadius;
    if (self.isRadius == YES) {
        self.layer.cornerRadius = numberRadius;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
    }
}

@end


#pragma mark - NSString分类
@implementation NSString (XXNumberButton)
//判断 字符串 nil, @"", @"  ", @"\n" Returns NO;
- (BOOL)isNotBlank
{
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

@end
