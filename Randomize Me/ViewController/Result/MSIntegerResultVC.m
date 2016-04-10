//
//  MSIntegerResultVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/2/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSIntegerResultVC.h"
#import "SWRevealViewController.h"

#import "MBProgressHUD.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface MSIntegerResultVC () <UIActionSheetDelegate>
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
    self.resultTextView.text = [self.response makeStringWithSpaceFromIntegerData];
    self.timestampLabel.text = [self.response makeStringComplitionTime];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar]; //Because when back from second view, pan guesture for menu bar must work
}

- (void)viewDidLayoutSubviews {
    [self.resultTextView setContentOffset:CGPointZero animated:NO]; //Because position of text view must be Zero
}

#pragma mark - IBAction
- (IBAction)trashButtonPressed:(id)sender {
    NSLog(@"Trash button pressed!");
}

- (IBAction)shareButtonPressed:(id)sender {
    UIActionSheet *shareActionSheet = [[UIActionSheet alloc]initWithTitle:@"What social network you want to use for sharing?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Facebook", @"Vkontakte", @"Google+", nil];
    shareActionSheet.tag = 100;
    [shareActionSheet showInView:self.view];
}

- (IBAction)copyingButtonPressed:(id)sender {
    UIActionSheet *copyingActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Copy Result to clipboard", @"Copy All to clipboard", @"Save All to URL", nil];
    copyingActionSheet.tag = 200;
    [copyingActionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 100) { //Because two action sheet. Share and coping
        if (buttonIndex == 0) { //Facebook
            [self shareWithFacebook];
        }
        else if (buttonIndex == 1) { //Vkontakte
            [self shareWithVkontakte];
        }
        else if (buttonIndex == 2) { //Google Plus
            [self shareWithGooglePlus];
        }
    }
    
    if (actionSheet.tag == 200) {
        if (buttonIndex == 0) { //Save Result to clipboard
            [self showCopyingHud];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = self.resultTextView.text;
                dispatch_async(dispatch_get_main_queue(), ^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    });
                });
            });
        }
    }
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
- (void) shareWithFacebook {
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

- (void) shareWithVkontakte {
    
}

- (void) shareWithGooglePlus {
    
}

#pragma mark - MBProgressHUD Method
- (void) showCopyingHud {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"Сopied";
}


@end
