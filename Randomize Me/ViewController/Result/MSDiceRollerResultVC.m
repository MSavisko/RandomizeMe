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

@end

@implementation MSDiceRollerResultVC

@end
