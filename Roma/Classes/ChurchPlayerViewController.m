//
//  ChuchPlayerViewController.m
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ChurchPlayerViewController.h"
#import "ChurchDataSource.h"
#import "SongDataSource.h"
#import <AVFoundation/AVFoundation.h>


@implementation ChurchPlayerViewController

@synthesize churchName = _churchName, path = _path, player = _player;


BOOL _paused = YES;
BOOL _isWebShowing = YES;
BOOL _hasPreparedToPlay = NO;
int _songIndex = 0;
UITableView *_tableView;
int tempIndex = 0;

- (id)initWithChurchName:(NSString*)churchName {
	[super self];
	
	if ((self = [super init])) {
            self.navigationBarTintColor =  TTSTYLEVAR(navigationBarTintColorDark);
		self.churchName = churchName;
		self.dataSource = [[[SongDataSource alloc] initWithChurchName:churchName] autorelease];

	//	self.churchTableView =  [[ChurchPlayerTableViewController alloc] init];
	//	self.churchTableView.dataSource = [[[SongDataSource alloc] initWithChurchName:churchName] autorelease];
		//self.churchTableView =  [[ChurchPlayerTableViewController alloc] initWithChurchName:_churchName];
		TTDPRINT(@"Church View started: %@",_churchName);
	}
	
	return self;
}

- (void) setup {
	
	
	self.title = [NSString stringWithFormat:@"Inside %@", [self.churchName capitalizedString]];
   	_webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, 320, 420)];
	_webView.autoresizesSubviews = YES;
	_webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	//set the web view delegates for the web view to be itself
	[_webView setDelegate:self];
	//Set the URL to go to for your UIWebView
	
	
	//Create a URL object.
	TTDPRINT(@"Church View started with: %@",self.churchName);
	
	
	NSString *fileName = [NSString stringWithFormat:@"%@Inside",self.churchName];
	
	NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: fileName ofType:@"html"]];
	
	TTDPRINT(@"URL %@",url);
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	//load the URL into the web view.
	[_webView loadRequest:requestObj];
	//add the web view to the content view
	_tableView = self.tableView;
	//[self.tableView removeFromSuperview];
	[self.view addSubview:_webView];
	//[self.view addSubview:churchTableView.view];
	//_webView.hidden = YES;
	[_webView sizeToFit];
	_tableView.hidden = YES;
	
	
	_slideView = [[UIView alloc] initWithFrame:  CGRectMake(0, 374, 320, 42)];
	_slideView.backgroundColor = [UIColor blackColor];
	[_slideView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	
	_flexSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil ] autorelease];
	_rewindButton = [[UIBarButtonItem alloc]  
					 initWithBarButtonSystemItem:UIBarButtonSystemItemRewind  
					 target:self
					 action:@selector(backwardTrack)];
	
	_playButton = [[UIBarButtonItem alloc]  
				   initWithBarButtonSystemItem:UIBarButtonSystemItemPlay   
				   target:self
				   action:@selector(playAudio)];
	
	_forwardButton = [[UIBarButtonItem alloc] 
					  initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
					  target:self
					  action:@selector(forwardTrack)];
	
	
	
	_churchToolBar =  [[UIToolbar alloc] initWithFrame:  CGRectMake(0, 330, 320, 55)]; 
	_churchToolBar.tintColor = [UIColor blackColor];
	
	_itemsPlay = [[NSMutableArray arrayWithObjects:_flexSpace,_rewindButton,_flexSpace,_playButton,_flexSpace,_forwardButton,_flexSpace,nil] retain];
	_churchToolBar.items = _itemsPlay;
	
	//_pauseButton.hidden = YES;
	
	
	
	[self.view addSubview:_churchToolBar];
	[self.view addSubview:_slideView];
	
	_churchToolBar.hidden = NO;
	_slideView.hidden = NO;
	scrubber = [ [ UISlider alloc ] initWithFrame: CGRectMake(20, 0, 241, 22) ];
	scrubber.minimumValue = 0.0;
	scrubber.value = 0;
	scrubber.continuous = YES;
	//[scubberControl addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	
	scrubberLabel = [ [ UILabel alloc ] initWithFrame: CGRectMake(269, 0, 42, 21) ];
	scrubberLabel.text = @"0:00";
	scrubberLabel.backgroundColor = [UIColor blackColor];
	scrubberLabel.textColor = [UIColor whiteColor];
	
	[_slideView addSubview:scrubber];
	[_slideView addSubview:scrubberLabel];
	
	[_churchToolBar sizeToFit];
	[_slideView sizeToFit];
	
	

	
					_musicButton = [[UIBarButtonItem alloc]  
									initWithImage:[UIImage imageNamed:@"Note.png"]
									style:UIBarButtonItemStyleBordered  
									target:self
									action:@selector(flip)];
	//self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"arrow.png"];
	//self.navigationItem.backBarButtonItem.image = [UIImage imageNamed:@"arrow.png"];
	//self.navigationItem.backBarButtonItem = _backButton;
	self.navigationItem.rightBarButtonItem = _musicButton;
	
	
	//self.tableView.hidden = YES;
	//_webView.hidden = NO;
	//TT_RELEASE_SAFELY(_backButton);
	TT_RELEASE_SAFELY(_musicButton);
	
	
}

