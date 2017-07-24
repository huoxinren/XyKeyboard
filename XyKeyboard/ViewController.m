//
//  ViewController.m
//  XyKeyboard
//
//  Created by xyz on 2017/7/24.
//  Copyright © 2017年 xyz. All rights reserved.
//

#import "ViewController.h"

#import "XyNumberKeyboardView.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITextField *textFieldValues = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 200, 30)];
    [textFieldValues setBackgroundColor:[UIColor yellowColor]];
    textFieldValues.textColor = [UIColor redColor];
    textFieldValues.font = [UIFont systemFontOfSize:13.0f];
    [textFieldValues setPlaceholder:@"点击弹出键盘"];
    textFieldValues.delegate = self;
    [self.view addSubview:textFieldValues];
    
    XyNumberKeyboardView *customKeyboard = [[XyNumberKeyboardView alloc] initWithKeyboard];
    [customKeyboard setTextView:textFieldValues];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
