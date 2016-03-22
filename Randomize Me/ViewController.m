//
//  ViewController.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/20/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "ViewController.h"

#import "MSRandomRequest.h"
#import "MSRandomResponse.h"

@interface ViewController () <NSURLSessionDelegate, NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSArray * response;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Create an object of generation
    //======================================================================================================
    __unused MSRandomRequest * requestGenerationInteger = [[MSRandomRequest alloc]initWithNumberOfIntegers:10 minBoundaryValue:1 maxBoundaryValue:10 andReplacement:NO forBase:10];
    
    __unused MSRandomRequest * requestGenerationDecimal = [[MSRandomRequest alloc]initWithNumberOfDecimalFractions:10 DecimalPlaces:10 andReplacement:NO];
    
    MSRandomRequest * requestGenerationStrings = [[MSRandomRequest alloc]initWithNumberOfStrings:10 andLength:4 forCharacters:@"abcdefjhigklmnop"];
    
    
    
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
    NSLog(@"Request: %@", requestGenerationStrings.dictionaryData);
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestGenerationStrings.dictionaryData options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Make task
    //======================================================================================================
    NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //Converting NSData to NSDictionary
        NSError *jsonError = nil;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0ul
                                                                   error:&jsonError];
        
        MSRandomResponse * randomResponse = [MSRandomResponse parseResponseFromData:jsonData];
        if (!randomResponse.error) {
            NSLog(@"Data of Response: %@", randomResponse.data);
        } else {
            NSLog(@"Error exist. %@", randomResponse.dictionaryData[@"error"][@"message"]);
        }
        
        
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
