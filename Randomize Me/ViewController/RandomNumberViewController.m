//
//  ListViewController.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/27/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "RandomNumberViewController.h"
#import "MSRandomRequest.h"
#import "MSRandomResponse.h"
#import "AFNetworking.h"

@interface RandomNumberViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *randomizeButton;
@property (weak, nonatomic) IBOutlet UITextField *numberOfInteger;
@property (weak, nonatomic) IBOutlet UITextField *minValue;
@property (weak, nonatomic) IBOutlet UITextField *maxValue;
@property (weak, nonatomic) IBOutlet UISwitch *baseSwitch;
@property (strong, nonatomic) MSRandomRequest *request;
@end

@implementation RandomNumberViewController

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
    
    //Init AFManager and Serializer
    //======================================================================================
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json-rpc" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json-rpc" forHTTPHeaderField:@"Accept"];
    //Make POST Request
    //=======================================================================================
    [manager POST:@"https://api.random.org/json-rpc/1/invoke" parameters:[self.request makeRequestBody] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
