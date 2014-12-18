//
//  ORAdRequestResult.h
//  OperaResponseSDK
//
//  Created by Sumeet Parmar on 11/1/14.
//  Copyright (c) 2014 Opera Response. All rights reserved.
//

@import Foundation;
#import <CoreGraphics/CGGeometry.h>

@interface ORAdResponse : NSObject

@property (retain, nonatomic, readonly) NSString *creative;
@property (nonatomic, readonly) CGRect frame;

@end