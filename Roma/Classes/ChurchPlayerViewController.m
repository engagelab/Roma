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
#import <AudioToolbox/AudioToolbox.h>


@implementation ChurchPlayerViewController

@synthesize churchName = _churchName, path = _path, player = _player;


BOOL _paused = YES;
BOOL _isWebShowing = YES;
BOOL _hasPreparedToPlay = NO;
int _songIndex = 0;
UITableView *_tableView;
int tempIndex = 0;

// Audio session callback function for responding to audio route changes. If playing 
//		back application audio when the headset is unplugged, this callback pauses 
//		playback and displays an alert that allows the user to resume or stop playback.
//
//		The system takes care of iPod audio pausing during route changes--this callback  
//		is not involved with pausing playback of iPod audio.
void audioRouteChangeListenerCallback (
                                       void                      *inUserData,
                                       AudioSessionPropertyID    inPropertyID,
                                       UInt32                    inPropertyValueSize,
                                       const void                *inPropertyValue
                                       ) {
	
	// ensure that this callback was invoked for a route change
	if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
    
	// This callback, being outside the implementation block, needs a reference to the
	//		MainViewController object, which it receives in the inUserData parameter.
	//		You provide this reference when registering this callback (see the call to 
	//		AudioSessionAddPropertyListener).
	ChurchPlayerViewController *controller = (ChurchPlayerViewController *) inUserData;
	
	// if application sound is not playing, there's nothing to do, so return.
	if (controller.player.playing == 0 ) {
        
		NSLog (@"Audio route change while application audio is stopped.");
		return;
		
	} else {
        
		// Determines the reason for the route change, to ensure that it is not
		//		because of a category change.
		CFDictionaryRef	routeChangeDictionary = inPropertyValue;
		
		CFNumberRef routeChangeReasonRef =
        CFDictionaryGetValue (
                              routeChangeDictionary,
                              CFSTR (kAudioSession_AudioRouteChangeKey_Reason)
                              );
        
		SInt32 routeChangeReason;
		
		CFNumberGetValue (
                          routeChangeReasonRef,
                          kCFNumberSInt32Type,
                          &routeChangeReason
                          );
		
		// "Old device unavailable" indicates that a headset was unplugged, or that the
		//	device was removed from a dock connector that supports audio output. This is
		//	the recommended test for when to pause audio.
		if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
            
			[controller.player pause];
			NSLog (@"Output device removed, so application audio was paused.");
            
			UIAlertView *routeChangeAlertView = 
            [[UIAlertView alloc]	initWithTitle: NSLocalizedString (@"Playback Paused", @"Title for audio hardware route-changed alert view")
                                       message: NSLocalizedString (@"Audio output was changed", @"Explanation for route-changed alert view")
                                      delegate: controller
                             cancelButtonTitle: NSLocalizedString (@"StopPlaybackAfterRouteChange", @"Stop button title")
                             otherButtonTitles: NSLocalizedString (@"ResumePlaybackAfterRouteChange", @"Play button title"), nil];
			[routeChangeAlertView show];
			// release takes place in alertView:clickedButtonAtIndex: method
            
		} else {
            
			NSLog (@"A route change occurred that does not require pausing of application audio.");
		}
	}
}
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
	
    int labelHeight = 21;
    
	_churchToolBar.hidden = NO;
	_slideView.hidden = NO;
	scrubber = [ [ UISlider alloc ] initWithFrame: CGRectMake(20 , 0, 241, 22) ];
	scrubber.minimumValue = 0.0;
	scrubber.value = 0;
	scrubber.continuous = YES;
	[scrubber addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	
	scrubberLabel = [ [ UILabel alloc ] initWithFrame: CGRectMake(269, 0, 42, labelHeight) ];
	scrubberLabel.text = @"0:00";
	scrubberLabel.backgroundColor = [UIColor blackColor];
	scrubberLabel.textColor = [UIColor whiteColor];
	
	[_slideView addSubview:scrubber];
	[_slideView addSubview:scrubberLabel];
	
    trackLabel = [ [ UILabel alloc ] initWithFrame: CGRectMake(20, 0+labelHeight+2, 241, labelHeight) ];
	trackLabel.text = @"";
    trackLabel.font = [UIFont boldSystemFontOfSize:10];
	trackLabel.backgroundColor = [UIColor blackColor];
	trackLabel.textColor = [UIColor whiteColor];
	
	[_slideView addSubview:trackLabel];
    
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
    
    if (_player) {
        
        if( _player.playing == YES ) {
          
            _player.stop;
            _player.currentTime = 0;
            [self updateMeters];
        }
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
    
    if( _player.playing == YES ) {
        _player.stop;
        _player.currentTime = 0;
        [self updateMeters];
    }
    
    _songIndex--;
    

    
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

    trackLabel.text = trimmedString;
    
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
		//_slideView.hidden = NO;
		//_churchToolBar.hidden = NO;
		
		
		
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
			//_slideView.hidden = NO;
			//_churchToolBar.hidden = NO;
		} else {
			//_slideView.hidden = YES;
			//_churchToolBar.hidden = YES;
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
    [self showPlayButton];
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

	
	
	[self showPauseButton];
    
	[_churchToolBar setItems:_itemsPlay];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
	scrubber.enabled = YES;
}

-(void) showPauseButton {
    [_itemsPlay replaceObjectAtIndex:3 withObject:SYSBARBUTTON(UIBarButtonSystemItemPause, self, @selector(pauseAudio))];
}

-(void) showPlayButton {
	[_itemsPlay replaceObjectAtIndex:3 withObject:SYSBARBUTTON(UIBarButtonSystemItemPlay, self, @selector(playAudio))];
}


-(void) playNextSongIndex {
    SongDataSource *sd = self.dataSource;
    NSString *songTitle = [sd.songsTemp objectAtIndex:_songIndex];
    

    
    NSString *trackNumber = [NSString stringWithFormat:@"%d. ", _songIndex+1];
    
    trackLabel.text = [trackNumber stringByAppendingString:songTitle];
    if([self prepAudioWithFileName: songTitle] == YES){
        _hasPreparedToPlay = YES;
        [_player play];
        [self showPauseButton];
        
    }
}

- (BOOL) prepAudioWithFileName:(NSString *)fileName {
	NSError *error;
	
	//if (![[NSFileManager defaultManager] pathForResources:[[NSBundle mainBundle] pathForResource: @"Tisket" ofType:@"mp3"]]) 
	//	return NO;
	
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.mp3", [[NSBundle mainBundle] resourcePath], fileName]];

	//NSURL *u = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"Tisket"  ofType:@"mp3"]];
	
	//NSLog("url %@",u);

    
    
    if(!_player ) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [_player setDelegate: self];
    } else {
        TT_RELEASE_SAFELY(_player);
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [_player setDelegate: self];
    }
    
	if (!_player) {
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	
	[_player prepareToPlay];
	
	[self showPauseButton];
//	[_itemsPlay replaceObjectAtIndex:3 withObject:SYSBARBUTTON(UIBarButtonSystemItemPlay, self, @selector(playAudio))];

	return YES;
}




- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	
    [self showPlayButton];
    
//	[_itemsPlay replaceObjectAtIndex:3 withObject:SYSBARBUTTON(UIBarButtonSystemItemPlay, self, @selector(playAudio))];
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

- (BOOL) canBecomeFirstResponder {
    return YES;
}

/* The iPod controls will send these events when the app is in the background */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if( _player.playing == YES ) {
                    [_player pause];
                    [self showPauseButton];
                } else {
                    [_player play];
                    [self showPlayButton];
                }
                break;
            case UIEventSubtypeRemoteControlPlay:
                [_player play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [_player pause];
                break;
            case UIEventSubtypeRemoteControlStop:
                [_player stop];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self forwardTrack];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self backwardTrack];
                break;
            default:
                break;
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    
    if(_player.playing)
        _player.stop;
	
    
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}


