//
//  ORVastViewController.h
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 1/8/15.
//  Copyright (c) 2015 Opera Response. All rights reserved.
//

@import UIKit;

@class ORVastVideoConfiguration;

@interface ORVastViewController : UIViewController

- (instancetype)initWithVastConfiguration:(ORVastVideoConfiguration *)vastConfiguration;
- (void)startLoading;
- (void)play;
- (void)stop;

@end