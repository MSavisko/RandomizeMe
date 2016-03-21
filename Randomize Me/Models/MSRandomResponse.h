//
//  MSRandomResponse.h
//  Randomize Me
//
//  Created by Maksym Savisko on 3/21/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRandomResponse : NSObject

@property (nonatomic, strong) NSString * hashedApiKey;
@property (nonatomic, strong) NSArray * data;
@property (nonatomic, strong) NSString * completionTime;
@property (nonatomic) NSInteger serialNumber;
@property (nonatomic, strong) NSString * signature;

@end
