//
//  TextureManager.m
//  GMaps3D
//
//  Created by Igor Rendulic on 5/6/13.
//  Copyright (c) 2013 Igor Rendulic. All rights reserved.
//

#import "TextureManager.h"

@implementation TextureManager

#pragma mark texture holder
static GLuint textures[71];

MAKE_SINGLETON(TextureManager);

-(id)init {
    // load textures
    if (self = [super init]) {
        textures[TEXTURE_HQ] = [self loadTexture:@"hq.png"];
        textures[TEXTURE_BARRACK] = [self loadTexture:@"barrack.png"];
    }
    return self;
}

#pragma mark texture loader
- (GLuint)loadTexture:(NSString *)fileName {
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}

-(GLuint)getTexture:(int)textureIndex {
    return textures[textureIndex];
}

@end
