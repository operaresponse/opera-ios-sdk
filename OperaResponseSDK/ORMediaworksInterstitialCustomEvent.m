//
//  ORMediaworksInterstitialCustomEvent.m
//  Motorgator
//
//  Created by Sumeet Parmar on 10/22/14.
//  Copyright (c) 2014 Sumeet Parmar. All rights reserved.
//

// MoPub
#import "MPInstanceProvider.h"
#import "MPLogging.h"
#import "MPAdConfiguration.h"

// Opera
#import <OperaResponse/ORSDK.h>
#import "ORMediaworksInterstitialCustomEvent.h"

@interface ORMediaworksInterstitialCustomEvent()

@property (nonatomic, strong) MPMRAIDInterstitialViewController *interstitial;
@property (nonatomic, strong) ORAdResponse *adResponse;
@property (copy) ORAdRequestCompletionBlock block;

@end

@implementation ORMediaworksInterstitialCustomEvent

@synthesize delegate;
@synthesize interstitial = _interstitial;
@synthesize adResponse;

- (id)init {
    self = [super init];
    
    if (self) {
        __weak ORMediaworksInterstitialCustomEvent *ref = self;
        
        if (ref) {
            ref.block = ^(ORAdResponse *response) {
                if (response && [response.creative length] > 0) {
                    ref.adResponse = response;
                    MPAdConfiguration *configuration = [ref.delegate configuration];
                    configuration.adResponseData = [response.creative dataUsingEncoding:NSUTF8StringEncoding];
                    
                    ref.interstitial = [[MPInstanceProvider sharedProvider] buildMPMRAIDInterstitialViewControllerWithDelegate:ref configuration:configuration];
                    [ref.interstitial setCloseButtonStyle:MPInterstitialCloseButtonStyleAlwaysHidden];
                    [ref.interstitial startLoading];
                } else {
                    [ref.delegate interstitialCustomEvent:ref didFailToLoadAdWithError:nil];
                }
            };
        }
    }
    
    return self;
}

- (void)dealloc {
    self.block = nil;
    self.delegate = nil;
    self.interstitial = nil;
}

- (void) requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    MPLogInfo(@"requestInterstitial() info = %@", info);
    [ORSDK requestInterstitialWithInfo:info completionBlock:self.block];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    MPLogInfo(@"showInterstitialFromRootViewController");
    [self.interstitial presentInterstitialFromViewController:rootViewController];
}

#pragma mark - MPMRAIDInterstitialViewControllerDelegate

- (CLLocation *)location {
    return [self.delegate location];
}

- (NSString *)adUnitId {
    return [self.delegate adUnitId];
}

- (void)interstitialDidLoadAd:(MPInterstitialViewController *)interstitial {
    MPLogInfo(@"OperaResponse MRAID interstitial did load");
    [self.delegate interstitialCustomEvent:self didLoadAd:interstitial];
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialViewController *)interstitial {
    MPLogInfo(@"OperaResponse MRAID interstitial did fail");
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)interstitialWillAppear:(MPInterstitialViewController *)interstitial {
    MPLogInfo(@"OperaResponse MRAID interstitial will appear");
    [self.delegate interstitialCustomEventWillAppear:self];
}

- (void)interstitialDidAppear:(MPInterstitialViewController *)interstitial {
    MPLogInfo(@"OperaResponse MRAID interstitial did appear");
    [ORSDK trackImpression:self.adResponse];
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void)interstitialWillDisappear:(MPInterstitialViewController *)interstitial {
    MPLogInfo(@"OperaResponse MRAID interstitial will disappear");
    [self.delegate interstitialCustomEventWillDisappear:self];
}

- (void)interstitialDidDisappear:(MPInterstitialViewController *)interstitial
{
    MPLogInfo(@"OperaResponse MRAID interstitial did disappear");
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialViewController *)interstitial {
    MPLogInfo(@"OperaResponse MRAID interstitial did receive tap event");
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
}

- (void)interstitialWillLeaveApplication:(MPInterstitialViewController *)interstitial {
    MPLogInfo(@"OperaResponse MRAID interstitial will leave application");
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
}

@end