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

#pragma mark - Presentation Data Method
- (void) setArrayImage {
    self.arrayOfImage = [NSArray arrayWithObjects:self.firstImageView, self.secondImageView, self.thirdImageView, self.fourthImageView, self.fifthImageView, self.sixthImageView, nil];
}

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





@end
