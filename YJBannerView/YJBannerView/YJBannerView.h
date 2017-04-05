//
//  YJBannerView.h
//  PersonalConsumption
//
//  Created by 岳杰 on 2017/1/11.
//  Copyright © 2017年 yuejieee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJBannerViewDelegate;

@interface YJBannerView : UIView

@property (nonatomic, weak) id<YJBannerViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame bannerArray:(NSMutableArray *)array placeHolder:(UIImage *)image scrollInterval:(CGFloat)interval;

@end

@protocol YJBannerViewDelegate <NSObject>

- (void)banner:(YJBannerView *)banner didSelectIndex:(NSInteger)index;

@end


