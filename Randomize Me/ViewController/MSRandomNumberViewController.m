//
//  ListViewController.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/27/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandomNumberViewController.h"
#import "MSRandomRequest.h"
#import "MSRandomResponse.h"
#import "MSHTTPClient.h"

@interface MSRandomNumberViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *randomizeButton;
@property (weak, nonatomic) IBOutlet UITextField *numberOfInteger;
@property (weak, nonatomic) IBOutlet UITextField *minValue;
@property (weak, nonatomic) IBOutlet UITextField *maxValue;
@property (weak, nonatomic) IBOutlet UISwitch *baseSwitch;
@property (strong, nonatomic) MSRandomRequest *request;
@end

@implementation MSRandomNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}
    
- (IBAction)randomizeButton:(UIButton *)sender {
    //Make Request
    //======================================================================================
    self.request = [[MSRandomRequest alloc]initWithNumberOfIntegers:[self.numberOfInteger.text intValue] minBoundaryValue:[self.minValue.text intValue] maxBoundaryValue:[self.maxValue.text intValue] andReplacement:NO forBase:10];
    if (self.baseSwitch.isOn) {
        [self.request setReplacement:YES];
    };
    NSLog(@"Request Body: %@", [self.request makeRequestBody]);
    
    MSHTTPClient *client = [MSHTTPClient sharedClient];
    
    
    //Make POST Request
    //=======================================================================================
    [client POST:@"https://api.random.org/json-rpc/1/invoke" parameters:[self.request makeRequestBody] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Post Sucsess!");
        MSRandomResponse * randomResponse = [[MSRandomResponse alloc]init];
        [randomResponse parseResponseFromData:responseObject];
        if (!randomResponse.error) {
            NSLog(@"Response data: %@", randomResponse.data);
        } else {
            NSLog(@"Error exist. %@", [randomResponse parseError]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Post failed");
    }];
};

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}


@end
