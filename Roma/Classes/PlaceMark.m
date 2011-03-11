//
//  PlaceMark.m
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/26/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PlaceMark.h"


@implementation PlaceMark  
@synthesize title, subtitle, churchName;  
@synthesize coordinate;


- (id) init {
   [super init];
	return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c {  
	
	if (self = [self init]) {
		coordinate = c;  
		//TTDPRINT(@"init with coordinate: %@",c);
	}
    
    return self;  
}  


- (void)dealloc {
	TT_RELEASE_SAFELY(churchName);
	TT_RELEASE_SAFELY(title);
	TT_RELEASE_SAFELY(subtitle);
	[super dealloc];
}

@end  
