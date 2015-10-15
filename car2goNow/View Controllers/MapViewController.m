//
//  MapViewController.m
//  RideScout
//
//  Created by Brady Miller on 2/17/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#pragma mark - Imports

#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import <RideKit/NSDictionary+RKParser.h>
#import <RideKit/UIImageView+RKRotate.h>
#import <RideKit/UIImage+RKExtras.h>
#import "LocationManager.h"
#import "constantsAndMacros.h"
#import "RideIconsManager.h"
#import "Direction.h"
#import "RMMapView+Extras.h"
#import "UIImage+Circles.h"
#import "MintManager.h"
#import "DirectionsView.h"
#import "RSAlertView.h"
#import "RSLabel.h"
#import "EnterTextPopup.h"
#import "UnlockPopup.h"
#import "DirectionsManager.h"

#import "ProfileViewController.h"

#import "BCycleBookingController.h"
#import "TripManager.h"

#define WALKING_TURN_CENTER_COLOR [UIColor colorWithRed:9.0/255.0 green:128.0/255.0 blue:113.0/255.0 alpha:1.0]

#define CHECKMARK_IMAGE_PATH @"rent_icon.png"

#define WALKING_POLYLINE_ZPOSITION 100
#define WALKING_TURN_ZPOSITION 105
#define USER_LOCATION_ZPOSITION 600
#define SELECTED_RIDE_ZPOSITION 300
#define RIDE_NEARBY_ZPOSITION 200
#define TOP_RIDE_NEARBY_ZPOSITION 350

@interface MapViewController () <DirectionsViewDelegate, UIScrollViewDelegate> {
    // PopUps
    BOOL popupAnimating;
}

@property (nonatomic, strong) BookingController *bookingController;

@property (nonatomic, strong) RMMapView *mapView;
@property (nonatomic, weak) IBOutlet RSLabel *stationNameLabel;
@property (nonatomic, weak) IBOutlet RSLabel *distanceLabel;
@property (nonatomic, weak) IBOutlet RSLabel *docksLabel;
@property (nonatomic, weak) IBOutlet RSLabel *bikesLabel;

@property (nonatomic, weak) IBOutlet UIButton *profileButton;
@property (nonatomic, weak) IBOutlet UIButton *stepByStepButton;

@property (nonatomic, weak) IBOutlet UIButton *bookButton;
@property (nonatomic, weak) IBOutlet UIImageView *loadingImageView;
@property (nonatomic, weak) IBOutlet UILabel *bookLabel;

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *containerViewLeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *containerViewRightConstraint;

@property (nonatomic, weak) IBOutlet UIView *shadowOverlay;

@property (nonatomic, strong) DirectionsView *directionsView;

@property (nonatomic, strong) NSMutableArray *zoomCords;

@property (nonatomic, strong) RMAnnotation *selectedRideAnnotation;
@property (nonatomic, strong) NSArray *ridesNearbyAnnotations;
@property (nonatomic, strong) NSArray *walkingStepAnnotations;
@property (nonatomic, strong) RMAnnotation *walkingPolylineAnnotation;  //For clreaing line when loading directions

@property (nonatomic, strong) RMAnnotation *topLevelAnnoation;

// View Controllers
@property (nonatomic, strong) ProfileViewController *slideProfileViewController;
@property (nonatomic, strong) UISwipeGestureRecognizer *profileSwipGestureRecognizer;

@end

@implementation MapViewController {
    BOOL scrollingDown;
    BOOL directionsShown;
    BOOL directionsAnimating;
    BOOL headerHiden;
    CGFloat lastContentOffset;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapView];
    
    self.profileSwipGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didPressProfileButton:)];
    [self.profileSwipGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWalkingDirections) name:LOCATIONCHANGE object:nil];

//    [TripManager HITME];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.mapView = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self setupDirectionsView];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self blankCircleForButton:self.bookButton];
    
    self.navigationController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.mapView.showsUserLocation = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.mapView.showsUserLocation = NO;
}

- (void)appDidEnterBackground:(NSNotification *)notification {
    self.mapView.showsUserLocation = NO;
}

- (void)appWillBecomeActive:(NSNotification *)notification {
    self.mapView.showsUserLocation = YES;
}

#pragma mark - UI Setup

