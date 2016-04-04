//
//  MSRandomNumberVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/27/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSIntegerGeneratorVC.h"
#import "MSResultVC.h"
#import "MSRandomRequest.h"
#import "MSRandomResponse.h"
#import "MSHTTPClient.h"

@interface MSIntegerGeneratorVC () <UITextFieldDelegate, MSHTTPClientDelegate>
@property (weak, nonatomic) IBOutlet UIButton *randomizeButton;
@property (weak, nonatomic) IBOutlet UITextField *numberOfInteger;
@property (weak, nonatomic) IBOutlet UITextField *minValue;
@property (weak, nonatomic) IBOutlet UITextField *maxValue;
@property (weak, nonatomic) IBOutlet UISwitch *baseSwitch;
@property (strong, nonatomic) MSRandomRequest *request;
@property (strong, nonatomic) MSRandomResponse *response;
@end

@implementation MSIntegerGeneratorVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MSResultVC *resultVC = segue.destinationViewController;
    resultVC.response = self.response;
}

#pragma mark - IBAction
- (IBAction) randomizeButton:(UIButton *)sender {
    self.request = [[MSRandomRequest alloc]initWithNumberOfIntegers:[self.numberOfInteger.text intValue] minBoundaryValue:[self.minValue.text intValue] maxBoundaryValue:[self.maxValue.text intValue] andReplacement:NO forBase:10];
    if (self.baseSwitch.isOn) {
        [self.request setReplacement:YES];
    };
    NSLog(@"Request Body: %@", [self.request makeRequestBody]);
    
    MSHTTPClient *client = [MSHTTPClient sharedClient];
    [client setDelegate:self];
    [client sendRequest:self.request];
};

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
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}


@end
