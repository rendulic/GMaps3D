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
#import "OpenGLController.h"
#import "TextureManager.h"
#import "ViewControllerDelegate.h"

@protocol ViewControllerDelegate;

@interface ViewController : UIViewController <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

//@property (strong, nonatomic) EmbeddedViewController *embeddedViewController;
@property (strong,nonatomic) OpenGLController *openGLController;

// delegate init
@property (weak) id<ViewControllerDelegate> viewControllerDelegate;

@end
