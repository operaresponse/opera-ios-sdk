//
//  ORSDK.h
//  OperaResponseSDK
//
//  Created by Sumeet Parmar on 11/1/14.
//  Copyright (c) 2014 Opera Response. All rights reserved.
//

@import Foundation;
//#import <OperaResponse/ORAdResponse.h>
#import "ORAdResponse.h"

typedef void (^ORAdRequestCompletionBlock)(ORAdResponse *);

@interface ORSDK : NSObject

+ (void)requestAdWithInfo:(NSDictionary *)info completionBlock:(ORAdRequestCompletionBlock)block;
+ (void)requestInterstitialWithInfo:(NSDictionary *)info completionBlock:(ORAdRequestCompletionBlock)block;
+ (void)trackImpression:(ORAdResponse *)response;

@end