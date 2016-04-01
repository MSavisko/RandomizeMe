//
//  MSHttpClient.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/30/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSHTTPClient.h"
#import "AFNetworking.h"

@interface MSHTTPClient ()
@end

static NSString *const MSRandomInvokeApiURLString = @"https://api.random.org/json-rpc/1/invoke";

@implementation MSHTTPClient

+ (MSHTTPClient*) sharedClient {
    static MSHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    
    return _sharedClient;
};

- (instancetype) initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithSessionConfiguration:configuration];
    
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.requestSerializer setValue:@"application/json-rpc" forHTTPHeaderField:@"Content-Type"];
        [self.requestSerializer setValue:@"application/json-rpc" forHTTPHeaderField:@"Accept"];
    }
    
    return  self;
}

@end
