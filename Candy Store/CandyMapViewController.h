//
//  CandyMapViewController.h
//  Candy Store
//
//  Created by Jiahe Kuang on 9/17/14.
//  Copyright (c) 2014 Jiahe Kuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CandyMapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) NSString* candyLocation;

@property (nonatomic, strong) CLGeocoder*  geocoder;


@end
