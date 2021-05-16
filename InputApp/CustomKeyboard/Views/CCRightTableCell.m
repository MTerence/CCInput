//
//  CCRightTableCell.m
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/15.
//

#import "CCRightTableCell.h"
#import "Masonry.h"

@interface CCRightTableCell ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation CCRightTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview: self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(@0);
    }];
}

- (UIButton *)button {
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.clipsToBounds = YES;
        _button.layer.cornerRadius = 3;
        _button.userInteractionEnabled = NO;
        _button.backgroundColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:196/255.0 alpha:1];
    }
    return _button;
}

- (void)updateCell:(CCKeyboardModel *)keyboardModel {
    if (keyboardModel.keyboardAction == CCKeyboardActionText ||
        keyboardModel.keyboardAction == CCKeyboardActionWrap ) {
        [self.button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.button setTitle:keyboardModel.string forState:UIControlStateNormal];
    } else {
        [self.button setImage:[UIImage imageNamed:keyboardModel.string] forState:UIControlStateNormal];
        [self.button setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)didHighlightItem {
    self.button.backgroundColor = [UIColor lightGrayColor];
}

- (void)didUnhighlightItem {
    self.button.backgroundColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:196/255.0 alpha:1];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
