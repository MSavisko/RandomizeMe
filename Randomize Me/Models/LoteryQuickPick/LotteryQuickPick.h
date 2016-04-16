//
//  LoteryTicket.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/16/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSRandomIntegerRequest.h"

@interface LotteryQuickPick : NSObject
@property (readonly, strong, nonatomic) NSString *name;

- (instancetype) initWithName:(NSString*)name;
- (MSRandomIntegerRequest*) request;

@end
