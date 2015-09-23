//
//  AOLinkedStoryboardSegue.h
//  Bangarang
//
//  Created by Thales Pereira on 8/31/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AOLinkedStoryboardSegue : UIStoryboardSegue

+ (UIViewController *)sceneNamed:(NSString *)identifier;

@end
