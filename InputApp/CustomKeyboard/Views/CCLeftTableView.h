//
//  CCLeftTableView.h
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/14.
//

#import <UIKit/UIKit.h>
#import "CCKeyboardModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CCLeftViewDelegate <NSObject>

- (void)leftViewDidClick:(CCKeyboardModel *)keyboardModel;

@end

@interface CCLeftTableView : UIView

@property (nonatomic, weak) id<CCLeftViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
