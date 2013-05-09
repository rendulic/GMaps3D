//
//  ViewControllerDelegate.h
//  GMaps3D
//
//  Created by Igor Rendulic on 5/7/13.
//  Copyright (c) 2013 Igor Rendulic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewController;

@protocol ViewControllerDelegate <NSObject>

-(void)updatedSquarePositions:(ViewController *)viewController squares:(NSArray *)squares;

@end
