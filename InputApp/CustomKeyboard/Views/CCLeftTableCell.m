//
//  CCLeftTableCell.m
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/14.
//

#import "CCLeftTableCell.h"
#define imageNamed(s) [UIImage imageNamed:s]
#import "Masonry.h"

@interface CCLeftTableCell ()

@property (nonatomic, strong) UIButton *button;

@end


@implementation CCLeftTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:196/255.0 alpha:1];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview: self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(@0);
    }];
}

- (UIButton *)button {
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.userInteractionEnabled = NO;
    }
    return _button;
}

- (void)updateCell:(CCKeyboardModel *)keyboardModel {
    if (keyboardModel.keyboardAction == CCKeyboardActionText) {
        [self.button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.button setTitle:keyboardModel.string forState:UIControlStateNormal];
    } else {
        [self.button setImage:[UIImage imageNamed:keyboardModel.string] forState:UIControlStateNormal];
        [self.button setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)didHighlightItem {
    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)didUnhighlightItem {
    self.backgroundColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:196/255.0 alpha:1];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
