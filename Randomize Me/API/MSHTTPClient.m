//
//  MSHTTPClient.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/30/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSHTTPClient.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"


@interface MSHTTPClient ()
@end

static NSString *const MSRandomInvokeApiURL = @"https://api.random.org/json-rpc/1/invoke";

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

- (void) sendRequest:(NSDictionary*)request {
    UIView *progressBackground = [(UIViewController *)self.delegate view];
    [MBProgressHUD showHUDAddedTo:progressBackground animated:YES];
    [self POST:MSRandomInvokeApiURL parameters:request progress:nil success:[self successBlock:progressBackground] failure:[self failBlock:progressBackground]];
}

#pragma mark - Blocks

-(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock:(UIView *)progressBackground{
    return ^(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject){
        if ([self.delegate respondsToSelector:@selector(MSHTTPClient:didSucceedWithResponse:)]) {
            [self.delegate MSHTTPClient:self didSucceedWithResponse:responseObject];
        }else{
            NSLog(@"Delegate do not response success service");
        }
        [MBProgressHUD hideAllHUDsForView:progressBackground animated:YES];
    };
}

-(void (^)(NSURLSessionDataTask *task, NSError *error))failBlock:(UIView *)progressBackground{
    return ^(NSURLSessionDataTask *task, NSError *error){
        if ([self.delegate respondsToSelector:@selector(MSHTTPClient:didFailWithError:)]) {
            [self.delegate MSHTTPClient:self didFailWithError:error];
        }else{
            NSLog(@"Delegate do not response failed service");
        }
        [MBProgressHUD hideAllHUDsForView:progressBackground animated:YES];
    };
}

@end
