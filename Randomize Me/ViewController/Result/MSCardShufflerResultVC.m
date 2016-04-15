//
//  MSCardShufflerResultVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/14/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSCardShufflerResultVC.h"
#import "Card.h"
#import "CardShuffler.h"

#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import <Social/Social.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <VK-ios-sdk/VKSdk.h>


@interface MSCardShufflerResultVC () <UIActionSheetDelegate, UIAlertViewDelegate, VKSdkUIDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *copyingButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (strong, nonatomic) Card *shuffledCard;

@end

@implementation MSCardShufflerResultVC
#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self setupVkDelegate];
    [self showCardImage];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar];
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Card Shuffler"
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
            NSArray *scope = @[VK_PER_WALL, VK_PER_PHOTOS];
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

#pragma mark - Share Method
- (void) shareWithFacebook {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self stringResultForShare];
    NSURL *contentURL = [[NSURL alloc] initWithString:
                         @"https://www.random.org/playing-cards/"];
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc]init];
    content.contentURL = contentURL;
    content.imageURL = nil;
    content.contentDescription = @"Card Shuffler result by Randomize Me";
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];
}

- (void) shareWithVkontakte {
    VKShareDialogController *shareDialog = [VKShareDialogController new];
    shareDialog.text = [self stringResultForShare];
    shareDialog.shareLink = [[VKShareLink alloc] initWithTitle:@"Card Shuffler result via Randomize Me" link:[NSURL URLWithString:@"https://www.random.org/playing-cards/"]];
    shareDialog.uploadImages = @[ [VKUploadImage uploadImageWithImage:[UIImage imageNamed:self.shuffledCard.imageName] andParams:[VKImageParameters jpegImageWithQuality:1.0] ] ];
    [shareDialog setCompletionHandler:^(VKShareDialogController *dialog, VKShareDialogControllerResult result) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:shareDialog animated:YES completion:nil];
}

- (void) shareWithTwitter {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweet setInitialText:[NSString stringWithFormat:@"Card Shuffler via Randomize Me\n\nResult:\n%@",[self stringResult]]];
        [tweet addImage:[UIImage imageNamed:self.shuffledCard.imageName]];
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

#pragma mark - Presentation Image Method
- (void) showCardImage {
    CardShuffler *shuffle = [[CardShuffler alloc]init];
    self.shuffledCard = [shuffle shuffleWithResponse:self.response];
    UIImage *cardImage = [UIImage imageNamed:_shuffledCard.imageName];
    [self.cardImageView setImage:cardImage];
}

#pragma mark - Presentation Data String Method
- (NSString*) stringComplitionTime {
    return [self.response.completionTime substringToIndex:self.response.completionTime.length-1];
}

- (NSString*) stringResult {
    return self.shuffledCard.name;
}

- (NSString*) stringResultForShare {
    NSString *resultName = @"Card Shuffler";
    NSString *forResult = @"Result:";
    NSString *resultData = [self stringResult];
    NSString *parametrs = @"Parameters:";
    NSString *numberOfStrings = [NSString stringWithFormat:@"Number of Cards: %lu", (unsigned long)self.response.data.count];
    NSString *replacement = @"Unique Card: YES";
    NSString *individualInformation = @"Individual information of generation:";
    NSString *completionTime = [NSString stringWithFormat:@"Completion time (UTC+0): %@", [self stringComplitionTime]];
    NSString *serialNumber = [NSString stringWithFormat:@"Serial Number: %ld", (long)self.response.serialNumber];
    NSString *result = [NSString stringWithFormat:@"%@\n\n%@\n%@\n\n%@\n%@\n%@\n\n%@\n%@\n%@", resultName, forResult, resultData, parametrs, numberOfStrings, replacement, individualInformation, completionTime, serialNumber];
    return result;
}


@end
