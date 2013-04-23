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

@interface OpenGLController : GLKViewController <GLKViewDelegate>

@property (strong, nonatomic) IBOutlet GLKView *glView;

@end
