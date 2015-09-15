//
//  RequestManager.h
//  Bangarang
//
//  Created by Thales Pereira on 9/14/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestManagerDelegate
- (void)receiveRequest;
@end

@interface RequestManager : NSObject

@property (nonatomic, assign) id  delegate;

- (void)createRequest:(NSString *)friendId;
- (void)receivedRequestObserver;
- (void)destroy;

@end
