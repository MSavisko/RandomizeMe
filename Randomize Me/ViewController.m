//
//  ViewController.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/20/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "ViewController.h"

#import "MSRandomRequest.h"

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
    MSRandomRequest * requestGenerationInteger = [[MSRandomRequest alloc]initWithNumberOfIntegers:10 minBoundaryValue:1 maxBoundaryValue:10 andReplacement:NO forBase:10];
    
    MSRandomRequest * requestGenerationDecimal = [[MSRandomRequest alloc]initWithNumberOfDecimalFractions:10 DecimalPlaces:10 andReplacement:NO];
    
    
    
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
    NSLog(@"Dictionary Request: %@", requestGenerationInteger.dictionaryData);
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestGenerationInteger.dictionaryData options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Make task
    //======================================================================================================
    NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //Converting NSData to NSDictionary
        NSError *jsonError = nil;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0ul
                                                                   error:&jsonError];
        self.response = jsonData[@"result"][@"random"][@"data"];
        //NSLog(@"Result: %@", jsonData);
        NSLog(@"Result: %@", self.response);
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
