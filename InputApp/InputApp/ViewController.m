//
//  ViewController.m
//  InputApp
//
//  Created by Ternence on 2021/5/14.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTextField];
}

- (void)setupTextField {
    CGRect frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200)/2, ([UIScreen mainScreen].bounds.size.height - 200)/2, 200, 200);
    self.textView = [[UITextView alloc] initWithFrame:frame];
    self.textView.text = @"码代码的小马";
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    [self.view addSubview:self.textView];
    
    [self.textView becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}


@end
