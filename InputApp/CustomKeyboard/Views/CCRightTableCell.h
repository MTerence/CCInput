//
//  CCRightTableCell.h
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/15.
//

#import <UIKit/UIKit.h>
#import "CCKeyboardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCRightTableCell : UITableViewCell

- (void)updateCell:(CCKeyboardModel *)customModel;

- (void)didHighlightItem;
- (void)didUnhighlightItem;

@end

NS_ASSUME_NONNULL_END
