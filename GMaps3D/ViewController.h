//
//  ViewController.h
//  GMaps3D
//
//  Created by Igor Rendulic on 16/04/2013.
//  Copyright (c) 2013 Igor Rendulic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MapMenuView.h"

@interface ViewController : UIViewController <GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end
