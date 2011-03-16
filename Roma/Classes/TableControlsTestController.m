#import "TableControlsTestController.h"
#import "ChurchDataSource.h"
#import "ChurchSingleton.h"
#import "Church.h"
#import "PlaceMark.h"


@implementation TableControlsTestController

@synthesize locManager;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.autoresizesForKeyboard = YES;
        self.variableHeightRows = YES;
        self.dataSource = [[[ChurchDataSource alloc] init] autorelease];

        
//        self.title = @"Three20 Catalog";
//        self.navigationItem.backBarButtonItem =
//        [[[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStyleBordered
//                                         target:nil action:nil] autorelease];
//        
//        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (id)init {
  if ((self = [super init])) {
    //self.tableViewStyle = UITableViewStyleGrouped;
    self.autoresizesForKeyboard = YES;
    self.variableHeightRows = YES;
	self.dataSource = [[[ChurchDataSource alloc] init] autorelease];
  }
  return self;
}

- (void)loadView {
	[super loadView];
	
	self.title = @"Roma Churches";
	
	self.tableView.frame = CGRectMake(0,0,320,372);
	//self.navigationBarTintColor = [UIColor whiteColor];
	
	_toolbar =  [[UIToolbar alloc] initWithFrame:  CGRectMake(0, 372, 320, 44)]; 
	
    TTDefaultStyleSheet *ttstyle = TTStyleSheet.globalStyleSheet;
    _toolbar.tintColor = [ttstyle navigationBarTintColor];
    
	UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil ] autorelease];
	
	UIBarButtonItem *anotherButton = [[[UIBarButtonItem alloc]  
									   initWithImage:[UIImage imageNamed:@"Location.png"]
									   style:UIBarButtonItemStyleBordered  
									   target:self  
									   action:@selector(updateTableLocations:)] autorelease];
	
	
	[self initMapView];
	
	
	
	
	
	NSArray *buttonNames = [NSArray arrayWithObjects:@"List", @"Map", nil];
	_segmentedControl = [[UISegmentedControl alloc] initWithItems:buttonNames];
	_segmentedControl.momentary = NO;
	_segmentedControl.selectedSegmentIndex = 0;
	
	_segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	_segmentedControl.frame = CGRectMake(61, 8, 239, 30);
    _segmentedControl.tintColor = ttstyle.navigationBarTintColor;
	[_segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	UIBarButtonItem *pLogOut = [[UIBarButtonItem alloc] initWithCustomView:_segmentedControl];
	
	NSArray *items = [NSArray arrayWithObjects:anotherButton,flexItem,pLogOut,nil];
	_toolbar.items = items;
	
	[self.view addSubview:_toolbar];
	[_toolbar sizeToFit];
	
	
	
	
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Location manager error: %@", [error description]);
	return;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	
	NSMutableArray *churches = [[ChurchSingleton sharedInstance] churches];
	
	for (Church *church in churches) {
		
		NSLog(@"long %@ lat %@",church.longitude, church.latitude);
		
		//CLLocation *userLoc = [[CLLocation alloc] initWithCoordinate:_mapView.userLocation.coordinate];
		
		CLLocation *location1 = [[CLLocation alloc] initWithLatitude: [church.latitude doubleValue] longitude: [church.longitude doubleValue]];
		
		
		
		CLLocationDistance target = [newLocation distanceFromLocation:location1];
		
		
//		NSInteger myInteger = (NSInteger)( target / 1000);
		
		NSString *str = [NSString stringWithFormat:@"%1.2f", ( target / 1000)];
		
		church.distanceAway = str;
		NSLog(@"NEW DIS %@ \n",str);

	}
	
	NSMutableArray *sortedArray = [NSMutableArray arrayWithArray: [churches sortedArrayUsingSelector:@selector(compare:)] ];
	
	for (Church *church in sortedArray) {
		
		NSLog(@"new sorted distance %@",church.distanceAway);
				
	}
	
	[[[ChurchSingleton sharedInstance] churches] removeAllObjects];
	
	
	for (Church *church in sortedArray) {
		[[[ChurchSingleton sharedInstance] churches] addObject:church];
		
		
	}
	
	
	[self.dataSource tableViewDidLoadModel: nil];
	//[ChurchSingleton sharedInstance] churches 
	//[[[self dataSource ] churchModel: sortedArray];

	[self.tableView reloadData] ;
	[self reload]; 
	NSLog(@"newLocation %@\n", [newLocation description]);
	[_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate
							 animated:YES];
}

