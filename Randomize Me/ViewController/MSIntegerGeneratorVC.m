//
//  MSRandomNumberVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/27/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSIntegerGeneratorVC.h"
#import "MSResultVC.h"
#import "MSIntegerRequest.h"
#import "MSRandomResponse.h"
#import "MSHTTPClient.h"
#import "SWRevealViewController.h"

@interface MSIntegerGeneratorVC () <UITextFieldDelegate, MSHTTPClientDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *randomizeButton;
@property (weak, nonatomic) IBOutlet UITextField *numberOfInteger;
@property (weak, nonatomic) IBOutlet UITextField *minValue;
@property (weak, nonatomic) IBOutlet UITextField *maxValue;
@property (weak, nonatomic) IBOutlet UISwitch *baseSwitch;
@property (strong, nonatomic) MSIntegerRequest *integerRequest;
@property (strong, nonatomic) MSRandomResponse *response;
@end

@implementation MSIntegerGeneratorVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardByTap];
    [self setupMenuBar];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MSResultVC *resultVC = segue.destinationViewController;
    resultVC.response = self.response;
}

#pragma mark - IBAction
- (IBAction) randomizeButton:(UIButton *)sender {
    self.integerRequest = [[MSIntegerRequest alloc]initWithNumberOfIntegers:[self.numberOfInteger.text intValue] minBoundaryValue:[self.minValue.text intValue] maxBoundaryValue:[self.maxValue.text intValue] andReplacement:NO forBase:10];
    if (self.baseSwitch.isOn) {
        [self.integerRequest setReplacement:YES];
    };
    NSLog(@"Request Body: %@", [self.integerRequest makeRequestBody]);
    
    MSHTTPClient *client = [MSHTTPClient sharedClient];
    [client setDelegate:self];
    [client sendRequest:[self.integerRequest makeRequestBody]];
}

#pragma mark - MSHTTPClient Delegate
- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didSucceedWithResponse:(id)responseObject {
    self.response = [[MSRandomResponse alloc]init];
    [self.response parseResponseFromData:responseObject];
    if (!self.response.error) {
        NSLog(@"Response data: %@", self.response.data);
        [self performSegueWithIdentifier:@"ShowRandomResult" sender:nil];
    } else {
        NSLog(@"Error exist. %@", [self.response parseError]);
    }
}

- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma mark - Helper Methods
- (void) hideKeyboardByTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (void) setupMenuBar {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.menuButtonItem setTarget: self.revealViewController];
        [self.menuButtonItem setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

@end
