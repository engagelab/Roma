//
//  Song.m
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Song.h"


@implementation Song

@synthesize songId = _songId;
@synthesize name = _name;
@synthesize time = _time;

- (id) init {
	[super init];
}

- (id)initWithId:(NSString *)songId {
	if ((self = [super init])) {
		_songId = songId;
		self.songId = songId;
	}
	return self;
}

- (NSString*)description {
	return [NSString stringWithFormat:@"song id=%@, name=%@, time=%@", _songId, _name, _time];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_songId);
	TT_RELEASE_SAFELY(_name);
	TT_RELEASE_SAFELY(_time);
	[super dealloc];
}


@end
