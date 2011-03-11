//
//  ChurchSingleton.h
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Church.h"

@interface ChurchSingleton : NSObject {
	
	NSMutableArray *_churches;
	
}

@property (nonatomic, retain) NSMutableArray *churches;

+ (ChurchSingleton*) sharedInstance;
- (void) test;
- (Church*) findChurchWithChurch: (NSString*)churchName;
@end
