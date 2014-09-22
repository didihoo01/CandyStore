//
//  Candy.h
//  Candy Store
//
//  Created by Jiahe Kuang on 9/21/14.
//  Copyright (c) 2014 Jiahe Kuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Candy : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSData * candyImage;

@end