- (void)setupMapView {
    self.zoomCords = [[NSMutableArray alloc] init];
    
    RMMapboxSource *source = [[RMMapboxSource alloc] initWithMapID:@"ridescout.9pstxss9"];
    self.mapView = [[RMMapView alloc] initWithFrame:SCREEN andTilesource:source];
    self.mapView.zoom = 4;
    self.mapView.adjustTilesForRetinaDisplay = YES;
    self.mapView.userInteractionEnabled = YES;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView setShowLogoBug:NO];
    [self.mapView setHideAttribution:YES];
    [self.mapView setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    
    self.mapView.tileSourcesMinZoom = source.minZoom;
    self.mapView.tileSourcesMaxZoom = source.maxZoom;
    [self.mapView setMaxZoom:21];
    
    CLLocation *currentLocation = [[LocationManager sharedLocationManager] currentLocation];
    [self.mapView setCenterCoordinate:currentLocation.coordinate];
    
    [self.containerView addSubview:self.mapView];
    [self.containerView bringSubviewToFront:self.headerView];
    [self.containerView bringSubviewToFront:self.bookButton];
    [self.containerView bringSubviewToFront:self.bookLabel];
    [self.containerView bringSubviewToFront:self.loadingImageView];
}

- (void)setupDirectionsView {
    
    self.directionsView = [[DirectionsView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.headerView.frame.size.height)];
    self.directionsView.delegate = self;
    self.directionsView.userInteractionEnabled = YES;
    [self.view addSubview:self.directionsView];
}

#pragma mark - UI Updates

- (void)noRides {
    [self addRidesNearbyForProvider:self.provider];
    
    CLLocation *currentLocation = [[LocationManager sharedLocationManager] currentLocation];
    [self.mapView setCenterCoordinate:currentLocation.coordinate];
}

- (void)updatingRides {

}

- (void)showSelectedRide  {
    Ride *selectedRide = self.provider.selectedRide;
    [self updateHeaderInfoForRide:selectedRide];
    
    // Transit location property is the location of the first stop to get on
//    CLLocation *currentLocation = [[LocationManager sharedLocationManager] currentLocation];
//    double centerLat = (currentLocation.coordinate.latitude + selectedRide.location.coordinate.latitude) / 2;
//    double centerLng = (currentLocation.coordinate.longitude + selectedRide.location.coordinate.longitude) / 2;
//    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerLat longitude:centerLng];
//    [self.mapView setCenterCoordinate:centerLocation.coordinate];
    
//    CLLocation *currentLocation = [[LocationManager sharedLocationManager] currentLocation];
//    [self.mapView setCenterCoordinate:currentLocation.coordinate];
    
    // Only add annotations if the mapview is inititated and the annotations aren't already there
    [self addWalkingAnnotationsForRide:self.provider.selectedRide];
    if (!self.selectedRideAnnotation && self.mapView) [self addSelectedRideForProvider:self.provider];
    if (!self.ridesNearbyAnnotations && self.mapView) [self addRidesNearbyForProvider:self.provider];
}

- (void)loadingDirections {
    [self showLoadingAroundButton];
}

