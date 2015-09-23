//
//  FacebookUtils.h
//  Bangarang
//
//  Created by Thales Pereira on 9/20/15.
//  Copyright © 2015 Gennovacap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookUtils : NSObject

+ (void)loginWithFacebookWithBlock:(void (^)(void))onSuccess
                           onError:(void (^)(void))onError;

@end
