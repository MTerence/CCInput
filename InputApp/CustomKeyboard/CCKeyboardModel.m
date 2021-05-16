//
//  CCKeyboardModel.m
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/14.
//

#import "CCKeyboardModel.h"
#import <objc/runtime.h>

@implementation CCKeyboardModel


+ (CCKeyboardModel *)analyzeModelWithDict:(NSDictionary *)dict {
    
    CCKeyboardModel *obj = [[CCKeyboardModel alloc] init];
    unsigned count;
    Ivar *ivarList = class_copyIvarList(CCKeyboardModel.class, &count);

    for (NSInteger i = 0; i < count; i ++) {
        Ivar ivar = ivarList[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString * key = [ivarName substringFromIndex:1];
        id value = dict[key];
        [obj setValue:value forKey:key];
        
    }
    return obj;
}

+ (NSArray<NSDictionary *> *)rightKeyboardModelDicts {
    return @[@{@"string": @"delete_skinMaker_24x24_",
               @"keyboardAction": @(CCKeyboardActionDelete)},
             @{@"string": @"。",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"@",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"换行",
               @"keyboardAction": @(CCKeyboardActionWrap)}];
}

+ (NSArray<NSDictionary *> *)leftKeyboardModelDicts {
    return @[@{@"string": @"%",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"-",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"+",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"！",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"...",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"~",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"'",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"、",
               @"keyboardAction": @false},
             @{@"string": @"符号",
               @"keyboardAction": @(CCKeyboardActionAdd)}];
}

+ (NSArray<NSDictionary *> *)centerKeyboardModelDicts {
    return @[@{@"string": @"1",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"2",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"3",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"4",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"5",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"6",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"7",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"8",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"9",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"切换",
               @"keyboardAction": @(CCKeyboardActionSwitchBoard)},
             @{@"string": @"0",
               @"keyboardAction": @(CCKeyboardActionText)},
             @{@"string": @"空格",
               @"keyboardAction": @(CCKeyboardActionSpace)}
    ];
}

@end