- (void)updateHeaderInfoForRide:(Ride *)ride {
    self.stationNameLabel.text = ride.name;
    
    // Set header information
    NSMutableDictionary *style = [[NSMutableDictionary alloc] init];
    [style setValue:[UIFont fontWithName:@"SFUIText-Regular" size:16] forKey:NSFontAttributeName];
    [style setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    NSMutableAttributedString *distanceString = [[NSMutableAttributedString alloc] initWithString:ride.distanceString attributes:style];
    NSMutableAttributedString *docksString = [[NSMutableAttributedString alloc] initWithString:[ride.docks stringValue] attributes:style];
    NSMutableAttributedString *bikesString = [[NSMutableAttributedString alloc] initWithString:[ride.bikes stringValue] attributes:style];
    
    [style setValue:BCYCLE_LIGHT_PURPLE forKey:NSForegroundColorAttributeName];
    
    [distanceString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", ride.distanceNameString] attributes:style]];
    [docksString appendAttributedString:[[NSAttributedString alloc] initWithString:@" DOCKS" attributes:style]];
    [bikesString appendAttributedString:[[NSAttributedString alloc] initWithString:@" BIKES" attributes:style]];
    
    self.distanceLabel.attributedText = distanceString;
    self.docksLabel.attributedText = docksString;
    self.bikesLabel.attributedText = bikesString;
}

#pragma mark - Walking Directional Methods

// This adds both the walking poyline lines and the walking annotations for the directions for either a normal ride or transit
- (void)addWalkingAnnotationsForRide:(Ride *)ride {
    if (self.walkingPolylineAnnotation) [self.mapView removeAnnotation:self.walkingPolylineAnnotation];
    if (self.walkingStepAnnotations) [self.mapView removeAnnotations:self.walkingStepAnnotations];
    
    // Polyline variables
    NSMutableArray *convertedStepArrays = [[NSMutableArray alloc] init];
    
    // Annotation variables
    NSMutableArray *stepAnnotations = [[NSMutableArray alloc] init];
    int i = 0;
    for (NSArray *directions in ride.walkingDirections) {
        // Polyline Variables
        NSMutableArray *polylines = [[NSMutableArray alloc] init];
        for (Direction *direction in directions) {
            // Polyline work
            [polylines addObject:direction.polyline];
            
            // Turn by turn annotations
            NSString *title = direction.instruction;
            CLLocation *startLoc = direction.startLocation;
            RMAnnotation *ann = [[RMAnnotation alloc] initWithMapView:self.mapView coordinate:startLoc.coordinate andTitle:title];
            ann.userInfo = direction;
            [ann setBoundingBoxFromLocations:@[startLoc]];
            [self.mapView addAnnotation:ann];
            [stepAnnotations addObject:ann];
            i++;
        }
        // Polyline Work
        NSArray *convertedPolyineCords = [self convertPolylinesToCoords:polylines];
        [convertedStepArrays addObject:convertedPolyineCords];
    }
    self.walkingStepAnnotations = [NSArray arrayWithArray:stepAnnotations];
    
    // Adding the polyline cords to the map
    i = 0;
    for (NSArray *stepCords in convertedStepArrays) {
        self.walkingPolylineAnnotation = [[RMAnnotation alloc] initWithMapView:self.mapView coordinate:((CLLocation *)[stepCords objectAtIndex:0]).coordinate andTitle:@"walking"];
        [self.walkingPolylineAnnotation setBoundingBoxFromLocations:stepCords];
        self.walkingPolylineAnnotation.userInfo = stepCords;
        [self.mapView addAnnotation:self.walkingPolylineAnnotation];
        i++;
    }
}

// Not for transit use
- (void)addSelectedRideForProvider:(Provider *)provider {
    if (self.selectedRideAnnotation) [self.mapView removeAnnotation:self.selectedRideAnnotation];
    self.selectedRideAnnotation = [self addAnnotationForRide:provider.selectedRide];
    self.selectedRideAnnotation.userInfo = provider.selectedRide;
    [self.mapView addAnnotation:self.selectedRideAnnotation];
}

// Not for transit use
- (void)addRidesNearbyForProvider:(Provider *)provider {
    if (self.ridesNearbyAnnotations) [self.mapView removeAnnotations:self.ridesNearbyAnnotations];
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    int i = 0;
    for (Ride *ride in provider.ridesNearby) {
        if ([ride isEqual:provider.selectedRide]) continue;
        RMAnnotation *rideAnn = [self addAnnotationForRide:ride];
        [annotations addObject:rideAnn];
//        if (i < 5) [self.zoomCords addObject:ride.location];
        i++;
    }
    
    [self.zoomCords addObject:provider.selectedRide.location];
    [self.zoomCords addObject:[LocationManager sharedLocationManager].currentLocation];
    
    [self.mapView zoomIntoMapWithCoords:self.zoomCords];
    [self.mapView setZoom:self.mapView.zoom - 4];
    self.ridesNearbyAnnotations = [NSArray arrayWithArray:annotations];
}

- (RMAnnotation *)addAnnotationForRide:(Ride *)ride {
    RMAnnotation *rideAnn = [[RMAnnotation alloc] initWithMapView:self.mapView coordinate:ride.location.coordinate andTitle:ride.name];
    NSMutableString *entireString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", ride.distanceString, ride.distanceNameString]];
    [entireString appendString:[NSString stringWithFormat:@"    %@ DOCKS", ride.docks]];
    [entireString appendString:[NSString stringWithFormat:@"    %@ BIKES", ride.bikes]];
    rideAnn.subtitle = [NSString stringWithString:entireString];
    rideAnn.userInfo = ride;
    [self.mapView addAnnotation:rideAnn];
    return rideAnn;
}

- (void)updateWalkingDirections {
    self.providerState = LoadingDirectionsToRide;
    [self showLoadingAroundButton];
    __weak __typeof__(self) weakSelf = self;
    [DirectionsManager getDirectionsForRide:self.provider.selectedRide withCompletion:^{
        weakSelf.providerState = RidesNearbyWithSelectedRide;
        [weakSelf stopLoadingAroundButton];
    } andFailure:^{
        //
    }];
}

#pragma mark - Map Delegate Methods

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation {
    if (annotation.isUserLocationAnnotation) {
        if ([annotation isKindOfClass:[RMUserLocation class]]) {
            RMMarker *currentLocationMarker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"current_user_map.png"]];
            currentLocationMarker.zPosition = USER_LOCATION_ZPOSITION;
            return currentLocationMarker;
        }
        else {
            return nil;
        }
    }
    
    if ([annotation.userInfo isKindOfClass:[Direction class]]) {
        UIImage *iconImage = [self getCircleWithDiameter:12 andColor:BCYCLE_LIGHT_PURPLE];
        iconImage = [iconImage circularImageWithBorderColor:BCYCLE_BLUE borderWidth:3.0];
        RMMarker *marker = [[RMMarker alloc] initWithUIImage:iconImage];
        marker.canShowCallout = YES;
        marker.zPosition = WALKING_TURN_ZPOSITION;
        return marker;
    }
    else if ([annotation.userInfo isKindOfClass:[Ride class]]) {
        Ride *ride = (Ride *)annotation.userInfo;
        BOOL selectedRide = ([ride isEqual:self.provider.selectedRide]);
        UIImage *providerIcon = [[RideIconsManager sharedCache] imageIconForURL:self.provider.iconUrl];
        UIImage *rideImage = (selectedRide) ? [UIImage imageWithImage:providerIcon scaledToSize:CGSizeMake(40, 40)] : [UIImage imageWithImage:providerIcon scaledToSize:CGSizeMake(20, 20)];
        // Add clear border to make tap zone bigger and change the call out offest so it isn't point to the clear
        rideImage = [self addCircleBorderToImage:rideImage withColor:[UIColor clearColor] withThickness:20];
        
        RMMarker *marker = [[RMMarker alloc] initWithUIImage:rideImage];
        marker.canShowCallout = YES;
        marker.calloutOffset = CGPointMake(0, 8);
        
        UIColor *buttonColor = (selectedRide) ? BCYCLE_LIGHT_GREY : BCYCLE_BLUE;
        NSMutableDictionary *style = [[NSMutableDictionary alloc] init];
        [style setValue:[UIFont fontWithName:@"SFUIText-Regular" size:14] forKey:NSFontAttributeName];
        [style setValue:buttonColor forKey:NSForegroundColorAttributeName];
        NSAttributedString *selectString = [[NSAttributedString alloc] initWithString:@"Select" attributes:style];
        
        UIButton *rightButton = [[UIButton alloc] init];
        [rightButton setAttributedTitle:selectString forState:UIControlStateNormal];
        [rightButton sizeToFit];
        
        marker.rightCalloutAccessoryView = rightButton;
        marker.zPosition = (selectedRide) ? SELECTED_RIDE_ZPOSITION : RIDE_NEARBY_ZPOSITION;
        
        return marker;
    }
    else {
        if ([annotation.title isEqual:@"walking"]) {
            RMShape *walkingShape = [[RMShape alloc] initWithView:mapView];
            walkingShape.lineColor = BCYCLE_BLUE;
            walkingShape.lineWidth = 6.0;
            walkingShape.zPosition = WALKING_POLYLINE_ZPOSITION;
            walkingShape.canShowCallout = NO;
            
            NSArray *cords = annotation.userInfo;
            if (cords.count > 0) {
                for (CLLocation *location in cords) {
                    [walkingShape addLineToCoordinate:location.coordinate];
                }
                return walkingShape;
            }
        }
    }
    
    return nil;
}

- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map {
    if ([annotation.userInfo isKindOfClass:[Ride class]] && ![((Ride *)annotation.userInfo) isEqual:self.provider.selectedRide]) {
        // Remove old selected rides walking polyline and walking turns
        [self.mapView removeAnnotation:self.walkingPolylineAnnotation];
        [self.mapView removeAnnotations:self.walkingStepAnnotations];
        
        // Remove annotations for the newly selected ride and the old selected ride
        Ride *ride = (Ride *)annotation.userInfo;
        Ride *oldSelectedRide = self.provider.selectedRide;
        RMAnnotation *oldSelectedRideAnnotation = [self annotationForRide:oldSelectedRide];
        RMAnnotation *newSelectedRideAnnotation = [self annotationForRide:ride];
        [self.mapView removeAnnotation:oldSelectedRideAnnotation];
        [self.mapView removeAnnotation:newSelectedRideAnnotation];
        
        // Remove new selected ride from the annotations
        NSMutableArray *tmp = [self.ridesNearbyAnnotations mutableCopy];
        [tmp removeObject:oldSelectedRideAnnotation];
        self.ridesNearbyAnnotations = [NSArray arrayWithArray:tmp];
        
        // Add the new annotations for the newly selected ride, and the old selected ride
        self.provider.selectedRide = ride;
        [self addAnnotationForRide:oldSelectedRide];
        [self addSelectedRideForProvider:self.provider];
        
        [self updateWalkingDirections];
    }
}

