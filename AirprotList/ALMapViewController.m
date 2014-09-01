//
//  ALMapViewController.m
//  AirprotList
//
//  Created by Wang Chih-Ang on 11/21/13.
//  Copyright (c) 2013 Chih-Ang Wang. All rights reserved.
//

#import "ALMapViewController.h"
#import "ALDataSource.h"
#import "ALAirportDetailViewController.h"

#define AnnotationViewRightCalloutTag 1001

@interface ALMapViewController ()

@end

@implementation ALMapViewController

- (void)dealloc {
    self.mapView.delegate = nil;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;  //move to the current user coordinate after localization.
    NSArray *array = [ALMap arrayWithAirportsMapAndDetail];
        for (int i=0; i<[array count]; i++ )
        [self.mapView addAnnotation:[array objectAtIndex:i]];
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AirportDetailFromMap"]) {
        MKAnnotationView *annotationView = sender;
        ALAirportDetailViewController *detailViewController = segue.destinationViewController;
        NSString *titleOfAirport = [[annotationView annotation] title];
        NSDictionary *airportDetail = [[ALDataSource sharedDataSource] dictionaryWithAirportDetailByName:titleOfAirport];
        detailViewController.airportDetailFromSegue = airportDetail;
    }
}

#pragma mark - Map View

- (MKAnnotationView* ) mapView:(MKMapView* )mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    // Use default style for user's location
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil; //nil is the default
    }
    
    // Reuse annotation
    static NSString * AnnotationIdentifier = @"Annotation";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!annotationView) {  //if we can't get reuse, we have to make it ourselves!!!
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:AnnotationIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView.tag = AnnotationViewRightCalloutTag;
    } else {
        annotationView.annotation = annotation;
    }
    annotationView.image = [UIImage imageNamed:@"AirportIcon.png"];
    return annotationView;
}

- (void)mapView:(MKMapView* )mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if (control.tag == AnnotationViewRightCalloutTag) {
        [self performSegueWithIdentifier:@"AirportDetailFromMap" sender:view];
    }
}

@end
