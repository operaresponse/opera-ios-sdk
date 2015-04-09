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
#import <OperaResponse/ORVastXMLConfiguration.h>
#import <OperaResponse/ORVastConfigurationManager.h>

#import "ORMediaworksInterstitialCustomEvent.h"
#import "ORMediaworksVastViewController.h"

@interface ORMediaworksInterstitialCustomEvent()

@property (nonatomic, strong) MPInterstitialViewController *interstitial;
@property (nonatomic, strong) ORAdResponse *adResponse;
@property (copy) ORAdRequestCompletionBlock block;

@end

@implementation ORMediaworksInterstitialCustomEvent

- (id)init {
    self = [super init];
    
    if (self) {
        __weak ORMediaworksInterstitialCustomEvent *weakSelf = self;
        
        if (weakSelf) {
            weakSelf.block = ^(ORAdResponse *response) {
                if (response) {
                    weakSelf.adResponse = response;
                    
                    if (weakSelf.adResponse.vast == YES) {
                        ORVastConfigurationManager *vcm = [[ORVastConfigurationManager alloc] initManagerWithXML:weakSelf.adResponse.creative];
                        [vcm aggregateVastConfigurationWithCompletion:^(ORVastVideoConfiguration *vc) {
                            MPAdConfiguration *configuration = [weakSelf.delegate configuration];
                            weakSelf.interstitial = [[ORMediaworksVastViewController alloc] initWithAdConfiguration:configuration
                                                                                    withVastConfiguration:vc];
                            weakSelf.interstitial.delegate = weakSelf;
                            [weakSelf.delegate interstitialCustomEvent:weakSelf didLoadAd:weakSelf.interstitial];
                        }];
                    } else {
                        MPAdConfiguration *configuration = [weakSelf.delegate configuration];
                        configuration.adResponseData = [response.creative dataUsingEncoding:NSUTF8StringEncoding];
                        
                        weakSelf.interstitial = [[MPInstanceProvider sharedProvider] buildMPMRAIDInterstitialViewControllerWithDelegate:weakSelf configuration:configuration];
                        [(MPMRAIDInterstitialViewController *)weakSelf.interstitial startLoading];
                        [weakSelf.delegate interstitialCustomEvent:weakSelf didLoadAd:weakSelf.interstitial];
                    }
                } else {
                    [weakSelf.delegate interstitialCustomEvent:weakSelf didFailToLoadAdWithError:nil];
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
    //[self.delegate interstitialCustomEvent:self didLoadAd:self.interstitial];
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