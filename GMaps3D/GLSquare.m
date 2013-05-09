//
//  GLSquare.m
//  GMaps3D
//
//  Created by Igor Rendulic on 5/6/13.
//  Copyright (c) 2013 Igor Rendulic. All rights reserved.
//

#import "GLSquare.h"

static BOOL initialized = NO;

GLuint vertexBuffer;
GLuint indexBuffer;

@implementation GLSquare

-(id) init {
    self = [super init];
    if (self) {
        // nothing do init
    }
    return self;
}

+(void)initialize {
    if (!initialized) {
        initialized = YES;
    }
}

@end

