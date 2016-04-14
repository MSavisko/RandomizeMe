//
//  Card.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/14/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject
@property (readonly, strong, nonatomic) NSString *name;
@property (readonly, strong, nonatomic) NSString *imageName;

- (instancetype) initWithName:(NSString*)name andImageName:(NSString*)imageName;

@end
