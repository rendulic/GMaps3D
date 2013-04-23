//
//  OpenGLController.m
//  GMaps3D
//
//  Created by Igor Rendulic on 4/23/13.
//  Copyright (c) 2013 Igor Rendulic. All rights reserved.
//

#import "OpenGLController.h"

@interface OpenGLController()

@property GLuint vertexBuffer;
@property GLuint indexBuffer;
@property GLuint vertexArray;

@property GLuint texture;

@property (strong, nonatomic) GLKBaseEffect *effect;

@end

@implementation OpenGLController

#pragma mark openGL structures
#pragma mark - OPEN GL METHODS
typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;

const Vertex Vertices[] = {
    // Front
    {{100, 100, 1}, {0, 0, 0, 1}, {0, 1}},
    {{100, 50, 1}, {0, 0, 0, 1}, {0, 0}},
    {{50, 50, 1}, {0, 0, 0, 1}, {1, 0}},
    {{50, 100, 1}, {0, 0, 0, 1}, {1, 1}}
};

const GLubyte Indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
};


#pragma mark init methods

- (void)viewWillAppear:(BOOL)animated {
    [self setupGL];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Release any retained subviews of the main view.
    [self tearDownGL];
}

#pragma mark drawing

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
   [self update];
    
    glClearColor(0,0,0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_BLEND);
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    [_effect prepareToDraw];
    
    glBindVertexArrayOES(_vertexArray);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture);
    
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
}

- (void)update {
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, _glView.frame.size.width,_glView.frame.size.height,0, -1, 1);
    _effect.transform.projectionMatrix = projectionMatrix;
}

- (void)render:(CADisplayLink*)displayLink {
    [_glView display];
}

#pragma mark setup and tearDown methods

-(void)setupGL {
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _glView.context = context;
    _glView.delegate = self;
    
    if (!_glView.context) {
        NSLog(@"Failed to create NSContext");
    }
    
    _glView.drawableMultisample = GLKViewDrawableMultisample4X;
    _glView.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    _glView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    
    [EAGLContext setCurrentContext:_glView.context];
    glEnable(GL_CULL_FACE);
    
    // init effect
    self.effect = [[GLKBaseEffect alloc] init];
    
    // init textures
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:YES],
                              GLKTextureLoaderOriginBottomLeft,
                              nil];
    
    NSError * error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"barrack" ofType:@"png"];
    GLKTextureInfo * info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if (info == nil) {
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    }

    
    _effect.texture2d0.name = info.name;
    _effect.texture2d0.enabled = true;

    // 60 frames per seconds call
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [displayLink setFrameInterval:1/60];
    
    // prepare buffers
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, TexCoord));
    
    glBindVertexArrayOES(0);
    
    //load textures
    _texture = [self loadTexture:@"barrack.png"];
}


-(void)tearDownGL {
    [EAGLContext setCurrentContext:_glView.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    
    _effect = nil;

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


@end
