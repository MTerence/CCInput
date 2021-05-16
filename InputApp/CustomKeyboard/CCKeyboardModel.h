//
//  CCKeyboardModel.h
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CCKeyboardAction) {
    CCKeyboardActionText = 0,     //文本
    CCKeyboardActionAdd,          //添加
    CCKeyboardActionDelete,       //删除字符
    CCKeyboardActionWrap,         //换行
    CCKeyboardActionSymbol,       //符号
    CCKeyboardActionSpace,        //空格
    CCKeyboardActionSwitchBoard,  //切换键盘
};

@interface CCKeyboardModel : NSObject

/// 自定义的字符串
@property (nonatomic, copy) NSString *string;

@property (nonatomic, assign) CCKeyboardAction keyboardAction;

+ (CCKeyboardModel *)analyzeModelWithDict:(NSDictionary *)dict;

+ (NSArray<NSDictionary *> *)leftKeyboardModelDicts;
+ (NSArray<NSDictionary *> *)centerKeyboardModelDicts;
+ (NSArray<NSDictionary *> *)rightKeyboardModelDicts;

@end

NS_ASSUME_NONNULL_END
