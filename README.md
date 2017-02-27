# YJBannerView
##Description
这是一个无限滚动的轮播图封装，主要思路是将collectionView的item至为1000 * 真实item个数，使其呈现出假的无限滚动，利用collcetionView重用远离，减少了资源的占用
##Usage
```
  self.bannerView = [[YJBannerView alloc] init];
  self.bannerView.frame = CGRectMake(0, 0, 200, 100);
  // 设置图片(图片名)
  self.bannerView.bannerArray = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", nil];
  // 设置滚动时间
  self.bannerView.scrollInterval = 0.2
```
