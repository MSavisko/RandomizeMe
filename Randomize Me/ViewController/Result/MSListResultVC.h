//
//  MSListResultVC.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/15/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSRandomResponse.h"
#import <VK-ios-sdk/VKSdk.h>

@interface MSListResultVC : UIViewController <VKSdkDelegate>
@property (strong, nonatomic) MSRandomResponse *response;
@property (strong, nonatomic) NSArray *list;

@end
