//
//  MSDecimalResultVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/8/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSDecimalResultVC.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import <Social/Social.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <VK-ios-sdk/VKSdk.h>

@interface MSDecimalResultVC () <UIActionSheetDelegate, UIAlertViewDelegate, VKSdkUIDelegate>
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
    [self setupVkDelegate];
    self.resultTextView.text = [self stringResultWithNumber:self.decimalPlaces];
    self.timestampLabel.text = [self stringComplitionTime];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar];
}

- (void)viewDidLayoutSubviews {
    [self.resultTextView setContentOffset:CGPointZero animated:NO]; //Because position of text view must be Zero
}

#pragma mark - SetupMethods
- (void) setupMenuBar {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

- (void) setupVkDelegate {
    [[VKSdk initializeWithAppId:@"5408231"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
}

#pragma mark - IBAction
- (IBAction)trashButtonPressed:(id)sender {
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setValue:@"" forPasteboardType:UIPasteboardNameGeneral];
    [self showDeletingHud];
    [self hideDeletingHud];
}

- (IBAction)infoButtonPressed:(id)sender {
    NSString *message = [NSString stringWithFormat:@"Serial: %ld\nCompletion Time: %@\n", (long)self.response.serialNumber, [self stringComplitionTime]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Decimal Generation"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)shareButtonPressed:(id)sender {
    UIActionSheet *shareActionSheet = [[UIActionSheet alloc]initWithTitle:@"What social network you want to use for sharing?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Facebook", @"Vkontakte", @"Twitter", nil];
    shareActionSheet.tag = 100;
    [shareActionSheet showInView:self.view];
}

- (IBAction)copyingButtonPressed:(id)sender {
    UIActionSheet *copyingActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                   delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Copy Result to clipboard", @"Copy All to clipboard", nil];
    copyingActionSheet.tag = 200;
    [copyingActionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Because two action sheet
    //Share
    if (actionSheet.tag == 100) {
        if (buttonIndex == 0) { //Facebook
            [self showAlertWithMessage:@"All result was copied to clipboard. Use paste for share!" tag:400];
        }
        else if (buttonIndex == 1) { //Vkontakte
            NSArray *scope = @[VK_PER_WALL];
            [VKSdk wakeUpSession:scope completeBlock:^(VKAuthorizationState state, NSError *error) {
                if (state == VKAuthorizationAuthorized) {
                    [self shareWithVkontakte];
                } else if (error) {
                    [[[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                }
                else {
                    [VKSdk authorize:scope];
                }
            }];
        }
        else if (buttonIndex == 2) { //Twitter
            if ([self stringResultWithNumber:self.decimalPlaces].length > 115) {
                [self showAlertWithMessage:@"The result is too long to send the tweet. You will need to manually cut it!" tag:500];
            } else {
                [self shareWithTwitter];
            }
        }
    }
    //Copying
    if (actionSheet.tag == 200) {
        if (buttonIndex == 0) { //Copy Result to clipboard
            [self showCopyingHud];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = [self stringResultWithNumber:self.decimalPlaces];
                [self hideCopyingHud];
            });
        }
        else if (buttonIndex == 1) { //Copy All to clipboard
            [self showCopyingHud];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = [self stringResultForShare];
                [self hideCopyingHud];
            });
        }
        else if (buttonIndex == 2) { //Save All to URL
            
        }
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 400) {
        [self shareWithFacebook];
    }
    if (alertView.tag == 500) {
        [self shareWithTwitter];
    }
}

#pragma mark - VKSdkUI Delegate
- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self];
}

#pragma mark - VKSdk Delegate
- (void)vkSdkUserAuthorizationFailed {
    [[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    [self.navigationController popToViewController:self animated:YES];
}

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self shareWithVkontakte];
        });
    } else if (result.error) {
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Access denied!"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
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

#pragma mark - Share Method
- (void) shareWithFacebook {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self stringResultForShare];
    NSURL *contentURL = [[NSURL alloc] initWithString:
                         @"https://www.random.org/decimal-fractions/"];
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc]init];
    content.contentURL = contentURL;
    content.imageURL = nil;
    content.contentDescription = @"Decimal Fraction Generation result by Randomize Me";
    
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];
}

