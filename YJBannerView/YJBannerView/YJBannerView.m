//
//  YJBannerView.m
//  PersonalConsumption
//
//  Created by 岳杰 on 2017/1/11.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "YJBannerView.h"
#import "YJBannerCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

// 总共的item数
#define MY_TOTAL_ITEMS (self.itemCount * 1000)

#define MY_WIDTH self.frame.size.width
#define MY_HEIGHT self.frame.size.height
#define kScale [UIScreen mainScreen].bounds.size.width / 375

@interface YJBannerView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UIPageControl *pageCtrl;

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *bannerArray;
// 时间间隔
@property (nonatomic, assign) CGFloat scrollInterval;
// 占位图
@property (nonatomic, strong) UIImage *placeHolder;

@end

@implementation YJBannerView

static NSString *bannerReuse = @"YJBannerView";

- (instancetype)initWithFrame:(CGRect)frame bannerArray:(NSMutableArray *)array placeHolder:(UIImage *)image scrollInterval:(CGFloat)interval
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bannerArray = array;
        self.placeHolder = image;
        self.scrollInterval = interval;
        self.itemCount = array.count;
        if (self.itemCount < 2) {
            self.collectionView.scrollEnabled = NO;
        }
        [self setupSubviewsWithFrame:frame];
        [self startScroll];
    }
    return self;
}

- (void)setupSubviewsWithFrame:(CGRect)frame {
    self.collectionView = ({
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        [self addSubview:collectionView];
        collectionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.clipsToBounds = NO;
        collectionView.bounces = NO;
        collectionView.pagingEnabled = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        // 注册cell
        [collectionView registerClass:[YJBannerCell class] forCellWithReuseIdentifier:bannerReuse];
        collectionView;
    });
    
    self.pageCtrl = ({
        UIPageControl *pageCtrl = [[UIPageControl alloc] init];
        [self addSubview:pageCtrl];
        [pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(frame.size.height - 30 * kScale);
            make.height.mas_equalTo(20 * kScale);
        }];
        if (self.bannerArray.count > 1) {
            pageCtrl.numberOfPages = self.bannerArray.count;
        }
        pageCtrl.userInteractionEnabled = NO;
        pageCtrl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        pageCtrl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.8];
        pageCtrl;
    });
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
    NSString *string = self.bannerArray[indexPath.item % self.itemCount];
    if ([string containsString:@"/"]) {
        NSURL *url = [NSURL URLWithString:string];
        [cell.imgView sd_setImageWithURL:url placeholderImage:self.placeHolder];
    } else {
        cell.imgView.image = [UIImage imageNamed:string];
        
    }
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
- (void)reloadData
{
    [self.collectionView reloadData];
}

@end
