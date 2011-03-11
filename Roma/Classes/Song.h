//
//  Song.h
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Song : NSObject {
	
	NSString *_songId; 
	NSString *_name; 
	NSString *_time;

}

@property (nonatomic, retain) NSString *songId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *time;

@end
