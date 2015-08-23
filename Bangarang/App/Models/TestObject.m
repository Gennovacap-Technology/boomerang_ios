//
//  TestObject.m
//  Bangarang
//
//  Created by Nielson Rolim on 8/23/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject

@dynamic foo;

+ (NSString *)parseModelClass {
    return @"TestObject";
}

+ (NSArray*) findAll {
    PFQuery *query = [PFQuery queryWithClassName:[self parseModelClass]];
    query.cachePolicy = kPFCachePolicyNetworkElseCache; //kPFCachePolicyCacheElseNetwork
    [query orderByAscending:@"foo"];
    
    NSArray *allPFObjects = [query findObjects];
    
    // Using Underscore to map PFObject objects to TestObject objects
    // http://underscorem.org/#arraymap-underscorearraymapnsarray-array-underscorearraymapblock-block
    NSArray *allTestObjects = _.arrayMap(allPFObjects, ^(PFObject *parseObject) {
        return [self parseModelWithParseObject:parseObject];
    });
    
    return allTestObjects;
}

@end
