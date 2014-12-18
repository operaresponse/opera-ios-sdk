//
//  AdUnit+AdType.m
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 11/1/14.
//  Copyright (c) 2014 Opera Response. All rights reserved.
//

#import "AdUnit+AdType.h"

@implementation AdUnit (AdType)

+ (AdUnit *)adUnitWithType:(AdType)adType forContext:(NSManagedObjectContext *)context {
    AdUnit *adUnit = [NSEntityDescription insertNewObjectForEntityForName:@"AdUnit" inManagedObjectContext:context];
    adUnit.adType = [NSNumber numberWithInt:adType];
    adUnit.createdAt = [NSDate date];
    return adUnit;
}

@end
