//
//  MSRandomNumberVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/27/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSIntegerGeneratorVC.h"
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
@end

@implementation MSIntegerGeneratorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Action
- (IBAction)randomizeButton:(UIButton *)sender {
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
- (void)MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didSucceedWithResponse:(id)responseObject {
    MSRandomResponse * randomResponse = [[MSRandomResponse alloc]init];
    [randomResponse parseResponseFromData:responseObject];
    if (!randomResponse.error) {
        NSLog(@"Response data: %@", randomResponse.data);
        [self performSegueWithIdentifier:@"ShowRandomResult" sender:randomResponse];
    } else {
        NSLog(@"Error exist. %@", [randomResponse parseError]);
    }
}

- (void)MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

@end
