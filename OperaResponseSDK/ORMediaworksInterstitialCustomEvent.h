//
//  ORMediaworksInterstitialCustomEvent.h
//  Motorgator
//
//  Created by Sumeet Parmar on 10/22/14.
//  Copyright (c) 2014 Sumeet Parmar. All rights reserved.
//

#import "MPInterstitialCustomEvent.h"
#import "MPMRAIDInterstitialViewController.h"
#import "MPPrivateInterstitialCustomEventDelegate.h"

@interface ORMediaworksInterstitialCustomEvent : MPInterstitialCustomEvent <MPInterstitialViewControllerDelegate>

@property (nonatomic, weak) id<MPPrivateInterstitialCustomEventDelegate> delegate;

@end

