//
//  GLSquare.h
//  GMaps3D
//
//  Created by Igor Rendulic on 5/6/13.
//  Copyright (c) 2013 Igor Rendulic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLSquare : NSObject

@property CGPoint A;
@property CGPoint B;
@property CGPoint C;
@property CGPoint D;
@property (nonatomic,readwrite) GLuint texture;
@property (nonatomic,retain) NSString* amountUnits;
@property BOOL isEnemyTerrain;
@property (nonatomic,retain) NSNumber* latitudeB;
@property (nonatomic,retain) NSNumber* longitudeB;
@property (nonatomic,retain) NSNumber *latitudeD;
@property (nonatomic,retain) NSNumber *longitudeD;
@property (nonatomic,retain) NSNumber* power;
@property (nonatomic,retain) NSNumber* knightPower;
@property BOOL isVisible;
@property BOOL isEnemyProtected;
@property (nonatomic) float zIndex;
@property BOOL isKnight;

@end
