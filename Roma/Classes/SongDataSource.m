//
//  SongDataSource.m
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/28/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SongDataSource.h"
#import "ChurchModel.h"
#import "Church.h"
#import "Song.h"
#import "TTTableSubtitleItemStyle.h"

@implementation SongDataSource

@synthesize churchModel = _churchModel;
@synthesize churchName = _churchName;

- (id)initWithChurchName:(NSString*)churchName {
	if ((self = [super init])) {
		self.churchName = churchName;
		_churchModel = [[ChurchModel alloc] init];
		self.model = _churchModel;
	}
	return self;
}



- (void)tableViewDidLoadModel:(UITableView*)tableView {
	self.items = [NSMutableArray array];
    
		_churchModel = [[ChurchModel alloc] init];
		self.model = _churchModel;	
	
	
	for (Church *church in _churchModel.churches) {
		
		if( [church.churchId isEqualToString: self.churchName ] ) {
		//trasverse all the sonds
			for (Song *song in church.songs) {
				
				TTTableButton *item =[TTTableButton itemWithText:[ NSString stringWithFormat:@"%@ (%@)", song.name , song.time]];
				[_items addObject:item];
			}
			
		
		
		/*
		 TTTableItem* item = [TTTableImageItem itemWithText:church.name imageURL:localImage
		 defaultImage:nil imageStyle:TTSTYLE(rounded)
		 URL:viewUrl];
		 */
		
			
		}
		
		
	}
	
}



- (NSString*)titleForLoading:(BOOL)reloading {
	return @"Loading Songs...";
}

- (NSString*)titleForNoData {
	return @"No songs found";
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_churchModel);
	[super dealloc];
}

@end
