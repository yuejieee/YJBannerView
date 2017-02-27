//
//  YJBannerCell.m
//  PersonalConsumption
//
//  Created by 岳杰 on 2017/1/11.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "YJBannerCell.h"

@implementation YJBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgView];
        self.imgView.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    self.imgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        self.imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

@end
