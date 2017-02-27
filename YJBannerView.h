//
//  YJBannerView.h
//  PersonalConsumption
//
//  Created by 岳杰 on 2017/1/11.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJBannerViewDelegate;

@interface YJBannerView : UIView

@property (nonatomic, strong) NSMutableArray *bannerArray;

@property (nonatomic, assign) CGFloat scrollInterval;

@property (nonatomic, weak) id<YJBannerViewDelegate>delegate;

@end

@protocol YJBannerViewDelegate <NSObject>

- (void)banner:(YJBannerView *)banner didSelectIndex:(NSInteger)index;

@end


