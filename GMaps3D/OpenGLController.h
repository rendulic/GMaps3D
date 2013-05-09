//
//  OpenGLController.h
//  GMaps3D
//
//  Created by Igor Rendulic on 4/23/13.
//  Copyright (c) 2013 Igor Rendulic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MapMenuView.h"
#import "GLSquare.h"
#import "TextureManager.h"
#import "ViewControllerDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

@interface OpenGLController : GLKViewController <GLKViewControllerDelegate,ViewControllerDelegate>

@property (strong, nonatomic) IBOutlet GLKView *glView;
@property (nonatomic, strong) NSArray *squares; // CG points for squares to be drawn

@end
