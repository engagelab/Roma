//
//  PlaceMark.h
//  HyperMediaPlayerApp
//
//  Created by Anthony John Perritano on 3/26/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>  
#import <MapKit/MapKit.h>  

@interface PlaceMark : NSObject <MKAnnotation> {  
    CLLocationCoordinate2D coordinate;  
    NSString *subtitle;  
    NSString *title; 
	 NSString *churchName;
}  
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;  
@property (nonatomic, retain) NSString *title;  
@property (nonatomic, retain) NSString *subtitle; 
@property (nonatomic, retain) NSString *churchName;  


-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;  

@end  

