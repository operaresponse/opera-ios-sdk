//
//  BannerDetailViewController.m
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 11/2/14.
//  Copyright (c) 2014 Opera Response. All rights reserved.
//

#import "BannerDetailViewController.h"
#import "AdUnit+AdType.h"

@interface BannerDetailViewController ()

@property (nonatomic, retain) MPAdView* adView;

@end

@implementation BannerDetailViewController

@synthesize adUnit;
@synthesize adView;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ad view
    CGSize adSize = [adUnit.adType intValue] == Banner ? MOPUB_BANNER_SIZE : MOPUB_MEDIUM_RECT_SIZE;
    
    self.adView = [[MPAdView alloc] initWithAdUnitId:self.adUnit.adUnitId size:adSize];
    self.adView.delegate = self;
    self.adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width) / 2,
                                   self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                   MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    self.adView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.adView];
    [self.adView loadAd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - <MPAdViewDelegate>

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)view {
    CGSize size = [view adContentViewSize];
    CGFloat centeredX = (self.view.bounds.size.width - size.width) / 2;
    CGFloat bottomAlignedY = self.view.bounds.size.height - size.height;
    view.frame = CGRectMake(centeredX, bottomAlignedY, size.width, size.height);
}


@end
