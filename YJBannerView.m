//
//  YJBannerView.m
//  PersonalConsumption
//
//  Created by 岳杰 on 2017/1/11.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "YJBannerView.h"
#import "YJBannerCell.h"

#import "PCConfig.h"
#import "PCHeader.h"
#import "PCMarco.h"

// 总共的item数
#define MY_TOTAL_ITEMS (self.itemCount * 1000)

#define MY_WIDTH self.frame.size.width
#define MY_HEIGHT self.frame.size.height

@interface YJBannerView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UIPageControl *pageCtrl;

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YJBannerView

static NSString *bannerReuse = @"YJBannerView";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self addSubview:self.pageCtrl];
        [self startScroll];
    }
    return self;
}

- (void)layoutSubviews
{
    self.collectionView.frame = self.bounds;
    
    [self.pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top).offset(MY_HEIGHT - 30 * kScale);
        make.height.mas_equalTo(20 * kScale);
    }];
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.itemCount < 2) {
        return self.itemCount;
    } else {
        return MY_TOTAL_ITEMS;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YJBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bannerReuse forIndexPath:indexPath];
    //    NSURL *url = [NSURL URLWithString:self.bannerArray[indexPath.item % self.itemCount]];
    //    [cell.imgView sd_setImageWithURL:url placeholderImage:IMAGE(@"")];
    cell.imgView.backgroundColor = ARC4RANDOM_COLOR;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(banner:didSelectIndex:)]) {
        [self.delegate banner:self didSelectIndex:(indexPath.item % self.itemCount)];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentIndexPath = [[collectionView indexPathsForVisibleItems] firstObject];
    self.pageCtrl.currentPage = currentIndexPath.item % self.itemCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(MY_WIDTH, MY_HEIGHT);
}



#pragma mark - 定时器方法
- (void)startScroll
{
    [self stopScroll];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(autoScrollToNextItem) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)autoScrollToNextItem
{
    if (self.itemCount == 0 || self.itemCount == 1) {
        return;
    }
    
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    NSUInteger currentItem = currentIndexPath.item;
    NSUInteger nextItem = currentItem + 1;
    
    if(nextItem >= MY_TOTAL_ITEMS) {
        return;
    }
    // 无限往下翻页
    if (self.itemCount != 1) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:YES];
    } else {
        if ((currentItem % self.itemCount) == self.itemCount - 1) {
            // 当前最后一张, 回到第0张
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft
                                                animated:YES];
        } else {
            // 往下翻页
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft
                                                animated:YES];
        }
    }
}

- (void)stopScroll
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 滑动时定时器停止
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 用户滑动的时候停止定时器
    [self stopScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 用户停止滑动的时候开启定时器
    [self startScroll];
}


#pragma mark getter and setters
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        [self addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.clipsToBounds = NO;
        self.collectionView.bounces = NO;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        // 注册cell
        [self.collectionView registerClass:[YJBannerCell class] forCellWithReuseIdentifier:bannerReuse];
    }
    return _collectionView;
}

- (UIPageControl *)pageCtrl
{
    if (!_pageCtrl) {
        self.pageCtrl = [[UIPageControl alloc] init];
        self.pageCtrl.userInteractionEnabled = NO;
        self.pageCtrl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageCtrl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.8];
    }
    return _pageCtrl;
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)setBannerArray:(NSMutableArray *)bannerArray
{
    self.itemCount = bannerArray.count;
    if (self.itemCount < 2) {
        self.collectionView.scrollEnabled = NO;
    }
    self.pageCtrl.numberOfPages = bannerArray.count;
    [self.collectionView reloadData];
    [self startScroll];
}

- (CGFloat)scrollInterval
{
    if (!_scrollInterval) {
        self.scrollInterval = 3;
    }
    return _scrollInterval;
}


@end
