//
//  CCRightView.h
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/15.
//

#import <UIKit/UIKit.h>
#import "CCKeyboardModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CCRightViewDelegate <NSObject>

- (void)rightViewDidClick:(CCKeyboardModel *)keyboardModel;

@end

@interface CCRightView : UIView

@property (nonatomic, weak) id<CCRightViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
