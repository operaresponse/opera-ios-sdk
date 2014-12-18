//
//  ORMediaworksInterstitialCustomEvent.h
//  Motorgator
//
//  Created by Sumeet Parmar on 10/22/14.
//  Copyright (c) 2014 Sumeet Parmar. All rights reserved.
//

#import "MPInterstitialCustomEvent.h"
#import "MPPrivateInterstitialCustomEventDelegate.h"
#import "MPMRAIDInterstitialViewController.h"

@interface ORMediaworksInterstitialCustomEvent : MPInterstitialCustomEvent <MPInterstitialViewControllerDelegate>

@property (nonatomic, weak) id<MPPrivateInterstitialCustomEventDelegate> delegate;

@end

