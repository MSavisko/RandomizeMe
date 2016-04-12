//
//  MSStringsGeneratorVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/12/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSStringsGeneratorVC.h"

#import "SWRevealViewController.h"
#import "MSRandomStringsRequest.h"
#import "MSRandomResponse.h"
#import "MSHTTPClient.h"
#import "MBProgressHUD.h"

@interface MSStringsGeneratorVC () <UITextFieldDelegate, MSHTTPClientDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;
@property (weak, nonatomic) IBOutlet UITextField *numberOfStrings;
@property (weak, nonatomic) IBOutlet UITextField *charactersLength;
@property (weak, nonatomic) IBOutlet UISwitch *digitsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *uppercaseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lowercaseSwitch;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;

@end

@implementation MSStringsGeneratorVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardByTap];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar]; //Because when back from second view, pan guesture menu not work
}

#pragma mark - Keyboard Methods
-(void) dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Setup Methods
- (void) hideKeyboardByTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void) setupMenuBar {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.menuButtonItem setTarget: self.revealViewController];
        [self.menuButtonItem setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

@end
