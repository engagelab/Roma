//
//  TableDefaultStyleSheet.h
//  BasicNavigationApp
//
//  Created by Anthony John Perritano on 3/22/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//


#import "TTDefaultStyleSheet.h"


@interface TableDefaultStyleSheet : TTDefaultStyleSheet

@property(nonatomic,readonly) UIColor* myHeadingColor;
@property(nonatomic,readonly) UIColor* mySubtextColor;
@property(nonatomic,readonly) UIFont* myHeadingFont;
@property(nonatomic,readonly) UIFont* mySubtextFont;

@end
