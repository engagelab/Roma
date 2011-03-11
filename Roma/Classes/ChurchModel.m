//
//  ChurchModel.m
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ChurchModel.h"
#import "ChurchSingleton.h"

@implementation ChurchModel

@synthesize churches = _churches;

-(id) init {
	[super init];
	_churches = [[ChurchSingleton sharedInstance] churches];
	return self;
}

- (void)dealloc {
	//TT_RELEASE_SAFELY(_churches);
	TT_RELEASE_SAFELY(_delegates);
	[super dealloc];
}

- (NSMutableArray*)delegates {
	if (!_delegates) {
		_delegates = TTCreateNonRetainingArray();
	}
	return _delegates;
}

- (BOOL)isLoadingMore {
	return NO;
}

- (BOOL)isOutdated {
	return NO;
}

- (BOOL)isLoaded {
	return YES;
}

- (BOOL)isLoading {
	return NO;
}

- (BOOL)isEmpty {
	return !_churches.count;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
}

- (void)invalidate:(BOOL)erase {
}

- (void)cancel {
	
}


@end