- (void) initMapView {
	_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,320,372)];  
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
	_mapView.hidden = YES;
	_mapView.showsUserLocation = YES;
	
	[_mapView.userLocation addObserver:self forKeyPath:@"location" options:0 context:NULL];

			
    [NSThread detachNewThreadSelector:@selector(displayMap) toTarget:self withObject:nil];

}

-(void)observeValueForKeyPath:(NSString *)keyPath  
                     ofObject:(id)object  
                       change:(NSDictionary *)change  
                      context:(void *)context {  
	
	
    if ([_mapView isUserLocationVisible]) {  
		NSLog(@"user update");
		[_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
        //[self moveOrZoomOrAnythingElse];
        // and of course you can use here old and new location values
    }
}

-(void) displayMap {  

	MKCoordinateRegion region;  
    MKCoordinateSpan span;  
    span.latitudeDelta=0.016673;  
    span.longitudeDelta=0.041718;  
	
	
    CLLocationCoordinate2D location;  
    location.latitude = 41.893142;  
    location.longitude = 12.486436;  
    region.span=span;  
    region.center=location;  
	
	
	NSMutableArray *myArray = [[[NSMutableArray alloc] init] autorelease];
	
	NSMutableArray *churches = [[ChurchSingleton sharedInstance] churches];
	
    [_mapView setRegion:region animated:TRUE];  
    [_mapView regionThatFits:region];  
	
	
	for (Church *church in churches) {
		
		CLLocationCoordinate2D pinlocation;
		pinlocation.latitude = [church.latitude doubleValue];
		pinlocation.longitude  = [church.longitude doubleValue];
		PlaceMark *poi = [[PlaceMark alloc] initWithCoordinate:pinlocation];
		poi.churchName = church.churchId;
		poi.title = church.name;

		
		NSLog(@"long %@ lat %@",church.longitude, church.latitude);
		
		[myArray addObject: poi];
	}
	
	[_mapView addAnnotations: myArray];

	
}  

- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	if ( annotation == _mapView.userLocation )
		return nil;
	
	MKPinAnnotationView *pin = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier: [annotation title]];
	if (pin == nil)
	{
		pin = [[[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: [annotation title] ] autorelease];
	}
	else
	{
		pin.annotation = annotation;
	}
	
	
	// Set up the Left callout
	UIButton *myDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	myDetailButton.frame = CGRectMake(0, 0, 23, 23);
	myDetailButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	myDetailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	//[myDetailButton addTarget:self action:@selector(navigateWithChurchId:pm.churchId) forControlEvents:UIControlEventTouchUpInside];
	pin.rightCalloutAccessoryView = myDetailButton;

	

	
	pin.pinColor = MKPinAnnotationColorRed;
	pin.animatesDrop = YES;
	pin.canShowCallout = YES;
	pin.calloutOffset = CGPointMake(-5, 5);
	return pin;
	
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	
	PlaceMark *pm = (PlaceMark *)view.annotation;
	
	//NSLog(@"churchName %@",pm.churchName);
	
	TTOpenURL([NSString stringWithFormat:@"tt://outsideChurchView/%@", pm.churchName]);

	
}

- (void) navigateWithChurchId: (NSString*) churchId {
	
}

- (void) updateTableLocations : (id) sender {

	self.locManager = [[[CLLocationManager alloc] init] autorelease];
	if (![CLLocationManager locationServicesEnabled]) {
		//NSLog(@"user has opted out of location services");
		return;
	}
	
	self.locManager.delegate = self;
	self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
	
	self.locManager.distanceFilter = 1.0f; // in meters
	[self.locManager startUpdatingLocation];
}

-(void) segmentAction: (id) sender {
	switch([sender selectedSegmentIndex])
	{
		case 0: 
			_mapView.hidden = YES;
		    self.tableView.hidden = NO;
			break;
		case 1:
			_mapView.hidden = NO;
		    self.tableView.hidden = YES;
			break;
		default: break;
	}
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_mapView);
	TT_RELEASE_SAFELY(_segmentedControl);
	TT_RELEASE_SAFELY(_toolbar);
    [super dealloc];
}


@end
