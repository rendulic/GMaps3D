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

@property (nonatomic,retain) NSMutableArray *glSquares;

@end

@implementation ViewController

@synthesize viewControllerDelegate;

#pragma mark init views

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) convertMapCoordinatesToCGCoordinates {
    // TODO: manual data load
    /*
     +-------------+--------------+-------------+--------------+-------------+--------------+-------------+--------------+
     | coord_lat_a | coord_long_a | coord_lat_b | coord_long_b | coord_lat_c | coord_long_c | coord_lat_d | coord_long_d |
     +-------------+--------------+-------------+--------------+-------------+--------------+-------------+--------------+
     |     48.1950 |      16.4040 |     48.1960 |      16.4040 |     48.1960 |      16.4050 |     48.1950 |      16.4050 |
     |     48.1940 |      16.4040 |     48.1950 |      16.4040 |     48.1950 |      16.4050 |     48.1940 |      16.4050 |
     |     48.1930 |      16.4040 |     48.1940 |      16.4040 |     48.1940 |      16.4050 |     48.1930 |      16.4050 |
     |     48.1920 |      16.4040 |     48.1930 |      16.4040 |     48.1930 |      16.4050 |     48.1920 |      16.4050 |
     |     48.1940 |      16.4050 |     48.1950 |      16.4050 |     48.1950 |      16.4060 |     48.1940 |      16.4060 |
     |     48.1950 |      16.4050 |     48.1960 |      16.4050 |     48.1960 |      16.4060 |     48.1950 |      16.4060 |
     |     48.1950 |      16.4030 |     48.1960 |      16.4030 |     48.1960 |      16.4040 |     48.1950 |      16.4040 |
     +-------------+--------------+-------------+--------------+-------------+--------------+-------------+--------------+
     */
    
    GLSquare *square = [[GLSquare alloc] init];
    square.A = [_mapView.projection pointForCoordinate:CLLocationCoordinate2DMake(48.1950, 16.4040)];
    square.B = [_mapView.projection pointForCoordinate:CLLocationCoordinate2DMake(48.1960, 16.4040)];
    square.C = [_mapView.projection pointForCoordinate:CLLocationCoordinate2DMake(48.1960, 16.4050)];
    square.D = [_mapView.projection pointForCoordinate:CLLocationCoordinate2DMake(48.1950, 16.4050)];
    square.texture = [[TextureManager sharedTextureManager] getTexture:TEXTURE_BARRACK];
    [_glSquares addObject:square];
    
    GLSquare *squareHq = [[GLSquare alloc] init];
    squareHq.A = [_mapView.projection pointForCoordinate:CLLocationCoordinate2DMake(48.1940, 16.4040)];
    squareHq.B = [_mapView.projection pointForCoordinate:CLLocationCoordinate2DMake(48.1950, 16.4040)];
    squareHq.C = [_mapView.projection pointForCoordinate:CLLocationCoordinate2DMake(48.1950, 16.4050)];
    squareHq.D = [_mapView.projection pointForCoordinate:CLLocationCoordinate2DMake(48.1940, 16.4050)];
    squareHq.texture = [[TextureManager sharedTextureManager] getTexture:TEXTURE_HQ];
    [_glSquares addObject:squareHq];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setting up mapView
    _mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.550814 longitude:15.645118 zoom:18 bearing:0 viewingAngle:65];
    _mapView.camera = camera;
    _mapView.delegate = self;
    _mapView.mapType = kGMSTypeNormal;
    _mapView.settings.compassButton = YES;
    _mapView.settings.myLocationButton = YES;
    
    _mapView.settings.zoomGestures = YES;
    
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
    
    [_openGLController setPreferredFramesPerSecond:30];
    
    [self addChildViewController:_openGLController];
    [self.view addSubview:_openGLController.view];
    [self didMoveToParentViewController:self];
    
    // set delegate for openGL redraw
    [self setViewControllerDelegate:_openGLController];
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

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    //NSLog(@"Changed cam position");
    if (viewControllerDelegate != nil && [viewControllerDelegate respondsToSelector:@selector(updatedSquarePositions:squares:)]) {
        [viewControllerDelegate updatedSquarePositions:self squares:[[NSArray alloc] init]];
    }
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
