//
//  ChurchDataSource.m
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ChurchDataSource.h"
#import "ChurchModel.h"
#import "Church.h"
#import "TTTableSubtitleItemStyle.h"

@implementation ChurchDataSource

@synthesize churchModel = _churchModel;


- (id)init {
	if (self = [super init]) {
		_churchModel = [[ChurchModel alloc] init];
		self.model = _churchModel;
	}
	return self;
}

- (id<TTModel>)model {
	return _churchModel;
}


- (void)tableViewDidLoadModel:(UITableView*)tableView {
	[super tableViewDidLoadModel:tableView]; 
	self.items = [NSMutableArray array];
    
	
	for (Church *church in _churchModel.churches) {
		
		NSString* localImage = [@"bundle://" stringByAppendingFormat:church.icon];
		NSString* viewUrl = [@"tt://outsideChurchView/" stringByAppendingFormat:church.contentPage];
		
		NSLog(@"table updating %@",[NSString stringWithFormat:@"%@m away", church.distanceAway]);
		
		TTTableSubtitleItemStyle* item = [TTTableSubtitleItemStyle itemWithText:church.name subtitle:[NSString stringWithFormat:@"%@m away", church.distanceAway]
															imageURL:localImage defaultImage:nil
														  URL:viewUrl accessoryURL:nil imageStyle:TTSTYLE(rounded)];
		/*
		TTTableItem* item = [TTTableImageItem itemWithText:church.name imageURL:localImage
						  defaultImage:nil imageStyle:TTSTYLE(rounded)
													   URL:viewUrl];
		*/
		
		[_items addObject:item];
		
		
		
	}
	 
}



- (NSString*)titleForLoading:(BOOL)reloading {
	return @"Loading Churches...";
}

- (NSString*)titleForNoData {
	return @"No churches found";
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_churchModel);
	[super dealloc];
}

@end
