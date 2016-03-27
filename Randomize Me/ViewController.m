//
//  ViewController.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/20/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandomRequest.h"
#import "MSRandomResponse.h"

#import "ViewController.h"

@interface ViewController () <NSURLSessionDelegate, NSURLSessionTaskDelegate>
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Create an object of generation
    //======================================================================================================
    __unused MSRandomRequest * requestGenerationInteger = [[MSRandomRequest alloc]initWithNumberOfIntegers:10 minBoundaryValue:1 maxBoundaryValue:10 andReplacement:NO forBase:10];
    
    __unused MSRandomRequest * requestGenerationDecimal = [[MSRandomRequest alloc]initWithNumberOfDecimalFractions:10 DecimalPlaces:10 andReplacement:NO];
    
    __unused MSRandomRequest * requestGenerationStrings = [[MSRandomRequest alloc]initWithNumberOfStrings:10 andLength:4 forCharacters:@"abcdefjhigklmnop" andReplacement:YES];
    
    
    
    //Config session
    //======================================================================================================
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    configuration.HTTPMaximumConnectionsPerHost = 3;
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //Make Request
    //======================================================================================================
    NSURL * url = [NSURL URLWithString:@"https://api.random.org/json-rpc/1/invoke"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json-rpc" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json-rpc" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    //Convert NSDictionary to NSData
    //======================================================================================================
    
    //Make Data for Verify Request
    //======================================================================================================
    NSString *signature = @"GaC9YGz/C5w9s/GY2W3noQ7fL4x0ktfdTj4ymxEjXRJj7Li/mRHAAUQhP9wDFT5iEA/1XdOFgyfWJsyU25MlPBLKcF71ctV/O2k+I1tYMamQgJeq7JB7rNuEbK+nSPNKySPWHPko6sOtOYg7BYnuItkp54DYVGuZg4UmyeUk8TeJt7nI9lvmSQ0uA3ysB0YlddWY8jvOIe0mjUANNcSJnANYd0rN2n9K+5D8ZCxwAPnYphqGcYvCDmKOL+4L9VPB+3oHg5CicXeaThFqHvVPNG14HuhVK0zLtRdfJfiwDmIYep9dv9le0iOxGrB2oKghVj3JpHtcP/Eg4rNZbGpOrHrdZUyiyNP9YpKIiod4dfbAJRVv3UBr83FWakeU4B7LkFX0OX62sz9Pq02vdDQwnjKYqk+n3hCGQfrxXwDnxmOLpsGW66U+MChWkhJAL5OOyoTflEBA7Oitno+lERjotc2LT9+b0BevpOkJqzOFLb3Pp7Tt4+h4FDnvJBHmKo8AZ93N3nMSFXW7p4bevqKNmk5rJerGUPCO1tBa73l3jyWq5Z9ELnHD+Z+1mfylZ1IAninZCWvgylzAzsC0tkfx1hh4FV4qW/+xIZaYGXT9/DzxgiLQSHZiN2jb0zkW+2mBbQe8zJ/nyBDACU/eN3O8H5KQEoicmAxEp3ESL2ncHk8=";
    NSString *completionTime = @"2016-03-27 09:39:14Z";
    NSInteger serial = 111;
    NSArray *dataArray = @[@10, @8, @2, @4, @5, @3, @6, @1, @7, @9];
    NSDictionary * postDictionary = [requestGenerationInteger makeRequestBodyWithSignature:signature atCompletionTime:completionTime serial:serial andDataArray:dataArray];
    //======================================================================================================
    
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:[requestGenerationInteger makeRequestBody] options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Make task
    //======================================================================================================
    NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //Converting NSData to NSDictionary
        NSError *jsonError = nil;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0ul
                                                                   error:&jsonError];
        
        MSRandomResponse * randomResponse = [[MSRandomResponse alloc]init];
        [randomResponse parseResponseFromData:jsonData];
        if (!randomResponse.error) {
            NSLog(@"Response data: %@", randomResponse.data);
        } else {
            NSLog(@"Error exist. %@", [randomResponse parseError]);
        }
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
