//
//  CCLeftTableCell.h
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/14.
//

#import <UIKit/UIKit.h>
#import "CCKeyboardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCLeftTableCell : UITableViewCell

- (void)updateCell:(CCKeyboardModel *)keyboardModel;
- (void)didHighlightItem;
- (void)didUnhighlightItem;

@end

NS_ASSUME_NONNULL_END
