//
//  OPMediaworksBannerCustomEvent.h
//  Motorgator
//
//  Created by Sumeet Parmar on 10/16/14.
//  Copyright (c) 2014 Sumeet Parmar. All rights reserved.
//

#import "MPBannerCustomEvent.h"
#import "MRAdView.h"
#import "MPPrivateBannerCustomEventDelegate.h"

@interface ORMediaworksBannerCustomEvent : MPBannerCustomEvent <MRAdViewDelegate>

@property (nonatomic, weak) id<MPPrivateBannerCustomEventDelegate> delegate;

@end