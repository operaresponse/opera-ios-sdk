//
//  AdUnit.h
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 11/2/14.
//  Copyright (c) 2014 Opera Response. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AdUnit : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * adUnitId;
@property (nonatomic, retain) NSNumber * adType;
@property (nonatomic, retain) NSDate * createdAt;

@end
