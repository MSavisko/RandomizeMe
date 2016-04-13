//
//  MSDiceRollerResultVC.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/13/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSRandomResponse.h"
#import <VK-ios-sdk/VKSdk.h>

@interface MSDiceRollerResultVC : UIViewController <VKSdkDelegate>
@property (strong, nonatomic) MSRandomResponse *response;

@end
