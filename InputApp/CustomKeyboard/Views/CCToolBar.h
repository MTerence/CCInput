//
//  CCToolBar.h
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, CCTopBarAction) {
    CCTopBarActionSetting = 0,  //设置
    CCTopBarActionEmoji,        //表情
    CCTopBarActionVoice,        //语音
    CCTopBarActionSwitchBoard,  //切换键盘
    CCTopBarActionRecommend,    //推荐语句
    CCTopBarActionSearch,       //搜索
    CCTopBarActionQuit          //退出键盘
};

@protocol CCTopBarDelegate <NSObject>

- (void)didClickToolBar:(CCTopBarAction)action;

@end

@interface CCToolBar : UIView

@property (nonatomic, weak) id<CCTopBarDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
