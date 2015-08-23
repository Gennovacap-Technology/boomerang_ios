//
//  TestObject.h
//  Bangarang
//
//  Created by Nielson Rolim on 8/23/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "ParseModel.h"

@interface TestObject : ParseModel

@property (nonatomic, strong) NSString* foo;

+ (NSArray*) findAll;

@end
