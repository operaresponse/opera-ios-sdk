//
//  AdUnit+AdType.h
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 11/1/14.
//  Copyright (c) 2014 Opera Response. All rights reserved.
//

#import "AdUnit.h"

typedef enum {
    Banner,
    MREC,
    Interstitial
} AdType;

@interface AdUnit (AdType)

+ (AdUnit *)adUnitWithType:(AdType)adType forContext:(NSManagedObjectContext *)context;

@end
