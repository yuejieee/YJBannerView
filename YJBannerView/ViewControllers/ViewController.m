//
//  ViewController.m
//  YJBannerView
//
//  Created by Kingpin on 2017/4/5.
//  Copyright © 2017年 yuejieee. All rights reserved.
//

#import "ViewController.h"
#import "YJBannerView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController () <YJBannerViewDelegate>

@property (nonatomic, strong) NSMutableArray *bannerArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    YJBannerView *bannerView = ({
        YJBannerView *bannerView = [[YJBannerView alloc] initWithFrame:CGRectMake(0, 50, kWidth, 200)
                                                           bannerArray:self.bannerArray
                                                           placeHolder:[UIImage imageNamed:@"placeHolder"]
                                                        scrollInterval:2];
        [self.view addSubview:bannerView];
        bannerView.delegate = self;
        bannerView;
    });
}

- (void)loadData {
    self.bannerArray = [NSMutableArray new];
    for (NSInteger i = 0; i < 5; i++) {
        NSString *string = [NSString stringWithFormat:@"https://fakeimg.pl/450x200/?text=%ld", i];
        [self.bannerArray addObject:string];
    }
}

- (void)banner:(YJBannerView *)banner didSelectIndex:(NSInteger)index {
    NSLog(@"selectedIndex: %ld", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
