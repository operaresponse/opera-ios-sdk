//
//  ViewController.h
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 11/1/14.
//  Copyright (c) 2014 Opera Response. All rights reserved.
//

@import UIKit;
@import CoreData;

#import "MPInterstitialAdController.h"

@interface MainViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

