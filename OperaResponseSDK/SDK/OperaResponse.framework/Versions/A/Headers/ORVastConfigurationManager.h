//
//  ORVastConfigurationManager.h
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 1/8/15.
//  Copyright (c) 2015 Opera Response. All rights reserved.
//

@import Foundation;

@class ORVastVideoConfiguration;

typedef void (^ORVastAggregateCompletionBlock)(ORVastVideoConfiguration *);

@interface ORVastConfigurationManager : NSObject

- (id)initManagerWithXML:(NSString *)xml;
- (void)aggregateVastConfigurationWithCompletion:(ORVastAggregateCompletionBlock)block;

@end
