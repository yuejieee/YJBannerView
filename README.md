# YJBannerView
## Description
这是一个无限滚动的轮播图封装，主要思路是将collectionView的item至为1000 * 真实item个数，使其呈现出假的无限滚动，利用collcetionView重用远离，减少了资源的占用
## Usage
```
  YJBannerView *bannerView = [[YJBannerView alloc] initWithFrame:CGRectMake(0, 50, kWidth, 200)
                                                     bannerArray:self.bannerArray // 传入图片数组
                                                     placeHolder:[UIImage imageNamed:@"placeHolder"]  // 设置占位图 
                                                     scrollInterval:2]; // 自动滚动间隔
  [self.view addSubview:bannerView];
```

## Protocol
```
- (void)banner:(YJBannerView *)banner didSelectIndex:(NSInteger)index;
// 获取点击item的index
```
