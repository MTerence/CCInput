//
//  CCCenterView.h
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/15.
//

#import <UIKit/UIKit.h>
#import "CCKeyboardModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CCCenterViewDelegate <NSObject>

- (void)centerViewDidClick:(CCKeyboardModel *)keyboardModel;

@end

@interface CCCenterView : UIView

@property (nonatomic, weak) id<CCCenterViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
