//
//  AdUnitViewController.m
//  OperaResponseSampleApp
//
//  Created by Sumeet Parmar on 11/2/14.
//  Copyright (c) 2014 Opera Response. All rights reserved.
//

#import "AdUnitViewController.h"
#import "AdUnit+AdType.h"
#import "AdUnit+Save.h"
#import "AppDelegate.h"

const CGFloat kHorizontalMargin = 20.0f;
const CGFloat kVerticalMargin = 40.0f;

@interface AdUnitViewController () <UITextFieldDelegate>

@property (nonatomic, retain) UITextField* adUnitNameField;
@property (nonatomic, retain) UITextField* adUnitIdField;
@property (nonatomic, retain) UISegmentedControl* adTypeField;

- (void)setupLayout;
- (void)populateDefaults;
+ (AdType)adTypeForIndex:(NSInteger)index;

@end

@implementation AdUnitViewController

@synthesize adUnitNameField;
@synthesize adUnitIdField;
@synthesize adTypeField;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.adUnit) {
        self.title = @"Edit";
    } else {
        self.title = @"Add";
    }
    
    self.view.backgroundColor = [UIColor darkGrayColor];

    if (self.adUnit == nil) {
        UIBarButtonItem *addAdUnitButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(handleDone:)];
        self.navigationItem.rightBarButtonItem = addAdUnitButton;
    }
    
    [self setupLayout];
    [self populateDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        if (self.adUnit) {
            self.adUnit.title = [adUnitNameField text];
            self.adUnit.adUnitId = [adUnitIdField text];
            [self.adUnit save];
        }
    }
}

#pragma mark - Layout

- (void)setupLayout {
    CGFloat fieldWidth = self.view.bounds.size.width - 2*kHorizontalMargin;
    CGFloat fieldHeight = 44.0f;
    CGFloat originY = kVerticalMargin + self.navigationController.navigationBar.frame.size.height;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kHorizontalMargin, originY, fieldWidth, fieldHeight)];
    label.text = @"Name";
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
    adUnitNameField = [[UITextField alloc] initWithFrame:CGRectMake(kHorizontalMargin, label.frame.origin.y + label.frame.size.height, fieldWidth, fieldHeight)];
    adUnitNameField.delegate = self;
    adUnitNameField.backgroundColor = [UIColor lightGrayColor];
    adUnitNameField.textColor = [UIColor blackColor];
    adUnitNameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    adUnitNameField.leftViewMode = UITextFieldViewModeAlways;
    [adUnitNameField setReturnKeyType:UIReturnKeyNext];
    
    [self.view addSubview:adUnitNameField];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(kHorizontalMargin, adUnitNameField.frame.origin.y + adUnitNameField.frame.size.height, fieldWidth, fieldHeight)];
    label.text = @"Ad Unit Id";
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
    adUnitIdField = [[UITextField alloc] initWithFrame:CGRectMake(kHorizontalMargin, label.frame.origin.y + label.frame.size.height, fieldWidth, fieldHeight)];
    adUnitIdField.delegate = self;
    adUnitIdField.backgroundColor = [UIColor lightGrayColor];
    adUnitIdField.textColor = [UIColor blackColor];
    adUnitIdField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    adUnitIdField.leftViewMode = UITextFieldViewModeAlways;
    [adUnitIdField setReturnKeyType:UIReturnKeyDone];
    
    [self.view addSubview:adUnitIdField];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(kHorizontalMargin, adUnitIdField.frame.origin.y + adUnitIdField.frame.size.height, fieldWidth, fieldHeight)];
    label.text = @"Ad Format";
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Banner", @"MREC", @"Interstitial", nil];
    self.adTypeField = [[UISegmentedControl alloc] initWithItems:itemArray];
    [adTypeField setFrame:CGRectMake(kHorizontalMargin, label.frame.origin.y + label.frame.size.height, fieldWidth, fieldHeight)];
    adTypeField.segmentedControlStyle = UISegmentedControlStylePlain;
    [adTypeField addTarget:self action:@selector(handleAdTypeSelection:) forControlEvents: UIControlEventValueChanged];
    adTypeField.selectedSegmentIndex = 0;
    [self.view addSubview:adTypeField];
}

- (void)populateDefaults {
    if (self.adUnit) {
        adUnitNameField.text = self.adUnit.title;
        adUnitIdField.text = self.adUnit.adUnitId;
        adTypeField.selectedSegmentIndex = [self.adUnit.adType intValue];
    }
}

#pragma mark - Segmented Control

- (void)handleAdTypeSelection:(UISegmentedControl *)segment {
    AdType adType = [AdUnitViewController adTypeForIndex:segment.selectedSegmentIndex];
    self.adUnit.adType = [NSNumber numberWithInt:adType];
}

+ (AdType)adTypeForIndex:(NSInteger)index {
    AdType adType = Banner;
    
    switch (index) {
        case 0:
            adType = Banner;
            break;
        case 1:
            adType = MREC;
            break;
        case 2:
            adType = Interstitial;
        default:
            break;
    }
    return adType;
}

#pragma mark - Handle Done button

- (void)handleDone:(id)sender {
    NSString* adName = adUnitNameField.text;
    NSString* adUnitId = adUnitIdField.text;
    AdType adType = [AdUnitViewController adTypeForIndex:adTypeField.selectedSegmentIndex];
    
    if (adName && adUnitId) {
        AppDelegate* delegate = (AppDelegate* )[[UIApplication sharedApplication] delegate];
        self.adUnit = [AdUnit adUnitWithType:adType forContext:delegate.managedObjectContext];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Manage Keyboard

#define kOFFSET_FOR_KEYBOARD 60.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

//-(void)textFieldDidBeginEditing:(UITextField *)sender {
////    if ([sender isEqual:mailTf])
////    {
//        //move the main view, so that the keyboard does not hide it.
//        if  (self.view.frame.origin.y >= 0)
//        {
//            [self setViewMovedUp:YES];
//        }
////    }
//}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == adUnitNameField) {
        [textField resignFirstResponder];
        [adUnitIdField becomeFirstResponder];
    } else if (textField == adUnitIdField) {
        // here you can define what happens
        // when user presses return on the email field
        [textField resignFirstResponder];
        [adTypeField becomeFirstResponder];
    }
    return YES;
}

@end
