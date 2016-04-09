//
//  MSIntegerResultVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/2/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSIntegerResultVC.h"
#import "SWRevealViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface MSIntegerResultVC ()
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *copyingButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@end

@implementation MSIntegerResultVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardByTap];
    [self addFacebookShare];
    self.resultTextView.text = [self.response makeStringWithSpaceFromIntegerData];
    self.timestampLabel.text = [self.response makeStringComplitionTime];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar]; //Because when back from second view, pan guesture menu not work
}

#pragma mark - IBAction
- (IBAction)trashButtonPressed:(id)sender {
    NSLog(@"Trash button pressed!");
}
- (IBAction)shareButtonPressed:(id)sender {
    NSURL *contentURL = [[NSURL alloc] initWithString:
                         @"https://www.random.org/integers/"];
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc]init];
    content.contentURL = contentURL;
    content.imageURL = nil;
    content.contentDescription = @"Integer Generation result by Randomize Me";
    
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];
}

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
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

#pragma mark - Shared Method
- (void) addFacebookShare {
    
}


@end
