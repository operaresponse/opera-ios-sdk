//
//  ORVastCompanionAd.h
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 1/8/15.
//  Copyright (c) 2015 Opera Response. All rights reserved.
//

@import Foundation;

@interface ORVastCompanionAd : NSObject

@property (nonatomic, readonly) float width;
@property (nonatomic, readonly) float height;
@property (nonatomic, retain, readonly) NSString *imageUrl;
@property (nonatomic, retain, readonly) NSString *clickThroughUrl;
@property (nonatomic, retain, readonly) NSArray *clickTrackers;

@end
