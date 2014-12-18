//
//  ViewController.m
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 11/1/14.
//  Copyright (c) 2014 Opera Response. All rights reserved.
//

#import "MainViewController.h"
#import "AdUnit.h"
#import "AdUnit+AdType.h"
#import "BannerDetailViewController.h"
#import "MPInterstitialAdController.h"
#import "AdUnitViewController.h"

@interface MainViewController () <MPInterstitialAdControllerDelegate>

@property (nonatomic, retain) MPInterstitialAdController *interstitial;
- (void) loadInterstitial:(NSString* )adUnitId;

@end

@implementation MainViewController

@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize interstitial;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Ad Units";
    
    UIBarButtonItem *addAdUnitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleAddAdUnit:)];
    self.navigationItem.rightBarButtonItem = addAdUnitButton;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
}

- (void)viewDidUnload {
    self.fetchedResultsController = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.tableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"AdUnit" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    AdUnit *adUnit = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = adUnit.title;
    cell.detailTextLabel.text = adUnit.adUnitId;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Long press
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    [cell addGestureRecognizer:lpgr];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AdUnit *adUnit = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    int adType = [adUnit.adType intValue];
    
    if (adType == Banner || adType == MREC) {
        BannerDetailViewController* c = [[BannerDetailViewController alloc] init];
        c.adUnit = adUnit;
        [self.navigationController pushViewController:c animated:YES];
    } else if (adType == Interstitial) {
        [self loadInterstitial:adUnit.adUnitId];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Interstitial

- (void) loadInterstitial:(NSString* )adUnitId {
    self.interstitial = [MPInterstitialAdController
                         interstitialAdControllerForAdUnitId:adUnitId];
    
    // Fetch the interstitial ad.
    self.interstitial.delegate = self;
    [self.interstitial loadAd];
}

#pragma mark - MPInterstitialAdControllerDelegate

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidLoadAd");
    if (self.interstitial.ready) {
        [self.interstitial showFromViewController:self];
    }
    else {
        // The interstitial wasn't ready, so continue as usual.
        NSLog(@"interstitial not ready");
    }
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidFailToLoadAd");
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialWillAppear");
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidAppear");
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialWillDisappear");
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidDisappear");
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidExpire");
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidReceiveTapEvent");
}

#pragma mark - Long Press

- (void)handleLongPress:(UILongPressGestureRecognizer* )gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else {
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            NSLog(@"UIGestureRecognizerStateEnded");
            //Do Whatever You want on End of Gesture
        }
        else if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
            AdUnitViewController *c = [[AdUnitViewController alloc] init];
            c.adUnit = [_fetchedResultsController objectAtIndexPath:indexPath];
            [self.navigationController pushViewController:c animated:YES];
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcement" message: @"You have long-pressed the row...!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            [alert release];
//            NSLog(@"UIGestureRecognizerStateBegan.");
//            
//            
//            NSLog(@"long press on table view at row %d", indexPath.row);
//            
//            // Update ToDoStatus
//            [self.tableView reloadData];
            //Do Whatever You want on Began of Gesture
        }
    }
}

#pragma mark - Handle add ad-unit

- (void)handleAddAdUnit:(id)sender {
    AdUnitViewController *c = [[AdUnitViewController alloc] init];
    c.adUnit = nil;
    [self.navigationController pushViewController:c animated:YES];
}

@end
