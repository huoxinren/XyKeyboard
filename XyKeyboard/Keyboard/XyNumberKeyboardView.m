//
//  
//
//
//  Created by xyz on 14/11/18.
//  Copyright (c) 2014年 liu xin. All rights reserved.
//

#import "XyNumberKeyboardView.h"

@implementation XyNumberKeyboardView

@synthesize textView = _textView;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code ceshi
}
*/

- (id)initWithKeyboard
{
    CGRect frame = CGRectMake(0, 0, 320, 216);
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
    }
    
     [self creatKeyboardUI];
    
    return self;
}

- (void)setTextView:(id<UITextInput>)textView
{
    if ([textView isKindOfClass:[UITextView class]]) {
        [(UITextView *)textView setInputView:self];
    }
    else if ([textView isKindOfClass:[UITextField class]]) {
        [(UITextField *)textView setInputView:self];
    }
    
    _textView = textView;
}

-(id<UITextInput>)textView
{
    return _textView;
}

- (BOOL) enableInputClicksWhenVisible
{
    return YES;
}

- (void)creatKeyboardUI
{
    int     xOffset = 77;
    int     yOffset = 52;
    
    int     leftSpace = ([[UIScreen mainScreen] bounds].size.width-310)/2;
    
    
    int     xRemainder;
    int     yRemainder = 0;
    //10:.;  11:0;  12:收起;   13:删除;   14:确定
    for (int i = 1; i<=14; i++)
    {
        NSString *detail = [NSString stringWithFormat:@"%d_detail.png", i];
        NSString *click = [NSString stringWithFormat:@"%d_click.png", i];
        
        if ((i != KEY_DELETE) && (i != KEY_OK))
        {
            UIButton *buttonKey = [UIButton buttonWithType:UIButtonTypeCustom];
            [buttonKey setTag:-10000-i];
            
            xRemainder = i%3;
            if (xRemainder != 0)
            {
                [buttonKey setFrame:CGRectMake(leftSpace+(i%3-1)*xOffset, 8+yRemainder*yOffset, 70, 47)];
            }
            else
            {
                [buttonKey setFrame:CGRectMake(leftSpace+2*xOffset, 8+yRemainder*yOffset, 70, 47)];
            }
            
            [buttonKey setBackgroundImage:[UIImage imageNamed:detail] forState:UIControlStateNormal];
            [buttonKey setBackgroundImage:[UIImage imageNamed:click] forState:UIControlStateSelected];
            [buttonKey addTarget:self action:@selector(updateTextContent:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:buttonKey];
            
            if (i%3 == 0)
            {
                yRemainder ++;
            }
        }
        else if (i == KEY_DELETE)
        {
            UIButton *buttonKey = [UIButton buttonWithType:UIButtonTypeCustom];
            [buttonKey setTag:-10000-i];
            [buttonKey setFrame:CGRectMake(242+([[UIScreen mainScreen] bounds].size.width-310)/2-5, 8, 70, 99)];
            [buttonKey setBackgroundImage:[UIImage imageNamed:detail] forState:UIControlStateNormal];
            [buttonKey setBackgroundImage:[UIImage imageNamed:click] forState:UIControlStateSelected];
            [buttonKey addTarget:self action:@selector(updateTextContent:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:buttonKey];
        }
        else if (i == KEY_OK)
        {
            UIButton *buttonKey = [UIButton buttonWithType:UIButtonTypeCustom];
            [buttonKey setTag:-10000-i];
            [buttonKey setFrame:CGRectMake(242+([[UIScreen mainScreen] bounds].size.width-310)/2-5, 113, 70, 99)];
            [buttonKey setBackgroundImage:[UIImage imageNamed:detail] forState:UIControlStateNormal];
            [buttonKey setBackgroundImage:[UIImage imageNamed:click] forState:UIControlStateSelected];
            [buttonKey addTarget:self action:@selector(updateTextContent:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:buttonKey];
        }
    }
}


- (void)updateTextContent:(UIButton *)sender
{
    NSInteger  buttonTag = [sender tag];
    
    NSLog(@"点击键盘tag[%ld]", (long)buttonTag);
    
    NSInteger  tagIndex = -buttonTag-10000;
    
    if ((tagIndex >= 1) && (tagIndex <= 11)) //编辑
    {
        /*
        //如果有“.”, 不执行
        if (([textView.text rangeOfString:@"."].location != NSNotFound) && (tagIndex == KEY_POINT))
        {
            return;
        }
        
        //小数点后两位, 不执行
        if ([textView.text rangeOfString:@"."].location != NSNotFound)
        {
            if ([textField.text length] - [textField.text rangeOfString:@"."].location >= 3)
            {
                return;
            }
        }

        NSMutableString *textFieldTextTemp = [NSMutableString stringWithFormat:@"%@%d", textField.text, tagIndex];
        textField.text = textFieldTextTemp;
                 */
        [self characterPressed:tagIndex];
    }
    else if (tagIndex == KEY_REMOVE)//收起
    {
        [self returnPressed];
    }
    else if (tagIndex == KEY_DELETE)//删除
    {
        /*
        NSString * textFieldTextTemp = [textField.text substringWithRange:NSMakeRange(0, [textField.text length]-1)];
        textField.text = textFieldTextTemp;
         */
        [self deletePressed];
    }
    else if (tagIndex == KEY_OK)//确定
    {
        [self returnPressed];
        
        //通知准备支付
        //[[NSNotificationCenter defaultCenter] postNotificationName:NotificationOfpay object:nil];
    }
    
    //MMLog(@"更改后:[%@]...", textField.text);
}

- (void)returnPressed
{
    [(UITextField *)self.textView resignFirstResponder];
}

- (void)deletePressed
{
    [[UIDevice currentDevice] playInputClick];
    [self.textView deleteBackward];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification
                                                        object:self.textView];
    if ([self.textView isKindOfClass:[UITextView class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
    else if ([self.textView isKindOfClass:[UITextField class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
}

- (void)characterPressed:(NSInteger)tagIndex
{
    NSString *character;
    if ((tagIndex != KEY_POINT) && (tagIndex != KEY_ZERO))
    {
        character = [NSString stringWithString:[NSString stringWithFormat:@"%ld", (long)tagIndex]];
    }
    else if (tagIndex == KEY_POINT)
    {
        character = @".";
    }
    else if (tagIndex == KEY_ZERO)
    {
        character = @"0";
    }
    
    NSLog(@"＋＋＋＋＋＋＋＋＋＋[%@]＋＋＋＋＋＋＋＋",((UITextField *)self.textView).text);

    //如果有“.”, 不执行
    if (([((UITextField *)self.textView).text rangeOfString:@"."].location != NSNotFound) && (tagIndex == KEY_POINT))
    {
        return;
    }
    
    //小数点后两位, 不执行
    if ([((UITextField *)self.textView).text rangeOfString:@"."].location != NSNotFound)
    {
        if ([((UITextField *)self.textView).text length] - [((UITextField *)self.textView).text rangeOfString:@"."].location >= 3)
        {
            return;
        }
    }
    
    if ([((UITextField *)self.textView).text length] >= 8)
    {
        return;
    }
    
    if (([((UITextField *)self.textView).text rangeOfString:@"."].location == NSNotFound) && ([((UITextField *)self.textView).text length]>=5) && (![character isEqualToString:@"."]))
    {
        return;
    }
    
    [self.textView insertText:character];
    
    if ([self.textView isKindOfClass:[UITextView class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
    else if ([self.textView isKindOfClass:[UITextField class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
}


@end
