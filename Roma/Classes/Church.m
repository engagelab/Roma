//
//  Church.m
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Church.h"


@implementation Church

@synthesize churchId = _churchId;
@synthesize name = _name;
@synthesize description = _description;
@synthesize icon = _icon;
@synthesize contentPage = _contentPage;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize distanceAway = _distanceAway;
@synthesize songs = _songs;

- (id)initWithId:(NSString *)churchId {
	if (self = [super init]) {
		//_churchId = churchId;
		self.churchId = churchId;
	}
	return self;
}

- (id) init {
	[super init];
}

- (NSString*)description {
	return [NSString stringWithFormat:@"church id=%@, name=%@, description=%@, icon=%@, contentPage=%@, long=%@, lat=%@", _churchId, _name, _description,_icon,_contentPage,_longitude,_latitude];;
}

- (NSComparisonResult)compare:(id)otherObject {
	
	Church *otherChurch = otherObject;
	
	return [_distanceAway compare: otherChurch.distanceAway];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_churchId);
	TT_RELEASE_SAFELY(_name);
	TT_RELEASE_SAFELY(_description);
	TT_RELEASE_SAFELY(_icon);
	TT_RELEASE_SAFELY(_contentPage);
	TT_RELEASE_SAFELY(_longitude);
	TT_RELEASE_SAFELY(_latitude);
	TT_RELEASE_SAFELY(_distanceAway);
	TT_RELEASE_SAFELY(_songs);
	[super dealloc];
}


@end
