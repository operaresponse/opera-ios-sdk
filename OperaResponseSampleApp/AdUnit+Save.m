//
//  AdUnit+Save.m
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 11/3/14.
//  Copyright (c) 2014 Opera Response. All rights reserved.
//

@import UIKit;
@import CoreData;

#import "AppDelegate.h"
#import "AdUnit+Save.h"

@implementation AdUnit (Save)

- (void)save {
    AppDelegate* delegate = (AppDelegate* )[[UIApplication sharedApplication] delegate];
    [delegate saveContext];
}

@end
