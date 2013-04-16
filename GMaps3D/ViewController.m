//
//  ViewController.m
//  GMaps3D
//
//  Created by Igor Rendulic on 16/04/2013.
//  Copyright (c) 2013 Igor Rendulic. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,weak) GMSMapView *mapView;
@end

@implementation ViewController

#pragma mark init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.550814 longitude:15.645118 zoom:21 bearing:30
                                                         viewingAngle:45];
    
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView.myLocationEnabled = YES;
    _mapView.delegate = self;
    _mapView.mapType = kGMSTypeTerrain;
    
    self.view = _mapView;
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
