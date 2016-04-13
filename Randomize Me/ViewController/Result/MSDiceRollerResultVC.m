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

#pragma mark - Presentation Image Method
- (NSString*) imageNameFromeDice:(NSNumber*)number {
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
        NSString *imageName = [self imageNameFromeDice:self.response.data[i]];
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

- (NSString*) stringResultForCopying {
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

//- (NSString*) stringResultForShare {
//    return result;
//}





@end
