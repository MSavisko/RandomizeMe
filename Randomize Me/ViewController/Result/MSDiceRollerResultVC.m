//
//  MSDiceRollerResultVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/13/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSDiceRollerResultVC.h"
#import "SWRevealViewController.h"

#import "MBProgressHUD.h"

#import <Social/Social.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <VK-ios-sdk/VKSdk.h>

@interface MSDiceRollerResultVC () <UIActionSheetDelegate, UIAlertViewDelegate, VKSdkUIDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fifthImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sixthImageView;
@property (strong, nonatomic) NSArray *arrayOfImage;

@end

@implementation MSDiceRollerResultVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self setupVkDelegate];
    [self setArrayImage];
    [self setDiceImage];
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

- (void) setArrayImage {
    self.arrayOfImage = [NSArray arrayWithObjects:self.firstImageView, self.secondImageView, self.thirdImageView, self.fourthImageView, self.fifthImageView, self.sixthImageView, nil];
}

#pragma mark - Share Method
- (void) shareWithFacebook {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self stringResultForShare];
    NSURL *contentURL = [[NSURL alloc] initWithString:
                         @"https://www.random.org/dice/"];
    
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.contentURL = contentURL;
    content.photos = [self imageShareFacebook];
    
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];
}

- (void) shareWithVkontakte {
    VKShareDialogController *shareDialog = [VKShareDialogController new];
    shareDialog.text = [self stringResultForShare];
    shareDialog.shareLink = [[VKShareLink alloc] initWithTitle:@"Dice roller result via Randomize Me" link:[NSURL URLWithString:@"https://www.random.org/dice/"]];
    shareDialog.uploadImages = [self imageShareVkontakte];
    [shareDialog setCompletionHandler:^(VKShareDialogController *dialog, VKShareDialogControllerResult result) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:shareDialog animated:YES completion:nil];
}

- (void) shareWithTwitter {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweet setInitialText:@"Dice roller result via Randomize Me"];
        [tweet addURL:[NSURL URLWithString:@"https://www.random.org/passwords/"]];
        for (int i = 0; i < self.response.data.count; i++) {
            NSString *imageName = [self sharedDice:self.response.data[i]];
            UIImage *image = [UIImage imageNamed:imageName];
            [tweet addImage:image];
        }
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



#pragma mark - Presentation Image Method
- (NSString*) imageNameFromDice:(NSNumber*)number {
    int diceNumber = [number intValue];
    switch (diceNumber) {
        case 1:
            return @"dice1_blue";
            break;
            
        case 2:
            return @"dice2_blue";
            
        case 3:
            return @"dice3_blue";
            
        case 4:
            return @"dice4_blue";
            
        case 5:
            return @"dice5_blue";
            
        case 6:
            return @"dice6_blue";
            
        default:
            break;
    }
    return nil;
}

- (void) setDiceImage {
    for (int i = 0; i < self.response.data.count; i++) {
        NSString *imageName = [self imageNameFromDice:self.response.data[i]];
        UIImage *image = [UIImage imageNamed:imageName];
        [self.arrayOfImage[i] setImage:image];
    }
}

#pragma mark - Presentation Data Method
- (NSString*) stringComplitionTime {
    return [self.response.completionTime substringToIndex:self.response.completionTime.length-1];
}

- (NSString*) stringResult {
    NSString *result = [[self.response.data valueForKey:@"description"] componentsJoinedByString:@" dice"];
    NSMutableString *mutableResult = [NSMutableString stringWithFormat:@"dice%@", result];
    return mutableResult;
}

- (NSString*) stringResultForShare {
    NSString *resultName = @"Dice Roller Generation";
    NSString *forResult = @"Result:";
    NSString *resultData = [self stringResult];
    NSString *parametrs = @"Parameters of generation:";
    NSString *numberOfStrings = [NSString stringWithFormat:@"Number of Dice: %d", self.response.data.count];
    NSString *replacement = @"Unique Dice: NO";
    NSString *individualInformation = @"Individual information of generation:";
    NSString *completionTime = [NSString stringWithFormat:@"Completion time (UTC+0): %@", [self stringComplitionTime]];
    NSString *serialNumber = [NSString stringWithFormat:@"Serial Number: %ld", (long)self.response.serialNumber];
    NSString *result = [NSString stringWithFormat:@"%@\n\n%@\n%@\n\n%@\n%@\n%@\n\n%@\n%@\n%@", resultName, forResult, resultData, parametrs, numberOfStrings, replacement, individualInformation, completionTime, serialNumber];
    return result;
}

#pragma mark - Presentation Share Image Method
- (NSString*) sharedDice:(NSNumber*)number {
    int diceNumber = [number intValue];
    switch (diceNumber) {
        case 1:
            return @"dice1_small";
            break;
            
        case 2:
            return @"dice2_small";
            
        case 3:
            return @"dice3_small";
            
        case 4:
            return @"dice4_small";
            
        case 5:
            return @"dice5_blue";
            
        case 6:
            return @"dice6_small";
            
        default:
            break;
    }
    return nil;
}

//VK image
- (NSArray*) imageShareVkontakte {
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.response.data.count; i++) {
        NSString *imageName = [self sharedDice:self.response.data[i]];
        UIImage *image = [UIImage imageNamed:imageName];
        [imageArray addObject:[VKUploadImage uploadImageWithImage:image andParams:[VKImageParameters jpegImageWithQuality:1.0] ]];
    }
    return imageArray;
}

//Facebook image
- (NSArray*) imageShareFacebook {
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.response.data.count; i++) {
        NSString *imageName = [self sharedDice:self.response.data[i]];
        UIImage *image = [UIImage imageNamed:imageName];
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.image = image;
        photo.userGenerated = YES;
        [imageArray addObject:photo];
    }
    return imageArray;
}




@end
