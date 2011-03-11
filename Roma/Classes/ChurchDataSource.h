//
//  ChurchDataSource.h
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChurchModel.h"
#import "TTListDataSource.h"

@interface ChurchDataSource : TTListDataSource {
	ChurchModel *_churchModel;
}

@property(nonatomic,readonly) ChurchModel *churchModel;

@end