- (void)tapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map {
    self.topLevelAnnoation.layer.zPosition = RIDE_NEARBY_ZPOSITION;
    self.topLevelAnnoation = annotation;
    self.topLevelAnnoation.layer.zPosition = TOP_RIDE_NEARBY_ZPOSITION;
}

// This method gets called after the map is recentered
- (void)mapView:(RMMapView *)mapView didSelectAnnotation:(RMAnnotation *)annotation {
    // Take in account the header size since the map is under the header, move down the map based on thew map size minus the header height
    // THe -40 is the extimated height of the callout
    // Also will move the map up if the annotation is near the bottom under the button
    
    if (([self.mapView coordinateToPixel:annotation.coordinate].y - 40) < self.headerView.frame.size.height) {
        [self.mapView moveBy:CGSizeMake(0, -self.headerView.frame.size.height)];
        
    }
    else if (([self.mapView coordinateToPixel:annotation.coordinate].y + 20) > self.bookButton.frame.origin.y) {
        [self.mapView moveBy:CGSizeMake(0, + (self.view.frame.size.height - self.bookButton.frame.origin.y))];
        
    }
}

#pragma mark - DirectionsViewDelegate

- (void)directionTapped:(Direction *)direction {
    [self didPressDirectionsButton:nil];
    
    for (RMAnnotation *annotation in self.mapView.annotations) {
        // Direction turn annotations' user info is the direction object so checks for that
        // And the final direction is the ride which is added programatically in the directions view therefore
        // it checks that as well based off of location
        // Mapbox wont' show the annotation for the selected ride sometimes. It won't work until you select a different annotation then it'll work
        // For the selected ride
        if ([annotation.userInfo isEqual:direction] || (annotation.coordinate.latitude == direction.startLocation.coordinate.latitude && annotation.coordinate.longitude == direction.startLocation.coordinate.longitude)) {
            
            // MapView won't recenter if the annotation is already selected
            // Sadly this doesn't fix the problem
            if ([self.mapView.selectedAnnotation isEqual:annotation])
                [self.mapView deselectAnnotation:annotation animated:NO];
            
            while (!annotation.layer.canShowCallout) {
                [self.mapView setZoom:self.mapView.zoom-.1 animated:NO];
            }
            
            [self.mapView selectAnnotation:annotation animated:YES];
            
            return;
        }
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    directionsAnimating = NO;
}

#pragma mark - IBActions

- (IBAction)didPressBookingButton:(id)sender {
    self.bookingController = [[BCycleBookingController alloc] initFromPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2) WithPresentngView:self.view WithProvider:self.provider];
}

