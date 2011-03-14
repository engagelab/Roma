//
//  InsideChurchView.m
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/15/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ChurchViewController.h"
#import "ChurchSingleton.h"

@implementation ChurchViewController

@synthesize churchName = _churchName;

BOOL outside = NO;
	
- (id)initWithChurchName:(NSString*)churchName {
	[super self];

	if ((self = [self init])) {
		self.churchName = churchName;
		//self.title = churchName;
		
		
		
		self.title = _church.name;
		
		TTDPRINT(@"Church View started: %@",_churchName);
	}
	
	return self;
}



- (id)init {
	
	[super init];

	return self;
}

- (void)loadView {
	[super loadView];

	self.title = [NSString stringWithFormat:@"Outside %@", [self.churchName capitalizedString]];
			

	
	self.navigationBarTintColor = [UIColor colorWithHue:0.6 saturation:0.33 brightness:0.69 alpha:0];
	self.navigationBarStyle = UIBarStyleDefault;
	/*
	self.navigationItem.backBarButtonItem =
	[[[UIBarButtonItem alloc] initWithTitle:@"Churches" style:UIBarButtonItemStyleBordered
									 target:nil action:nil] autorelease];
	 */
	_webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, 320, 375)];
	_webView.autoresizesSubviews = YES;
	_webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	//set the web view delegates for the web view to be itself
	[_webView setDelegate:self];
	//Set the URL to go to for your UIWebView

	
	//Create a URL object.
	TTDPRINT(@"Church View started with: %@",self.churchName);
	
	
	NSString *fileName = [NSString stringWithFormat:@"%@Outside",self.churchName];
	
	NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: fileName ofType:@"html"]];
	
	TTDPRINT(@"URL %@",url);
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	//load the URL into the web view.
	[_webView loadRequest:requestObj];
	//add the web view to the content view
	[self.view addSubview:_webView];
	[_webView sizeToFit];
	
		_churchToolBar =  [[UIToolbar alloc] initWithFrame:  CGRectMake(0, 372, 320, 55)]; 
	
		_flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil ];
	
		_enterChurchButton = [[[UIBarButtonItem alloc]  
									   initWithTitle:@"Enter Church"  
									   style:UIBarButtonItemStyleBordered  
									   target:self
									   action:@selector(enterChurch)] retain];

	
	
		_churchToolBar.items = [[NSArray arrayWithObjects:_flexSpace,_enterChurchButton,_flexSpace,nil] retain];
	
	//[[[self navigationItem] setRightBarButtonItem:_enterChurchButton] retain];
	
	
		[self.view addSubview:_churchToolBar];
		[_churchToolBar sizeToFit];
	
}

- (void) viewWillAppear:(BOOL)animated {
	
	self.navigationBarTintColor = [UIColor colorWithHue:0.6 saturation:0.33 brightness:0.69 alpha:0];
	self.navigationBarTintColor = [UIColor whiteColor];
	self.navigationBarStyle = UIBarStyleDefault;
	
	TTDPRINT(@"viewWillAppear");
}
 
- (void) viewDidLoad {
	self.navigationBarTintColor = [UIColor colorWithHue:0.6 saturation:0.33 brightness:0.69 alpha:0];
	self.navigationBarStyle = UIBarStyleDefault;
	TTDPRINT(@"viewDidLoad");
}

- (void) viewWillDisappear:(BOOL)animated {
	
	
	 UIBarButtonItem *newBackButton = [[[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"arrow.png"]  style: UIBarButtonItemStyleBordered target: nil action: nil] retain];
	 
	[[self navigationItem] setBackBarButtonItem: newBackButton  ];
	 //[self.navigationItem.backBarButtonItem retain];
	// [newBackButton release];
	 

	
}

- (void) enterChurch {
	
	TTOpenURL([NSString stringWithFormat:@"tt://churchPlayerView/%@", self.churchName]);
	//[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:[NSString stringWithFormat:@"tt://churchPlayerView/%@", self.churchName]] animated: YES tran];
}


- (void)dealloc {
	TT_RELEASE_SAFELY(_churchName);
	TT_RELEASE_SAFELY(_churchToolBar);
	TT_RELEASE_SAFELY(_webView);
	[super dealloc];
}

@end
