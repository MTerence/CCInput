//
//  CCToolBar.m
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/14.
//

#import "CCToolBar.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.width
#define imageNamed(s) [UIImage imageNamed:s]



@interface CCToolBar ()

@end

@implementation CCToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (NSArray *)imageNames {
    return @[@"toolbar_logo_26x26_",
             @"toolbar_emoji_20x20_",
             @"toolbar_voice_20x20_",
             @"toolbar_keyboardMode_20x20_",
             @"toolbar_translate_20x20_",
             @"toolbar_setting_20x20_",
             @"toolbar_dismiss_20x20_"];
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:196/255.0 alpha:1];
    CGSize buttonSize = CGSizeMake((self.frame.size.width)/[self imageNames].count, self.frame.size.height);
    for (NSInteger i = 0; i < [self imageNames].count; i ++) {
        NSString *imageName = [self imageNames][i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1000 + i;
        button.frame = CGRectMake(i * buttonSize.width, 0, buttonSize.width, buttonSize.height);
        [button setImage:imageNamed(imageName) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    
}

- (void)didClickButton:(UIButton *)sender {
    sender.backgroundColor = [UIColor lightGrayColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.backgroundColor = [UIColor clearColor];
    });
    CCTopBarAction action = (CCTopBarAction)(sender.tag - 1000);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickToolBar:)]) {
        [self.delegate didClickToolBar:action];
    }
}

@end
