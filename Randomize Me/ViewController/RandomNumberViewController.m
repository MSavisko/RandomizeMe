//
//  ListViewController.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/27/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "RandomNumberViewController.h"
#import "MSRandomRequest.h"

@interface RandomNumberViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *randomizeButton;
@property (weak, nonatomic) IBOutlet UITextField *numberOfInteger;
@property (weak, nonatomic) IBOutlet UITextField *minValue;
@property (weak, nonatomic) IBOutlet UITextField *maxValue;
@property (strong, nonatomic) MSRandomRequest *request;
@end

@implementation RandomNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
    
- (IBAction)randomizeButton:(UIButton *)sender {

};


@end
