//
//  ORMediaworksBannerCustomEvent.m
//  Motorgator
//
//  Created by Sumeet Parmar on 10/16/14.
//  Copyright (c) 2014 Sumeet Parmar. All rights reserved.
//

// MoPub
#import "MPInstanceProvider.h"
#import "MPAdConfiguration.h"
#import "MRController.h"
#import "MPLogging.h"

// Opera
#import <OperaResponse/ORSDK.h>
#import "ORMediaworksBannerCustomEvent.h"

@interface ORMediaworksBannerCustomEvent () <MRControllerDelegate>

@property (nonatomic, strong) ORAdResponse *response;
@property (copy) ORAdRequestCompletionBlock block;
@property (nonatomic, strong) MRController *mraidController;

@end

@implementation ORMediaworksBannerCustomEvent

@synthesize response;
@synthesize delegate;
@synthesize mraidController;

- (id) init {
    self = [super init];
    
    if (self) {
        __weak ORMediaworksBannerCustomEvent *ref = self;
        
        ref.block = ^(ORAdResponse *adResponse) {
            if (adResponse) {
                if (ref) {
                    ref.response = adResponse;
                    
                    MPAdConfiguration *configuration = [self.delegate configuration];
                    configuration.adResponseData = [adResponse.creative dataUsingEncoding:NSUTF8StringEncoding];
                    
                    CGRect adViewFrame = CGRectZero;
                    if ([configuration hasPreferredSize]) {
                        adViewFrame = CGRectMake(0, 0, configuration.preferredSize.width,
                                                 configuration.preferredSize.height);
                    }
                    
                    self.mraidController = [[MPInstanceProvider sharedProvider] buildBannerMRControllerWithFrame:adViewFrame delegate:ref];
                    [self.mraidController loadAdWithConfiguration:configuration];
                    
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
    self.delegate = nil;
}

- (void) requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info {
    MPLogInfo(@"OperaResponse requestAdWithSize(), size = %@, info = %@", NSStringFromCGSize(size), info);
    [ORSDK requestAdWithInfo:info completionBlock:self.block];
}

#pragma mark - MRControllerDelegate

- (CLLocation *)location
{
    return [self.delegate location];
}

- (NSString *)adUnitId
{
    return [self.delegate adUnitId];
}

- (MPAdConfiguration *)adConfiguration
{
    return [self.delegate configuration];
}

- (UIViewController *)viewControllerForPresentingModalView
{
    return [self.delegate viewControllerForPresentingModalView];
}

- (void)adDidLoad:(UIView *)adView
{
    MPLogInfo(@"MoPub MRAID banner did load");
    [self.delegate bannerCustomEvent:self didLoadAd:adView];
    [ORSDK trackImpression:self.response];
}

- (void)adDidFailToLoad:(UIView *)adView
{
    MPLogInfo(@"MoPub MRAID banner did fail");
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)closeButtonPressed
{
    //don't care
}

- (void)appShouldSuspendForAd:(UIView *)adView
{
    MPLogInfo(@"MoPub MRAID banner will begin action");
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void)appShouldResumeFromAd:(UIView *)adView
{
    MPLogInfo(@"MoPub MRAID banner did end action");
    [self.delegate bannerCustomEventDidFinishAction:self];
}


@end