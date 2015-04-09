//
//  ORVastVideoConfiguration.h
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 1/9/15.
//  Copyright (c) 2015 Opera Response. All rights reserved.
//

@import Foundation;

@class ORVastCompanionAd;

typedef enum {
    VastVideoTrackerTypeImpression,
    VastVideoTrackerTypeStart,
    VastVideoTrackerTypeFirstQuartile,
    VastVideoTrackerTypeMidpoint,
    VastVideoTrackerTypeThirdQuartile,
    VastVideoTrackerTypeComplete,
    VastVideoTrackerTypeClick
} VastVideoTrackerType;

@interface ORVastVideoConfiguration : NSObject

@property (nonatomic, retain, readonly) NSArray *impressionTrackers;
@property (nonatomic, retain, readonly) NSArray *startTrackers;
@property (nonatomic, retain, readonly) NSArray *firstQuartileTrackers;
@property (nonatomic, retain, readonly) NSArray *midpointTrackers;
@property (nonatomic, retain, readonly) NSArray *thirdQuartileTrackers;
@property (nonatomic, retain, readonly) NSArray *completeTrackers;
@property (nonatomic, retain, readonly) NSArray *clickTrackers;
@property (nonatomic, retain, readonly) NSString *clickThroughUrl;
@property (nonatomic, retain, readonly) NSString *mediaUrl;
@property (nonatomic, retain, readonly) NSURL *diskUrl;
@property (nonatomic, retain, readonly) ORVastCompanionAd *vastCompanionAd;

- (void)addTrackers:(NSArray *)trackers forTrackerType:(VastVideoTrackerType)trackerType;
- (void)setClickThroughUrl:(NSString *)clickThroughUrl;
- (void)setMediaUrl:(NSString *)mediaUrl;
- (void)setDiskUrl:(NSURL *)diskUrl;
- (void)setVastCompanionAd:(ORVastCompanionAd *)vastCompanionAd;

@end
