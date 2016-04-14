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

@end

@implementation MSCardShufflerResultVC
#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self setupVkDelegate];
    [self showCardImage];
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

#pragma mark - Presentation Data String Method
- (NSString*) stringComplitionTime {
    return [self.response.completionTime substringToIndex:self.response.completionTime.length-1];
}


#pragma mark - Presentation Image Method
- (void) showCardImage {
    CardShuffler *shuffle = [[CardShuffler alloc]init];
    Card *shuffledCard = [shuffle shuffleWithResponse:self.response];
    UIImage *cardImage = [UIImage imageNamed:shuffledCard.imageName];
    [self.cardImageView setImage:cardImage];
}


@end