- (void) viewDidAppear:(BOOL)animated {
	
    

	
    [super viewDidAppear:animated];
    
    // Registers this class as the delegate of the audio session.
	[[AVAudioSession sharedInstance] setDelegate: self];
	
	// The AmbientSound category allows application audio to mix with Media Player
	// audio. The category also indicates that application audio should stop playing 
	// if the Ring/Siilent switch is set to "silent" or the screen locks.
	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    
	UInt32 doSetProperty = 0;
	AudioSessionSetProperty ( kAudioSessionProperty_OverrideCategoryMixWithOthers,
                             sizeof (doSetProperty),
                             &doSetProperty
                             );
    
    
    // Registers the audio route change listener callback function
	AudioSessionAddPropertyListener (
                                     kAudioSessionProperty_AudioRouteChange,
                                     audioRouteChangeListenerCallback,
                                     self
                                     );
    
	// Activates the audio session.
	
	NSError *activationError = nil;
	[[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    
    UIApplication *application = [UIApplication sharedApplication];
	if([application respondsToSelector:@selector(beginReceivingRemoteControlEvents)])
		[application beginReceivingRemoteControlEvents];
    
    [self becomeFirstResponder];
    
	TTDPRINT(@"viewDidAppear");
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
    TT_RELEASE_SAFELY(_player);
	
	[super dealloc];
}



@end