- (IBAction)didPressDirectionsButton:(id)sender {
    UIImage *providerIcon = [[RideIconsManager sharedCache] imageIconForURL:self.provider.iconUrl];
    UIImage *rideImage = [UIImage imageWithImage:providerIcon scaledToSize:CGSizeMake(40, 40)];
    self.provider.selectedRide.image = rideImage;
    self.directionsView.ride = self.provider.selectedRide;
    
    CGFloat directionTotalMove = self.directionsView.frame.size.height;
    float direction = (directionsShown) ? 1.0 : -1.0;
    
    directionsAnimating = YES;
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.directionsView setFrame:CGRectOffset(self.directionsView.frame, 0, direction*directionTotalMove)];
        
    } completion:^(BOOL finished) {
        self->directionsShown = !self->directionsShown;
        self->directionsAnimating = NO;
        [self.profileButton setEnabled:!(self->directionsShown)];
    }];
}

- (IBAction)didPressProfileButton:(id)sender {
    CGFloat width = SCREEN_WIDTH - (self.profileButton.frame.origin.x + self.profileButton.frame.size.width);
    
    // Initiliaze the Profile View
    if (!self.slideProfileViewController) {
        self.slideProfileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        [self addChildViewController:self.slideProfileViewController];
        [self.slideProfileViewController.view setFrame:CGRectMake(-width, 0, width, SCREEN_HEIGHT)];
        
        [self.view addSubview:self.slideProfileViewController.view];
        [self.slideProfileViewController didMoveToParentViewController:self];
    }
    
    // Animate the Profile View
    __block MapViewController *blockSelf = self;
    if (self.slideProfileViewController.view.frame.origin.x == 0) {
        [self.containerView addSubview:self.mapView];
        [self.containerView bringSubviewToFront:self.shadowOverlay];
        [self.containerView bringSubviewToFront:self.headerView];
        [self.containerView bringSubviewToFront:self.bookButton];
        [self.containerView bringSubviewToFront:self.bookLabel];
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            blockSelf.containerViewLeftConstraint.constant = 0;
            blockSelf.containerViewRightConstraint.constant = 0;
            [blockSelf.view layoutIfNeeded];
            [blockSelf.slideProfileViewController.view setFrame:CGRectMake(-width, 0, width, SCREEN_HEIGHT)];
            [self.shadowOverlay setAlpha:0.0];
        } completion:^(BOOL finished) {
            [blockSelf.view removeGestureRecognizer:self.profileSwipGestureRecognizer];
            [blockSelf.containerView sendSubviewToBack:self.shadowOverlay];
        }];
    }
    else {
        [self.containerView addSubview:self.mapView];
        [self.containerView bringSubviewToFront:self.shadowOverlay];
        [self.containerView bringSubviewToFront:self.headerView];
        [self.containerView bringSubviewToFront:self.bookButton];
        [self.containerView bringSubviewToFront:self.bookLabel];
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            blockSelf.containerViewLeftConstraint.constant = width;
            blockSelf.containerViewRightConstraint.constant = -width;
            [blockSelf.view layoutIfNeeded];
            [blockSelf.slideProfileViewController.view setFrame:CGRectMake(0, 0, width, SCREEN_HEIGHT)];
            [self.shadowOverlay setAlpha:0.4];
        } completion:^(BOOL finished) {
            [blockSelf.view addGestureRecognizer:self.profileSwipGestureRecognizer];
        }];
    }
}

#pragma mark - Setters

- (void)setProviderState:(ProviderState)providerState {
    _providerState = providerState;
    
    switch (providerState) {
        case NoRides:
            [self stopLoadingAroundButton];
            [self noRides];
            break;
        case UpdatingRides:
            [self updatingRides];
            break;
        case RidesNearbyWithSelectedRide:
            [self stopLoadingAroundButton];
            [self showSelectedRide];
            break;
        case LoadingDirectionsToRide:
            [self loadingDirections];
            break;
    }
}

- (void)setProvider:(Provider *)provider {
    _provider = provider;
    
    if (provider.ridesNearby.count > 0) {
        if (!provider.selectedRide) provider.selectedRide = [provider.ridesNearby firstObject];
        
        CLLocation *currentLocation = [[LocationManager sharedLocationManager] currentLocation];
        [self.mapView setCenterCoordinate:currentLocation.coordinate];
        
        [self showSelectedRide];
        [self updateWalkingDirections];
    }
}

