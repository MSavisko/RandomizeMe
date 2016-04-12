//
//  MSHTTPClient.h
//  Randomize Me
//
//  Created by Maksym Savisko on 3/30/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol MSHTTPClientDelegate;

@interface MSHTTPClient : AFHTTPSessionManager

@property (weak, nonatomic) id<MSHTTPClientDelegate>delegate;

+ (instancetype) sharedClient;

- (void) sendRequest:(NSDictionary*)parameters;

@end

#pragma mark - Protocol Methods
@protocol MSHTTPClientDelegate <NSObject>

@optional
- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didSucceedWithResponse:(id)responseObject;
- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didFailWithError:(NSError *)error;

@end