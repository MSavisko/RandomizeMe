//
//  MSDecimalResultVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/8/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSDecimalResultVC.h"
#import "SWRevealViewController.h"

@interface MSDecimalResultVC ()
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *copyingButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@end

@implementation MSDecimalResultVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardByTap];
    [self setupMenuBar];
    self.resultTextView.text = [self.response makeStringWithSpaceFromDecimalDataWithNumber:self.decimalPlaces];
    self.timestampLabel.text = [self.response makeStringComplitionTime];
}

#pragma mark - IBAction

#pragma mark - Keyboard Methods
- (void) hideKeyboardByTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void) dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Setup Methods
- (void) setupMenuBar {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

@end
