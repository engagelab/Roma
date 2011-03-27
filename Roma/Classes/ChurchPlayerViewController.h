//
//  ChuchPlayerViewController.h
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define SYSBARBUTTON(ITEM, TARGET, SELECTOR) [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:TARGET action:SELECTOR] autorelease]


@interface ChurchPlayerViewController : TTTableViewController <AVAudioPlayerDelegate> {
	NSString *_churchName;
	UIToolbar *_churchToolBar;
	UIWebView *_webView;
	UIView *_slideView;
	UISlider *_slider;
	UIBarButtonItem *_playButton;
	UIBarButtonItem *_pauseButton;
	UIBarButtonItem *_flexSpace;
	UIBarButtonItem *_rewindButton;
	UIBarButtonItem *_forwardButton;
	NSMutableArray *_itemsPlay;
	AVAudioPlayer *_player;
	NSString *_path;
	NSTimer *timer;
	UISlider *scrubber;
	UILabel *scrubberLabel;
    UILabel *trackLabel;
	UIBarButtonItem *_musicButton;
	UIBarButtonItem *_webButton;
}

@property (nonatomic, retain) NSString* churchName;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSString *path;

- (void) playAudio;
@end