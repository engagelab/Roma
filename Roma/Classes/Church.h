//
//  Church.h
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Church : NSObject {

	NSString *_churchId; 
	NSString *_name; 
	NSString *_description;
	NSString *_icon;
	NSString *_contentPage;
	NSNumber *_longitude;
	NSNumber *_latitude;
	NSString *_distanceAway;
	NSMutableArray *_songs;
}

@property (nonatomic, retain) NSString *churchId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSString *contentPage;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSString *distanceAway;
@property (nonatomic, retain) NSMutableArray *songs;

- (id)initWithId:(NSString *)churchId;

@end