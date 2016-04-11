//
//  MSRandomRequest.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/11/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRandomRequest : NSObject

@property (readonly, nonatomic) NSInteger requestId;
@property (readonly, strong, nonatomic) NSString *methodName;
@property (readonly, nonatomic) BOOL replacement;
@property (readonly, nonatomic) NSInteger number;

@end
