//
//  CCCenterViewCell.m
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/15.
//

#import "CCCenterViewCell.h"

@interface CCCenterViewCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation CCCenterViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor clearColor];
    self.label.frame = self.contentView.bounds;
    [self addSubview:self.label];
}

- (void)updateCell:(CCKeyboardModel *)model {
    self.label.text = model.string;
    
    if (model.keyboardAction == CCKeyboardActionAdd) {
        self.label.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:102.0/255.0 blue:46.0/255.0 alpha:1];
    } else {
        self.label.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)didHighlightItem {
    self.label.backgroundColor = [UIColor lightGrayColor];
}

- (void)didUnhighlightItem {
    self.label.backgroundColor = [UIColor clearColor];
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor blackColor];

        self.label.textColor = [UIColor clearColor];
    }
    return _label;
}

@end
