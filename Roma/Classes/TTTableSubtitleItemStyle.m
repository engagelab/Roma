//
//  TTTableSubtitleItemStyle.m
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/22/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "TTTableSubtitleItemStyle.h"


@implementation TTTableSubtitleItemStyle

@synthesize imageStyle = _imageStyle;

///////////////////////////////////////////////////////////////////////////////////////////////////
// class public


+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL
      defaultImage:(UIImage*)defaultImage URL:(NSString*)URL accessoryURL:(NSString*)accessoryURL imageStyle:(TTStyle*)imageStyle{
	TTTableSubtitleItemStyle* item = [[[self alloc] init] autorelease];
	item.text = text;
	item.subtitle = subtitle;
	item.imageURL = imageURL;
	item.defaultImage = defaultImage;
	item.URL = URL;
	item.accessoryURL = accessoryURL;
	item.imageStyle = imageStyle;
	return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
	if (self = [super init]) {
		_imageStyle = nil;
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_imageStyle);
	[super dealloc];
}

@end
