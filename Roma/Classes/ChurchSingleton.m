//
//  ChurchSingleton.m
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ChurchSingleton.h"


@implementation ChurchSingleton

@synthesize churches = _churches;

static ChurchSingleton *_sharedInstance = nil;

+ (ChurchSingleton*) sharedInstance {
	@synchronized([ChurchSingleton class])
	{
		if (!_sharedInstance)
			[[self alloc] init];
		
		return _sharedInstance;
	}
	
	return nil;
}

+(id) alloc {
	@synchronized([ChurchSingleton class]) {
		NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedInstance = [super alloc];
		return _sharedInstance;
	}
	
	return nil;
}

-(id)init {
	self = [super init];
	
	_churches = [[NSMutableArray alloc] init];
	
	if (self != nil) {
	}
	
	return self;
}

-(void)test {
	NSLog(@"Hello churches%@!", _churches);
}

- (void)dealloc {
	//TT_RELEASE_SAFELY(_churches);
	[super dealloc];
}

@end