- (void) shareWithVkontakte {
    VKShareDialogController *shareDialog = [VKShareDialogController new];
    shareDialog.text = [self stringResultForShare];
    shareDialog.shareLink = [[VKShareLink alloc] initWithTitle:@"Full Result of Decimal Fraction Generation" link:[NSURL URLWithString:@"https://www.random.org/decimal-fractions/"]];
    [shareDialog setCompletionHandler:^(VKShareDialogController *dialog, VKShareDialogControllerResult result) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:shareDialog animated:YES completion:nil];
}

- (void) shareWithTwitter {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweet setInitialText:[self stringResultWithNumber:self.decimalPlaces]];
        [tweet addURL:[NSURL URLWithString:@"https://www.random.org/decimal-fractions/"]];
        [tweet setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             if (result == SLComposeViewControllerResultCancelled)
             {
                 //The user cancelled
             }
             else if (result == SLComposeViewControllerResultDone)
             {
                 //The user sent the tweet
             }
         }];
        [self presentViewController:tweet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
                                                        message:@"Twitter integration is not available. A Twitter account must be set up on your device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
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

- (void) showDeletingHud {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"Deleted";
}

- (void) hideDeletingHud {
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

#pragma mark - Helper Methods
- (void) showAlertWithMessage:(NSString*)message tag:(NSInteger)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}

#pragma mark - Presentation Data Method
- (NSString*) stringResultWithNumber: (NSInteger)number {
    NSMutableString *mutableResult = [[NSMutableString alloc]init];
    for (NSInteger i=0; i < self.response.data.count; i++) {
        NSNumber *elementNumber = self.response.data[i];
        
        //Rounding, because of some double much longer than other
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:number];
        [formatter setRoundingMode: NSNumberFormatterRoundUp];
        NSString *numberString = [formatter stringFromNumber:elementNumber];
        
        //Appending, because we need space between result number
        [mutableResult appendString:[NSString stringWithFormat:@"%@ ", numberString]];
    }
    return mutableResult;
}

- (NSString*) stringComplitionTime {
    return [self.response.completionTime substringToIndex:self.response.completionTime.length-1];
}

- (NSString*) stringResultForShare {
    NSString *resultName = @"Decimal Fraction Generation";
    NSString *forResult = @"Result:";
    NSString *resultData = [self stringResultWithNumber:self.decimalPlaces];
    
    NSString *parametrs = @"Parameters of generation:";
    NSString *numberOfDecimals = [NSString stringWithFormat:@"Number of decimals: %@", self.response.responseBody[@"result"][@"random"][@"n"]];
    
    NSString *decimalPlaces = [NSString stringWithFormat:@"Decimal places: %@", self.response.responseBody[@"result"][@"random"][@"decimalPlaces"]];
    
    NSString *replacement = @"Unique decimals: YES";
    
    NSString *individualInformation = @"Individual information of generation:";
    NSString *completionTime = [NSString stringWithFormat:@"Completion time (UTC+0): %@", [self stringComplitionTime]];
    NSString *serialNumber = [NSString stringWithFormat:@"Serial Number: %ld", (long)self.response.serialNumber];
    NSString *signature = [NSString stringWithFormat:@"Signature: %@", self.response.signature];
    
    NSString *result = [NSString stringWithFormat:@"%@\n\n%@\n%@\n\n%@\n%@\n%@\n%@\n\n%@\n%@\n%@\n%@", resultName, forResult, resultData, parametrs, numberOfDecimals, decimalPlaces, replacement, individualInformation, completionTime, serialNumber, signature];
    
    return result;
}

@end
