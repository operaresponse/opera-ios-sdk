//
//  BannerDetailViewController.h
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 11/2/14.
//  Copyright (c) 2014 Opera Response. All rights reserved.
//

@import UIKit;
#import "AdUnit.h"
#import "MPAdView.h"

@interface BannerDetailViewController : UIViewController <MPAdViewDelegate>

@property (nonatomic, retain) AdUnit* adUnit;

@end