#pragma mark - Loading SPinner

- (void)showLoadingAroundButton {
    [self.containerView bringSubviewToFront:self.loadingImageView];
    [self.loadingImageView setHidden:NO];
    self.bookButton.userInteractionEnabled = NO;
    self.stepByStepButton.userInteractionEnabled = NO;
    [self.loadingImageView rotate360WithDuration:1.5 repeatCount:0];
    [UIView animateWithDuration:.2 animations:^{
        self.bookButton.alpha = .5;
        self.bookLabel.alpha = .5;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)stopLoadingAroundButton {
    self.bookButton.userInteractionEnabled = YES;
    self.stepByStepButton.userInteractionEnabled = YES;
    [UIView animateWithDuration:.2 animations:^{
        self.bookButton.alpha = 1;
        self.bookLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [self.loadingImageView setHidden:YES];
    }];
}

#pragma mark - Helpers

- (NSArray *)convertPolylinesToCoords:(NSMutableArray *)polylines {
    // The full polyline coordinates for use to make the bounding box for the zoom level
    NSMutableArray *fullPolylineCoords = [[NSMutableArray alloc] init];
    for (NSString *polyline in polylines) {
        [RMMapView getLocationsForEncodedPolyline:polyline forCords:fullPolylineCoords];
    }
    return fullPolylineCoords;
}

- (UIImage *)getCircleWithDiameter:(CGFloat)diameter andColor:(UIColor*)color {
    CGSize circleSize = CGSizeMake(diameter, diameter);
    UIImage *circleImage = [UIImage imageWithColor:color size:circleSize];
    CGRect oRect = CGRectMake(0, 0, circleImage.size.width, circleImage.size.height);
    return [UIImage circularScaleNCrop:circleImage scaledToRect:oRect];
}

- (void)blankCircleForButton:(UIButton *)button {
    UIView *compositeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
    
    UIImageView *circle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
    [circle setBackgroundColor:RIDESCOUT_WHITE];
    [circle.layer setCornerRadius:circle.frame.size.width / 2];
    [circle.layer setBorderColor:[UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1.0].CGColor];
    [circle.layer setBorderWidth:1.0];
    circle.alpha = 1.0;
    [compositeView addSubview:circle];
    
    CGFloat scaleValue = button.frame.size.width;
    UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CHECKMARK_IMAGE_PATH] ];
    [checkmark setFrame:CGRectMake((button.frame.size.width - scaleValue)/2, (button.frame.size.height - scaleValue)/2, scaleValue, scaleValue)];
    [compositeView addSubview:checkmark];
    
    // Take a Snap-Shot of the UiImageView and convert it to a UIImage
    UIGraphicsBeginImageContextWithOptions(circle.bounds.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [compositeView.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [button setImage:snapshotImage forState:UIControlStateNormal];

    button.layer.shadowColor = BCYCLE_DARK_GREY.CGColor;
    button.layer.shadowOpacity = 0.5;
    button.layer.shadowRadius = 3;
    button.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
}

- (UIImage *)addCircleBorderToImage:(UIImage *)image withColor:(UIColor *)color withThickness:(CGFloat)thickness {
    
    UIView *compositeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width + thickness, image.size.height + thickness)];
    
    UIImageView *circle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, compositeView.frame.size.width, compositeView.frame.size.height)];
    [circle setBackgroundColor:color];
    [circle.layer setCornerRadius:circle.frame.size.width / 2];
    circle.alpha = 1.0;
    [compositeView addSubview:circle];
    
    UIImageView *checkmark = [[UIImageView alloc] initWithImage:image];
    CGFloat width = checkmark.frame.size.width;
    [checkmark setFrame:CGRectMake((compositeView.frame.size.width - width)/2, (compositeView.frame.size.height - width)/2, width, width)];
    [compositeView addSubview:checkmark];
    
    // Take a Snap-Shot of the UiImageView and convert it to a UIImage
    UIGraphicsBeginImageContextWithOptions(circle.bounds.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [compositeView.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

- (RMAnnotation *)annotationForRide:(Ride *)ride {
    for (RMAnnotation *annotation in self.mapView.annotations) {
        if ([annotation.userInfo isEqual:ride]) return annotation;
    }
    return nil;
}

@end
