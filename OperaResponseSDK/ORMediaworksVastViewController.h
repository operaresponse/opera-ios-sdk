//
//  ORMediaworksVastViewController.h
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 4/7/15.
//  Copyright (c) 2015 Opera Response. All rights reserved.
//

@import UIKit;

#import "MPInterstitialViewController.h"

@class ORVastVideoConfiguration;

@interface ORMediaworksVastViewController : MPInterstitialViewController

- (instancetype)initWithAdConfiguration:(MPAdConfiguration *)adConfiguration
                  withVastConfiguration:(ORVastVideoConfiguration *)vastConfiguration;

@end
