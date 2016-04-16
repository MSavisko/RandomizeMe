//
//  MSLoteryTicketGenerator.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/16/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSLotteryQuickPickVC.h"
#import "SWRevealViewController.h"
#import "LotteryQuickPick.h"
#import "MSRandomIntegerRequest.h"
#import "MSRandomResponse.h"
#import "MSHTTPClient.h"

#import "MBProgressHUD.h"

#import <Social/Social.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <VK-ios-sdk/VKSdk.h>

@interface MSLotteryQuickPickVC () <UIPickerViewDataSource, UIPickerViewDelegate, MSHTTPClientDelegate, UIActionSheetDelegate, UIAlertViewDelegate, VKSdkUIDelegate, VKSdkDelegate>
@property (strong, nonatomic) NSArray *loteryNames;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *copyingButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;
@property (weak, nonatomic) IBOutlet UIButton *pickTicketButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buyButton;
@property (strong, nonatomic) NSString *chosenLoteryName;
@property (strong, nonatomic) MSRandomResponse *response;
@property (strong, nonatomic) LotteryQuickPick *ticket;
@end

@implementation MSLotteryQuickPickVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self setupPickerView];
    [self setupVkDelegate];
    [self.shareButton setEnabled:NO];
    [self.copyingButton setEnabled:NO];
    [self.buyButton setEnabled:NO];
    self.loteryNames = @[@"Keno", @"Megalot", @"National Lottery"];
    self.chosenLoteryName = @"Keno";
    self.ticketLabel.textColor = [UIColor lightGrayColor];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar];
}

#pragma mark - IBAction
- (IBAction)pickTicketPressed:(id)sender {
    self.ticket = [[LotteryQuickPick alloc]initWithName:self.chosenLoteryName];
    MSRandomIntegerRequest *ticketRequest = [self.ticket request];
    MSHTTPClient *client = [MSHTTPClient sharedClient];
    [client setDelegate:self];
    [client sendRequest:[ticketRequest requestBody]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)infoButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lottery Quick Pick"
                                                    message:@"This form allows you to quick pick lottery tickets. The randomness comes from atmospheric noise, which for many purposes is better than the pseudo-random number algorithms typically used in computer programs."
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
- (IBAction)buyButtonPressed:(id)sender {
    if ([self.ticket.name isEqualToString:@"Keno"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://lottery.com.ua/ru/lottery/keno/play.htm"]];
    }
    else if ([self.ticket.name isEqualToString:@"Megalot"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://msl.ua/uk/megalot"]];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://lottery.com.ua/ru/lottery/sloto/play.htm"]];
    }
    
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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
            if ([self stringResult].length > 115) {
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
                pasteboard.string = [self stringResult];
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
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 400) {
        [self shareWithFacebook];
    }
    if (alertView.tag == 500) {
        [self shareWithTwitter];
    }
}

#pragma mark - VKSdkUIDelegate
- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self];
}

#pragma mark - VKSdkDelegate
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

#pragma mark - MSHTTPClientDelegate
- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didSucceedWithResponse:(id)responseObject {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.response = [[MSRandomResponse alloc]init];
    [self.response parseResponseFromData:responseObject];
    if (!self.response.error) {
        self.ticketLabel.text = [self.ticket pickFromResponse:self.response];
        self.ticketLabel.textColor = [UIColor blackColor];
        [self.shareButton setEnabled:YES];
        [self.copyingButton setEnabled:YES];
        [self.buyButton setEnabled:YES];
    } else {
        [self showAlertWithMessage:[self.response parseError]];
    }
}

- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didFailWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showAlertWithMessage:@"Could not connect to the generation server. Please check your Internet connection or try later!"];
}

#pragma mark PickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.loteryNames.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.loteryNames[row];
}

#pragma mark PickerViewDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.chosenLoteryName = self.loteryNames[row];
}

#pragma mark - ShareMethod
- (void) shareWithFacebook {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self stringResultForShare];
    NSURL *contentURL = [[NSURL alloc] initWithString:
                         @"https://www.random.org/quick-pick/"];
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc]init];
    content.contentURL = contentURL;
    content.imageURL = nil;
    content.contentDescription = @"Lottery Quick Pick result by Randomize Me";
    
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];
}

- (void) shareWithVkontakte {
    VKShareDialogController *shareDialog = [VKShareDialogController new];
    shareDialog.text = [self stringResultForShare];
    shareDialog.shareLink = [[VKShareLink alloc] initWithTitle:@"Full Result of Lottery Quick Pick" link:[NSURL URLWithString:@"https://www.random.org/quick-pick/"]];
    [shareDialog setCompletionHandler:^(VKShareDialogController *dialog, VKShareDialogControllerResult result) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:shareDialog animated:YES completion:nil];
}

- (void) shareWithTwitter {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *text = [NSString stringWithFormat:@"Lotery '%@' Quick Pick result:\n%@", self.ticket.name, [self stringResult]];
        [tweet setInitialText:text];
        [tweet addURL:[NSURL URLWithString:@"https://www.random.org/quick-pick/"]];
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

#pragma mark - SetupMethods
- (void) setupMenuBar {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.menuButton setTarget: self.revealViewController];
        [self.menuButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

- (void) setupPickerView {
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

- (void) setupVkDelegate {
    [[VKSdk initializeWithAppId:@"5408231"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
}

#pragma mark - MBProgressHUDMethod
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

#pragma mark - HelperMethods
- (void) showAlertWithMessage:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) showAlertWithMessage:(NSString*)message tag:(NSInteger)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}

#pragma mark - PresentationDataMethod
- (NSString*) stringResult {
    return [self.ticket pickFromResponse:self.response];
}

- (NSString*) stringComplitionTime {
    return [self.response.completionTime substringToIndex:self.response.completionTime.length-1];
}

- (NSString*) stringResultForShare {
    NSString *resultName = @"Lottery Quick Pick";
    NSString *forResult = @"Result:";
    NSString *resultData = [self stringResult];
    
    NSString *parametrs = @"Parameters of pick";
    NSString *numberOfIntegers = [NSString stringWithFormat:@"Name of Lottery: %@", self.ticket.name];

    NSString *individualInformation = @"Individual information of generation:";
    NSString *completionTime = [NSString stringWithFormat:@"Completion time (UTC+0): %@", [self stringComplitionTime]];
    NSString *serialNumber = [NSString stringWithFormat:@"Serial Number: %ld", (long)self.response.serialNumber];
    
    NSString *result = [NSString stringWithFormat:@"%@\n\n%@\n%@\n\n%@\n%@\n\n%@\n%@\n%@", resultName, forResult, resultData, parametrs, numberOfIntegers, individualInformation, completionTime, serialNumber];
    
    return result;
}


@end
