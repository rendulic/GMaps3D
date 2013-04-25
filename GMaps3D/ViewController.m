//
//  ViewController.m
//  GMaps3D
//
//  Created by Igor Rendulic on 16/04/2013.
//  Copyright (c) 2013 Igor Rendulic. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()

@property CGRect landscapeRect;
@property CGRect portraitRect;

@end

@implementation ViewController

#pragma mark init views

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setting up mapView
    _mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.550814 longitude:15.645118 zoom:18 bearing:0 viewingAngle:65];
    _mapView.camera = camera;
    _mapView.delegate = self;
    _mapView.mapType = kGMSTypeNormal;
    
    // defining landscape size and portrait size on the map view
    _portraitRect = CGRectMake(0, 0, _mapView.frame.size.width, _mapView.frame.size.height);
    // adding status bar height
    _landscapeRect = CGRectMake(0, 0,_mapView.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, _mapView.frame.size.width);
    
    // adding button view relative to mapView
    MapMenuView *menuView = [[MapMenuView alloc] initWithFrame:CGRectMake( _mapView.frame.size.width - 50, 50, 60, 80)];
    menuView.tag = 6661; // unique tag for the view (needed after orientation change so the position can be modified)
    [self.view addSubview:menuView];
    

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    _openGLController = (OpenGLController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"openGLController"];
    
    [self addChildViewController:_openGLController];
    [self.view addSubview:_openGLController.view];
    [self didMoveToParentViewController:self];
}

#pragma mark Google Map View delegates

-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    /*CGPoint point = [mapView.projection pointForCoordinate:coordinate];
    NSLog(@"POint: X:%f, Y:%f", point.x, point.y);
    */
    
    CLLocationCoordinate2D A = CLLocationCoordinate2DMake(46.551400, 15.644536);
    CLLocationCoordinate2D B = CLLocationCoordinate2DMake(46.551570, 15.644541);
    CLLocationCoordinate2D C = CLLocationCoordinate2DMake(46.551574, 15.644799);
    CLLocationCoordinate2D D = CLLocationCoordinate2DMake(46.551397, 15.644799);
    
    CGPoint Ap = [mapView.projection pointForCoordinate:A];
    CGPoint Bp = [mapView.projection pointForCoordinate:B];
    CGPoint Cp = [mapView.projection pointForCoordinate:C];
    CGPoint Dp = [mapView.projection pointForCoordinate:D];
    
    NSLog(@"Ax:%f,Ay:%f", Ap.x,Ap.y);
    NSLog(@"Bx:%f,By:%f", Bp.x,Bp.y);
    NSLog(@"Cx:%f,Cy:%f", Cp.x,Cp.y);
    NSLog(@"Dx:%f,Dy:%f", Dp.x,Dp.y);
     
}

-(void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    //NSLog(@"Changed cam position");
}

#pragma mark Adapting views after orientation change

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    MapMenuView *mapMenuView = (MapMenuView *) [self.view viewWithTag:6661];
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
         mapMenuView.frame = CGRectMake(_landscapeRect.size.width - 50, 20, 60, 80);
    } else if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        mapMenuView.frame = CGRectMake(_portraitRect.size.width - 50, 50, 60, 80);
    }
}

#pragma mark memory management functions

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
