
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TableControlsTestController : TTTableViewController <MKMapViewDelegate,MKAnnotation,CLLocationManagerDelegate> {
	UIToolbar *_toolbar;
	MKMapView *_mapView;
	UISegmentedControl *_segmentedControl;
	CLLocationManager *locManager;

}
@property (retain) CLLocationManager *locManager;

- (void) initMapView;


@end
