//
//  
//
//
//  Created by xyz on 14/11/18.
//  Copyright (c) 2014年 liu xin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//10:.;  11:0;  12:收起;   13:删除;   14:确定
#define KEY_POINT       10
#define KEY_ZERO        11
#define KEY_REMOVE      12
#define KEY_DELETE      13
#define KEY_OK          14

@interface XyNumberKeyboardView : UIView<UIInputViewAudioFeedback>
{
    
}

@property (strong) id<UITextInput> textView;

- (id)initWithKeyboard;

- (void)creatKeyboardUI;

- (void)updateTextContent:(UIButton *)sender;


- (void)returnPressed;
- (void)deletePressed;
- (void)characterPressed:(NSInteger)tagIndex;

@end