- (void) temp {
	
}

- (void) forwardTrack {
    _hasPreparedToPlay = NO;
    
    if (_player != nil && _player.playing) {
		_player.stop;
    }
    
    _songIndex++;
    
    SongDataSource *sd = self.dataSource;
    
    if( _songIndex > [sd.songsTemp count] -1 ) {
        _songIndex = 0;
    }
    
    [self playNextSongIndex];
	
}

- (void) backwardTrack {
    _hasPreparedToPlay = NO;
    
    if (_player != nil && _player.playing) {
		_player.stop;
    }
    
    _songIndex--;
    
    SongDataSource *sd = self.dataSource;
    
    if( _songIndex < 0) {
        _songIndex = 0;
    }
    
    [self playNextSongIndex];
	
}

- (void) loadView {
	[super loadView];
	[self setup];
		
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
	
	if (_player.playing) {
		_player.stop;
        _hasPreparedToPlay = NO;
    }
	
    //[super didSelectObject:object atIndexPath:indexPath];
	TTTableButton *item = (TTTableButton *)object;
	
	
	NSArray *split = [item.text componentsSeparatedByString:@"("];
	
	//NSLog(@"selected object %@ %@", item.text,indexPath.row);
	
	NSString *trimmedString = [[split objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

	if( [self prepAudioWithFileName: trimmedString] ) {
        _hasPreparedToPlay = YES;
		[self playAudio];
	} else {
		NSLog(@"Error playing file");
	}
	
	//TT_RELEASE_SAFELY(trimmedString);
	//TT_RELEASE_SAFELY(split);
	//TT_RELEASE_SAFELY(item);
}

- (void) flip {
	
	if( _tableView.hidden == YES ) {
		_tableView.hidden = NO;
		_webView.hidden = YES;
		_slideView.hidden = NO;
		_churchToolBar.hidden = NO;
		
		
		
		_musicButton = [[UIBarButtonItem alloc]  
						initWithImage:[UIImage imageNamed:@"Star.png"]
						style:UIBarButtonItemStyleBordered  
						target:self
						action:@selector(flip)];
		[self.navigationItem setRightBarButtonItem:_musicButton animated:NO];
		TT_RELEASE_SAFELY(_musicButton);
		
	} else {
		_tableView.hidden = YES;
		_webView.hidden = NO;
		
		if(_player.playing) {
			_slideView.hidden = NO;
			_churchToolBar.hidden = NO;
		} else {
			_slideView.hidden = YES;
			_churchToolBar.hidden = YES;
		}
		_musicButton = [[UIBarButtonItem alloc]  
						initWithImage:[UIImage imageNamed:@"Note.png"]
						style:UIBarButtonItemStyleBordered  
						target:self
						action:@selector(flip)];
		[self.navigationItem setRightBarButtonItem:_musicButton animated:NO];
		TT_RELEASE_SAFELY(_musicButton);
	}
	
	
	/*
	UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
	
	[button addTarget:self action:@selector(infoPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	if( _isWebShowing == YES ) {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.tableView cache:NO];

		[_webView removeFromSuperview];
		_isWebShowing = NO;
		[UIView commitAnimations];
	} else {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tableView cache:NO];

		[self.tableView addSubview:_webView];
		
		_isWebShowing = YES;	
		[UIView commitAnimations];
	}
*/
	//[UIView commitAnimations];
	
	
}
- (void) pauseAudio {
	[_itemsPlay replaceObjectAtIndex:3 withObject:SYSBARBUTTON(UIBarButtonSystemItemPlay, self, @selector(playAudio))];
	[_churchToolBar setItems:_itemsPlay];
	
	if (_player.playing) 
		[_player pause];
}

- (void) playAudio {
	if (_player) {
		if(_hasPreparedToPlay == YES && _player.playing == YES) {
			_player.stop;
            _hasPreparedToPlay = NO;
        } else {
            [_player play];
        }
    }
    
    if( _hasPreparedToPlay == NO ) {
            
        [self playNextSongIndex];
        
    }

	
	
	[_itemsPlay replaceObjectAtIndex:3 withObject:SYSBARBUTTON(UIBarButtonSystemItemPause, self, @selector(pauseAudio))];
	[_churchToolBar setItems:_itemsPlay];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
	scrubber.enabled = YES;
}

-(void) playNextSongIndex {
    SongDataSource *sd = self.dataSource;
    NSString *songTitle = [sd.songsTemp objectAtIndex:_songIndex];
    
    if([self prepAudioWithFileName: songTitle] == YES){
        _hasPreparedToPlay = YES;
        [_player play];
    }
}
//
//- (void)viewWillAppear:(BOOL)animated {
//       
//    self.navigationBarTintColor =  TTSTYLEVAR(navigationBarTintColorDark);
//    
//    [super viewWillAppear:animated];
//}

- (void)viewWillDisappear:(BOOL)animated {
		if(_player.playing)
			_player.stop;
	
	
}

- (BOOL) prepAudioWithFileName:(NSString *)fileName {
	NSError *error;
	
	//if (![[NSFileManager defaultManager] pathForResources:[[NSBundle mainBundle] pathForResource: @"Tisket" ofType:@"mp3"]]) 
	//	return NO;
	
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.mp3", [[NSBundle mainBundle] resourcePath], fileName]];

	//NSURL *u = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"Tisket"  ofType:@"mp3"]];
	
	//NSLog("url %@",u);
	_player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	if (!_player) {
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	
	[_player prepareToPlay];
	
	_player.delegate = self;
	[_itemsPlay replaceObjectAtIndex:3 withObject:SYSBARBUTTON(UIBarButtonSystemItemPlay, self, @selector(playAudio))];

	return YES;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	
	[_itemsPlay replaceObjectAtIndex:3 withObject:SYSBARBUTTON(UIBarButtonSystemItemPlay, self, @selector(playAudio))];
	scrubber.value = 0.0f;
	scrubber.enabled = NO;
	//[self prepAudio];
}

- (void) updateMeters
{
	[_player updateMeters];
	
	//self.title = [NSString stringWithFormat:@"%@ of %@", [self formatTime:self.player.currentTime], [self formatTime:self.player.duration]];
	scrubber.value = (_player.currentTime / _player.duration);
	scrubberLabel.text = [NSString stringWithFormat:@"%.2f", scrubber.value];
}

- (void) scrubbingDone: (id) sender
{
	[self playAudio];
}

- (void) scrub: (id) sender
{
	// Pause the player
	[_player pause];
	
	// Calculate the new current time
	_player.currentTime = scrubber.value * _player.duration;
	
	// Update the title, nav bar
	self.navigationItem.rightBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemPlay, self, @selector(playAudio));
}


- (void)dealloc {
	
	TT_RELEASE_SAFELY(scrubber);
	TT_RELEASE_SAFELY(scrubberLabel);
	TT_RELEASE_SAFELY(_churchName);
	TT_RELEASE_SAFELY(_churchToolBar);
	TT_RELEASE_SAFELY(_webView);
	TT_RELEASE_SAFELY(_slideView);
	TT_RELEASE_SAFELY(_playButton);
	TT_RELEASE_SAFELY(_pauseButton);
	TT_RELEASE_SAFELY(_itemsPlay);
	
	[super dealloc];
}

@end
