//
//  ORMediaworksBannerCustomEvent.m
//  Motorgator
//
//  Created by Sumeet Parmar on 10/16/14.
//  Copyright (c) 2014 Sumeet Parmar. All rights reserved.
//

// MoPub
#import "MPInstanceProvider.h"
#import "MPLogging.h"

// Opera
#import <OperaResponse/ORSDK.h>
#import "ORMediaworksBannerCustomEvent.h"

@interface ORMediaworksBannerCustomEvent ()

@property (nonatomic, strong) MRAdView *banner;
@property (nonatomic, strong) ORAdResponse *response;
@property (copy) ORAdRequestCompletionBlock block;

@end

@implementation ORMediaworksBannerCustomEvent

@synthesize banner;
@synthesize response;
@synthesize delegate;

- (id) init {
    self = [super init];
    
    if (self) {
        __weak ORMediaworksBannerCustomEvent *ref = self;
        
        ref.block = ^(ORAdResponse *adResponse) {
            if (adResponse) {
                if (ref) {
                    ref.response = adResponse;
                    ref.banner = [[MPInstanceProvider sharedProvider] buildMRAdViewWithFrame:adResponse.frame
                                                                              allowsExpansion:YES
                                                                             closeButtonStyle:MRAdViewCloseButtonStyleAdControlled
                                                                                placementType:MRAdViewPlacementTypeInline
                                                                                     delegate:ref];
                    [ref.banner loadCreativeWithHTMLString:adResponse.creative baseURL:nil];
                    [ref.delegate bannerCustomEvent:self didLoadAd:self.banner];
                }
            } else {
                if (ref) {
                    [ref.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
                }
            }
        };
    }
    
    return self;
}

- (void)dealloc {
    self.block = nil;
    self.response = nil;
    self.banner = nil;
}

- (void) requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info {
    MPLogInfo(@"OperaResponse requestAdWithSize(), size = %@, info = %@", NSStringFromCGSize(size), info);
    [ORSDK requestAdWithInfo:info completionBlock:self.block];
}

#pragma mark - MRAdViewDelegate

- (CLLocation *)location {
    MPLogInfo(@"location");
    return [self.delegate location];
}

- (NSString *)adUnitId {
    MPLogInfo(@"adUnitId");
    return [self.delegate adUnitId];
}

- (MPAdConfiguration *)adConfiguration {
    MPLogInfo(@"adConfiguration");
    return [self.delegate configuration];
}

- (UIViewController *)viewControllerForPresentingModalView {
    return [self.delegate viewControllerForPresentingModalView];
}

- (void)adDidLoad:(MRAdView *)adView {
    MPLogInfo(@"MoPub MRAID banner did load");
    [ORSDK trackImpression:self.response];
    [self.delegate bannerCustomEvent:self didLoadAd:adView];
}

- (void)adDidFailToLoad:(MRAdView *)adView {
    MPLogInfo(@"MoPub MRAID banner did fail");
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)closeButtonPressed {
    //don't care
}

- (void)appShouldSuspendForAd:(MRAdView *)adView {
    MPLogInfo(@"MoPub MRAID banner will begin action");
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void)appShouldResumeFromAd:(MRAdView *)adView {
    MPLogInfo(@"MoPub MRAID banner did end action");
    [self.delegate bannerCustomEventDidFinishAction:self];
}


@end