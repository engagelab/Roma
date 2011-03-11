//
//  SongDataSource.h
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/28/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ChurchModel.h"

@interface SongDataSource : TTListDataSource {

	NSString *_churchName;
	ChurchModel *_churchModel;
}

@property (nonatomic, copy) NSString* churchName;
@property (nonatomic, copy) ChurchModel *churchModel;

@end
