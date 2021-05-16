//
//  CCRightView.m
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/15.
//

#import "CCRightView.h"
#import "CCRightTableCell.h"

@interface CCRightView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <CCKeyboardModel *> *dataSource;

@end

@implementation CCRightView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (NSMutableArray <CCKeyboardModel *>*)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        for (NSDictionary *dict in [CCKeyboardModel rightKeyboardModelDicts]) {
            CCKeyboardModel *model = [CCKeyboardModel analyzeModelWithDict:dict];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:CCRightTableCell.class forCellReuseIdentifier:NSStringFromClass(CCRightTableCell.class)];
    [self addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.frame.size.height - 24)/4;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCRightTableCell *cell = (CCRightTableCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CCRightTableCell.class)];
    if (cell == nil) {
        cell = [[CCRightTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(CCRightTableCell.class)];
    }
    
    [cell updateCell:self.dataSource[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CCRightTableCell *cell = (CCRightTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell didHighlightItem];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cell didUnhighlightItem];
    });
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightViewDidClick:)]) {
        [self.delegate rightViewDidClick:self.dataSource[indexPath.section]];
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    CCRightTableCell *cell = (CCRightTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell didHighlightItem];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    CCRightTableCell *cell = (CCRightTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell didUnhighlightItem];
}

@end
