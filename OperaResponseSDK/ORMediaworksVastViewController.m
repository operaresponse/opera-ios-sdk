//
//  ORMediaworksVastViewController.m
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 4/7/15.
//  Copyright (c) 2015 Opera Response. All rights reserved.
//

#import "ORMediaworksVastViewController.h"
#import <OperaResponse/ORSDK.h>
#import <OperaResponse/ORVastViewController.h>

#import "MPAdConfiguration.h"

@interface ORMediaworksVastViewController ()

@property (nonatomic, strong) MPAdConfiguration *adConfiguration;
@property (nonatomic, strong) ORVastViewController *vastViewController;
@property (nonatomic, assign) BOOL advertisementHasCustomCloseButton;

@end

@implementation ORMediaworksVastViewController

- (instancetype)initWithAdConfiguration:(MPAdConfiguration *)adConfiguration
                  withVastConfiguration:(ORVastVideoConfiguration *)vastConfiguration {
    
    self = [super init];
    
    if (self) {
        self.adConfiguration = adConfiguration;
        self.orientationType = adConfiguration.orientationType;
        self.advertisementHasCustomCloseButton = NO;
        self.vastViewController = [[ORVastViewController alloc] initWithVastConfiguration:vastConfiguration];
        [self.view addSubview:self.vastViewController.view];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Orientation

- (BOOL)shouldAutorotate {
    BOOL retval = NO;
    
    NSArray *supportedOrientations = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UISupportedInterfaceOrientations"];
    for (NSUInteger i = 0; i < supportedOrientations.count; i++) {
        NSString *str = [supportedOrientations objectAtIndex:i];
        UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
        
        if ([@"UIInterfaceOrientationPortrait" compare:str] == NSOrderedSame) {
            orientation = UIInterfaceOrientationPortrait;
        } else if ([@"UIInterfaceOrientationLandscapeLeft" compare:str] == NSOrderedSame) {
            orientation = UIInterfaceOrientationLandscapeLeft;
        } else if ([@"UIInterfaceOrientationLandscapeRight" compare:str] == NSOrderedSame) {
            orientation = UIInterfaceOrientationLandscapeRight;
        }
        
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            retval = YES;
            break;
        }
    }
    
    return retval;
}

- (NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - VAST control

- (void)startLoading {
    [self.vastViewController startLoading];
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(interstitialDidLoadAd:)]) {
        [self.delegate interstitialDidLoadAd:self];
    } else {
        NSLog(@"NO DELEGATE");
    }
}

#pragma mark - Close Button

- (BOOL)shouldDisplayCloseButton {
    return !self.advertisementHasCustomCloseButton;
}

- (void)closeButtonPressed {
    [self.vastViewController stop];
    [self dismissInterstitialAnimated:YES];
}

#pragma mark - Presentation

- (void)willPresentInterstitial {
    [self startLoading];
    [self.vastViewController play];
    
    if ([self.delegate respondsToSelector:@selector(interstitialWillAppear:)]) {
        [self.delegate interstitialWillAppear:self];
    }
}

- (void)didPresentInterstitial {
    //[self.interstitialView enableRequestHandling];
    if ([self.delegate respondsToSelector:@selector(interstitialDidAppear:)]) {
        [self.delegate interstitialDidAppear:self];
    }
}

- (void)willDismissInterstitial {
    //[self.interstitialView disableRequestHandling];
    if ([self.delegate respondsToSelector:@selector(interstitialWillDisappear:)]) {
        [self.delegate interstitialWillDisappear:self];
    }
}

- (void)didDismissInterstitial {
    if ([self.delegate respondsToSelector:@selector(interstitialDidDisappear:)]) {
        [self.delegate interstitialDidDisappear:self];
    }
}

@end
