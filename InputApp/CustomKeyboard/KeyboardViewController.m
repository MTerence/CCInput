//
//  KeyboardViewController.m
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/14.
//

#import "KeyboardViewController.h"
#import "CCToolBar.h"
#import "CCLeftTableView.h"
#import "Masonry.h"
#import "CCCenterView.h"
#import "CCRightView.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.width
#define imageNamed(s) [UIImage imageNamed:s]

static CGFloat KEYBOARDHEIGHT = 256;

@interface KeyboardViewController ()
<CCTopBarDelegate,
CCLeftViewDelegate,
CCCenterViewDelegate,
CCRightViewDelegate>


/// 用于设置键盘自定义高度
@property (nonatomic, assign) NSLayoutConstraint *heightConstraint;

@end

@implementation KeyboardViewController

- (void)prepareHeightConstraint {
    if (self.heightConstraint == nil) {
        UILabel *dummyView = [[UILabel alloc] initWithFrame:CGRectZero];
        dummyView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:dummyView];
        
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:KEYBOARDHEIGHT];
        self.heightConstraint.priority = 750;
        [self.view addConstraint:self.heightConstraint];
    } else {
        self.heightConstraint.constant = KEYBOARDHEIGHT;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareHeightConstraint];
}

/// 重写的父类方法，苹果建议在此处updateViewConstraints
- (void)updateViewConstraints {
    [super updateViewConstraints];

    if (self.view.frame.size.width == 0 && self.view.frame.size.height == 0) {
        return;
    }
    [self prepareHeightConstraint];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    CGFloat toolBarHeight = 40;
    CGFloat bottom = 5;
    CGFloat buttonSpace = 8;
    CGFloat eachButtonHeight = (KEYBOARDHEIGHT - toolBarHeight - 10 - 8 * 3 - bottom) / 4;
    
    CCToolBar *toolBar = [[CCToolBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, toolBarHeight)];
    [self.view addSubview:toolBar];
    
    CCLeftTableView *leftTableView = [[CCLeftTableView alloc]initWithFrame:CGRectMake(5, toolBarHeight + 10, 60, eachButtonHeight * 3 + buttonSpace * 2)];
    [self.view addSubview:leftTableView];
    
    CCCenterView *centerView = [[CCCenterView alloc] initWithFrame:CGRectMake(leftTableView.frame.size.width + leftTableView.frame.origin.x, leftTableView.frame.origin.y, SCREEN_WIDTH - leftTableView.frame.origin.x - leftTableView.frame.size.width - 68, eachButtonHeight * 4 + buttonSpace * 3)];
    [self.view addSubview:centerView];
    
    CCRightView *rightView = [[CCRightView alloc] initWithFrame:CGRectMake(centerView.frame.size.width + centerView.frame.origin.x, leftTableView.frame.origin.y, 60, eachButtonHeight * 4 + buttonSpace * 3)];
    [self.view addSubview:rightView];
    
    UIButton *symbolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    symbolButton.clipsToBounds = YES;
    symbolButton.layer.cornerRadius = 5;
    symbolButton.frame = CGRectMake(leftTableView.frame.origin.x, KEYBOARDHEIGHT - bottom - eachButtonHeight, 60, eachButtonHeight);
    symbolButton.backgroundColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:196/255.0 alpha:1];
    [symbolButton setTitle:@"符" forState:UIControlStateNormal];
    [symbolButton addTarget:self action:@selector(handleInputModeListFromView:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:symbolButton];
    
    toolBar.delegate = self;
    leftTableView.delegate = self;
    centerView.delegate = self;
    rightView.delegate = self;
}

#pragma mark - CCToolBarDelegate
- (void)didClickToolBar:(CCTopBarAction)action {
    if (action == CCTopBarActionQuit) {
        [self dismissKeyboard];
    }
}

#pragma mark - CCLeftViewDelegate
- (void)leftViewDidClick:(id)keyboardModel {
    [self didClickKeyboardModel:keyboardModel];
}

#pragma mark - CCCenterViewDelegate
- (void)centerViewDidClick:(CCKeyboardModel *)keyboardModel {
    [self didClickKeyboardModel:keyboardModel];
}

#pragma mark - CCRightViewDelegate
- (void)rightViewDidClick:(CCKeyboardModel *)keyboardModel {
    [self didClickKeyboardModel:keyboardModel];
}

- (void)didClickKeyboardModel:(CCKeyboardModel *)keyboardModel {
    if (keyboardModel.keyboardAction == CCKeyboardActionText) {
        [self.textDocumentProxy insertText:keyboardModel.string];
    } else if (keyboardModel.keyboardAction == CCKeyboardActionWrap) {
        [self.textDocumentProxy insertText:@"\n"];
    } else if (keyboardModel.keyboardAction == CCKeyboardActionSpace) {
        [self.textDocumentProxy insertText:@" "];
    } else if (keyboardModel.keyboardAction == CCKeyboardActionDelete) {
        [self.textDocumentProxy deleteBackward];
    } else if (keyboardModel.keyboardAction == CCKeyboardActionSymbol) {
        
    } else if (keyboardModel.keyboardAction == CCKeyboardActionSwitchBoard) {
        [self advanceToNextInputMode];
    }
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
}

@end
