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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            
            CLLocation* newCLLocation = placemark.location;
            
            MKCoordinateSpan newSpan = MKCoordinateSpanMake(0.02, 0.02);
            
            MKCoordinateRegion newRegion = MKCoordinateRegionMake(newCLLocation.coordinate, newSpan);
            
            
            myAnnotation.coordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
            
            [_candyMapView setRegion:newRegion animated:YES];
            [_candyMapView addAnnotation:myAnnotation];
//            [_candyMapView setCenterCoordinate:myAnnotation.coordinate animated:YES];
        }
        
        
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
