//
//  ViewController.m
//  XXNumberButton
//
//  Created by Mac on 2018/8/28.
//  Copyright © 2018年 xiangxx. All rights reserved.
//

#import "ViewController.h"
#import "XXNumberButton.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet XXNumberButton *numberButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initShow];
}

- (void)initShow{
    
    self.numberButton.inputFieldColor = [UIColor redColor];
    self.numberButton.increaseTitle = @"加";
    self.numberButton.decreaseTitle = @"减";
    self.numberButton.editing = NO;
    self.numberButton.decreaseHide = NO;
    self.numberButton.blockCurrentNumber = ^(NSString *currentNumber) {
        NSLog(@"%@",currentNumber);
    };
    
    XXNumberButton *number = [[XXNumberButton alloc] initWithFrame:CGRectMake(50, 300, 200, 40)];
    number.increaseTitle = @"+";
    number.decreaseTitle = @"-";
    number.maxValue = 10;
    number.minValue = 2;
    number.editing = YES;
    number.decreaseHide = YES;
    [self.view addSubview:number];
    
    number.blockCurrentNumber = ^(NSString *currentNumber) {
        NSLog(@"%@",currentNumber);
    };
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
