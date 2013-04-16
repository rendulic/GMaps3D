//
//  ViewController.m
//  GMaps3D
//
//  Created by Igor Rendulic on 16/04/2013.
//  Copyright (c) 2013 Igor Rendulic. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

#pragma mark init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setting up mapView
    _mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.550814 longitude:15.645118 zoom:18 bearing:90
                                                         viewingAngle:65];
    
    _mapView.camera = camera;
    _mapView.delegate = self;
    _mapView.mapType = kGMSTypeNormal;
    
    // adding button view relative to mapView
    MapMenuView *menuView = [[MapMenuView alloc] initWithFrame:CGRectMake( _mapView.frame.size.width - 50, 50, 50, 100)];
    [self.view addSubview:menuView];
}

#pragma mark Google Map View delegates
-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"Tapped at coordinate: %f - %f", coordinate.latitude, coordinate.longitude);
}

-(void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    NSLog(@"Changed cam position");
}

#pragma mark memory management functions
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
