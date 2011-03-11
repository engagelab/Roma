//
//  InsideChurchView.h
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/15/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Church.h"

@interface ChurchViewController : TTViewController {
	NSString *_churchName;
	UIToolbar *_churchToolBar;
	UIWebView *_webView;
	Church *_church;
	UIBarButtonItem *_enterChurchButton;
	UIBarButtonItem *_flexSpace;
	NSArray *items;
    
}

@property (nonatomic, copy) NSString* churchName;


@end
