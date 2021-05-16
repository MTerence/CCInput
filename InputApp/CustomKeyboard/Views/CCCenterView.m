//
//  CCCenterView.m
//  CustomKeyboard
//
//  Created by Ternence on 2021/5/15.
//

#import "CCCenterView.h"
#import "CCCenterViewCell.h"
#import "CCKeyboardModel.h"

@interface CCCenterView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <CCKeyboardModel *>* dataSource;

@end

@implementation CCCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (NSMutableArray <CCKeyboardModel *>*)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        for (NSDictionary *dict in [CCKeyboardModel centerKeyboardModelDicts]) {
            CCKeyboardModel *model = [CCKeyboardModel analyzeModelWithDict:dict];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (void)setupUI {
    CGRect frame = self.bounds;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((self.frame.size.width - 32)/3, (self.frame.size.height - 24)/4);
    layout.minimumInteritemSpacing = 8;
    layout.minimumLineSpacing = 8;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 8, 0, 8);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:CCCenterViewCell.class forCellWithReuseIdentifier:NSStringFromClass(CCCenterViewCell.class)];
    [self addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CCCenterViewCell *cell = (CCCenterViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(CCCenterViewCell.class) forIndexPath:indexPath];
    
    [cell updateCell:self.dataSource[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CCCenterViewCell *cell = (CCCenterViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell didHighlightItem];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cell didUnhighlightItem];
    });
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(centerViewDidClick:)]) {
        [self.delegate centerViewDidClick:self.dataSource[indexPath.item]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    CCCenterViewCell *cell = (CCCenterViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell didHighlightItem];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    CCCenterViewCell *cell = (CCCenterViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell didUnhighlightItem];
}

@end
