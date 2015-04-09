//
//  ORVastConfiguration.h
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 1/8/15.
//  Copyright (c) 2015 Opera Response. All rights reserved.
//

@import Foundation;

@class ORVastCompanionAd;

@interface ORVastXMLConfiguration : NSObject

@property (nonatomic, retain, readonly) NSString *adId;
@property (nonatomic, retain, readonly) NSArray *impressionTrackers;
@property (nonatomic, retain, readonly) NSArray *startTrackers;
@property (nonatomic, retain, readonly) NSArray *firstQuartileTrackers;
@property (nonatomic, retain, readonly) NSArray *midpointTrackers;
@property (nonatomic, retain, readonly) NSArray *thirdQuartileTrackers;
@property (nonatomic, retain, readonly) NSArray *completeTrackers;
@property (nonatomic, retain, readonly) NSArray *clickTrackers;
@property (nonatomic, retain, readonly) NSString *clickThroughUrl;
@property (nonatomic, retain, readonly) NSString *networkMediaFileUrl;
@property (nonatomic, retain, readonly) NSString *diskMediaFileUrl;
@property (nonatomic, retain, readonly) NSString *vastAdTagURI;
@property (nonatomic, retain, readonly) ORVastCompanionAd *vastCompanionAd;

+ (ORVastXMLConfiguration *)configurationFromXML:(NSString *)xmlString;

@end