//
//  ChurchModel.h
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTModel.h"

@interface ChurchModel : NSObject <TTModel> {

	NSMutableArray *_churches;
	NSMutableArray* _delegates;
}

@property(nonatomic,retain) NSMutableArray *churches;

@end
