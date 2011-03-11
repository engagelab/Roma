//
//  TTTableSubtitleItemStyle.h
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/22/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TTTableSubtitleItemStyle : TTTableSubtitleItem {
	
	TTStyle* _imageStyle;

}

@property(nonatomic,retain) TTStyle* imageStyle;

+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL
      defaultImage:(UIImage*)defaultImage URL:(NSString*)URL accessoryURL:(NSString*)accessoryURL imageStyle:(TTStyle*)imageStyle;


@end
