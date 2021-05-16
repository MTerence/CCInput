//
//  CCLeftTableView.m
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/14.
//

#import "CCLeftTableView.h"
#import "CCLeftTableCell.h"

@interface CCLeftTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <CCKeyboardModel *>*dataSource;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CCLeftTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupDataSource];
    }
    return self;
}

- (NSMutableArray <CCKeyboardModel *>*)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setupDataSource {
    for (NSDictionary *dict in [CCKeyboardModel leftKeyboardModelDicts]) {
        CCKeyboardModel *model = [CCKeyboardModel analyzeModelWithDict:dict];
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    [self.tableView registerClass:[CCLeftTableCell class] forCellReuseIdentifier:NSStringFromClass(CCLeftTableCell.class)];
    [self addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.height / 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCLeftTableCell *cell = (CCLeftTableCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CCLeftTableCell.class)];
    if (cell == nil) {
        cell = [[CCLeftTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(CCLeftTableCell.class)];
    }
    
    CCKeyboardModel *model = [self dataSource][indexPath.row];
    [cell updateCell:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CCLeftTableCell *cell = (CCLeftTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell didHighlightItem];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cell didUnhighlightItem];
    });
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftViewDidClick:)]) {
        [self.delegate leftViewDidClick:self.dataSource[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    CCLeftTableCell *cell = (CCLeftTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell didHighlightItem];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    CCLeftTableCell *cell = (CCLeftTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell didUnhighlightItem];
}

@end
