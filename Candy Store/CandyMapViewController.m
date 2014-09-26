//
//  CandyMapViewController.m
//  Candy Store
//
//  Created by Jiahe Kuang on 9/17/14.
//  Copyright (c) 2014 Jiahe Kuang. All rights reserved.
//

#import "CandyMapViewController.h"

@interface CandyMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *candyMapView;

@end

@implementation CandyMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self findCandyLocation];
    // Do any additional setup after loading the view.
}

-(void)findCandyLocation
{
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
    
    
    if(self.geocoder == nil)
    {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    NSString *address = self.candyLocation;
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(placemarks.count > 0)
        {
            

            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
//            CLLocation* newCLLocation = placemark.location;
            
            MKCoordinateSpan newSpan = MKCoordinateSpanMake(0.005, 0.005);
            
            myAnnotation.coordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
            
            MKCoordinateRegion newRegion = MKCoordinateRegionMake(myAnnotation.coordinate, newSpan);

            [self.candyMapView setCenterCoordinate:newRegion.center animated:NO];
            
            [self.candyMapView setRegion:newRegion animated:YES];

            [self.candyMapView addAnnotation:myAnnotation];
            
            
//            [_candyMapView setCenterCoordinate:myAnnotation.coordinate animated:YES];
        }
        
        
    }];
    
}

@end
