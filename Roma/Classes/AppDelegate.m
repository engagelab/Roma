//
//  HyperMediaPlayerAppAppDelegate.m
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/11/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "AppDelegate.h"

#import "TableControlsTestController.h"
#import "APXML.h"
#import "Church.h"
#import "Song.h"
#import "ChurchSingleton.h"
#import "ChurchViewController.h"
#import "ChurchPlayerViewController.h"
#import "StyleSheet.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(UIApplication *)application {

//  [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
  [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
  [TTExtensionLoader loadAllExtensions];
    
  [self parseXML];
	
  [TTStyleSheet setGlobalStyleSheet:[[[StyleSheet alloc] init] autorelease]];  
	
  TTNavigator* navigator = [TTNavigator navigator];
  //navigator.persistenceMode = TTNavigatorPersistenceModeAll;
  navigator.window = [[[UIWindow alloc] initWithFrame:TTScreenBounds()] autorelease];
	
  TTURLMap* map = navigator.URLMap;

  [map from:@"*" toViewController:[TTWebController class]];
	
	// The tab bar controller is shared, meaning there will only ever be one created.  Loading
	// This URL will make the existing tab bar controller appear if it was not visible.
	[map from:@"tt://tableControlsTest" toViewController:[TableControlsTestController class]];
	[map from:@"tt://outsideChurchView/(initWithChurchName:)" toViewController:[ChurchViewController class]];
	[map from:@"tt://churchPlayerView/(initWithChurchName:)" toViewController:[ChurchPlayerViewController class]];


	
	//[map from:@"tt://churchView?type=(initWithType:)&church=()" toViewController:[ChurchViewController class]];
	// Menu controllers are also shared - we only create one to show in each tab, so opening
	// these URLs will switch to the tab containing the menu
	//[map from:@"tt://menu/(initWithMenu:)" toSharedViewController:[MenuController class]];
	
		
	// Before opening the tab bar, we see if the controller history was persisted the last time
	if (![navigator restoreViewControllers]) {
		// This is the first launch, so we just start with the tab bar
		[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://tableControlsTest"]];
	}
}

- (void) parseXML {
	
    NSString *xmlString = [NSString stringWithContentsOfFile:TTPathForBundleResource(@"churches.xml") encoding:NSUTF8StringEncoding error:nil];  
    
    
    //	NSString *xmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"churches" ofType:@"xml"]];
	APDocument *doc = [APDocument documentWithXMLString:xmlString];
	APElement *rootElement = [doc rootElement];
	NSLog(@"Root Element Name: %@", rootElement.name);
	
	// get all the child elements (each book)
	NSArray *childs = [rootElement childElements];
	
	for (APElement *child in childs) {
		
		NSLog(@"church id: %@", [child valueForAttributeNamed:@"id"] );
		
		//Church *church = [[Church alloc] initWithId:[child valueForAttributeNamed:@"id"]];
		
		Church *church = [[Church alloc] initWithId:[child valueForAttributeNamed:@"id"]];
		church.churchId = [child valueForAttributeNamed:@"id"];
		NSArray *subElements = [child childElements];
		
		
		
		for (APElement *subElement in subElements) {
			
			if([subElement.name isEqualToString:@"name"]) {
				TTDINFO(@"name: %@", subElement.value);
				church.name = subElement.value;
			} else if([subElement.name isEqualToString:@"description"]) {
				TTDINFO(@"description: %@", subElement.value);
			} else if([subElement.name isEqualToString:@"icon"]) {
				TTDINFO(@"icon: %@", subElement.value);
				church.icon = subElement.value;
			} else if([subElement.name isEqualToString:@"contentPage"]) {
				TTDINFO(@"contentPage: %@", subElement.value);
				church.contentPage = subElement.value;
			} else if ([subElement.name isEqualToString:@"longitude"]) {
				church.longitude = [[NSNumber alloc] initWithDouble:subElement.value.doubleValue];
				TTDINFO(@"long: %@", church.longitude);
			} else if ([subElement.name isEqualToString:@"latitude"]) {
				church.latitude = [[NSNumber alloc] initWithDouble:subElement.value.doubleValue];
				TTDINFO(@"lat: %@", church.latitude);
			} else if ([subElement.name isEqualToString:@"songs"]) {
				NSArray *songs = [subElement childElements];
                
                
				NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease]; 
				for (APElement *song in songs) {
					if( [song.name isEqualToString:@"song"] ) {
						
						Song *newSong = [[Song alloc] initWithId: [song valueForAttributeNamed:@"id"] ];
						newSong.time =[song valueForAttributeNamed:@"time"];
						newSong.name = song.value;
						
						NSLog(@"song %@",[newSong description]);
						
						[array addObject:newSong];
					}
				}
				church.songs = array;
				
			}
		}
		
		church.distanceAway = @"0";
	    NSLog(@"THE CHURCH: %@", church );
		[[[ChurchSingleton sharedInstance] churches] addObject: church];
		//[[ChurchSingleton sharedInstance] test];
	}
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
    return YES;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
    return YES;
}

@end
