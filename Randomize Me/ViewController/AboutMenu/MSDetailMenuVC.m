//
//  MSDetailMenuVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/16/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSDetailMenuVC.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"

@interface MSDetailMenuVC ()
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *copyingButton;

@end

@implementation MSDetailMenuVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    self.resultTextView.text = self.displayData;
    self.title = self.titleForView;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar];
    [self.resultTextView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - IBAction
- (IBAction)copyingButtonPressed:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.displayData;
    [self showCopyingHud];
    [self hideCopyingHud];
}

#pragma mark - MBProgressHUD Method
- (void) showCopyingHud {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"Сopied";
}

- (void) hideCopyingHud {
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    });
}

#pragma mark - Setup Methods
- (void) setupMenuBar {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

@end
