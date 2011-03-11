//
//  TableDefaultStyleSheet.m
//  BasicNavigationApp
//
//  Created by Anthony John Perritano on 3/22/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "TableDefaultStyleSheet.h"
#import "TTStyle.h"
#import "TTShape.h"
#import "TTURLCache.h"


@implementation TableDefaultStyleSheet

///////////////////////////////////////////////////////////////////////////////////////////////////
// styles

///////////////////////////////////////////////////////////////////////////////////////////////////
// public colors

- (UIColor*)myHeadingColor {
	return RGBCOLOR(80, 110, 140);
}

- (UIColor*)mySubtextColor {
	return [UIColor grayColor];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// public fonts

- (UIFont*)myHeadingFont {
	return [UIFont boldSystemFontOfSize:16];
}

- (UIFont*)mySubtextFont {
	return [UIFont systemFontOfSize:13];
}

@end
