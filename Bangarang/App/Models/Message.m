//
//  Message.m
//  Bangarang
//
//  Created by Thales Pereira on 9/7/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "Message.h"

@implementation Message

#pragma mark - Initialization

+ (instancetype)messageWithSenderId:(NSString *)senderId
                        displayName:(NSString *)displayName
                               text:(NSString *)text
{
    return [[self alloc] initWithSenderId:senderId
                        senderDisplayName:displayName
                                     date:[NSDate date]
                                     text:text];
}

- (instancetype)initWithSenderId:(NSString *)senderId
               senderDisplayName:(NSString *)senderDisplayName
                            date:(NSDate *)date
                            text:(NSString *)text
{
    NSParameterAssert(senderId != nil);
    NSParameterAssert(senderDisplayName != nil);
    NSParameterAssert(date != nil);
    NSParameterAssert(text != nil);
    
    self = [super init];
    
    if (self) {
        _senderId = [senderId copy];
        _senderDisplayName = [senderDisplayName copy];
        _date = [date copy];
        _text = [text copy];
    }
    
    return self;
}

- (NSUInteger)messageHash
{
    NSUInteger opa = self.senderId.hash ^ self.date.hash ^ self.text.hash;
    return opa;
}

@end
