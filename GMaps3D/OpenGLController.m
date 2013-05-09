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

@property (nonatomic, strong) GLKBaseEffect *effect;

@end

@implementation OpenGLController

#pragma mark openGL structures
typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;

/*
A -> X:46.551400, Y:15.644536
B -> X:46.551570, Y:15.644541
C -> X:46.551574, Y:15.644799
D -> X:46.551397, Y:15.644799
Ax:51.500008,Ay:130.125000
Bx:52.437508,By:84.062500
Cx:100.562500,Cy:82.937500
Dx:100.562500,Dy:130.937500
 
 {{D.x, D.y, square.zIndex}, {0, 0, 0, 1}, {0, 1}},
 {{D.x, B.y, square.zIndex}, {0, 0, 0, 1}, {0, 0}},
 {{B.x, B.y, square.zIndex}, {0, 0, 0, 1}, {1, 0}},
 {{B.x, D.y, square.zIndex}, {0, 0, 0, 1}, {1, 1}}

 
 2013-04-24 00:30:16.519 GMaps3D[5887:c07] Ax:66.360283,Ay:170.254654
 2013-04-24 00:30:16.519 GMaps3D[5887:c07] Bx:70.714813,By:141.676971
 2013-04-24 00:30:16.520 GMaps3D[5887:c07] Cx:110.708260,Cy:141.006287
 2013-04-24 00:30:16.520 GMaps3D[5887:c07] Dx:108.667168,Dy:170.779129
 */

const Vertex Vertices[] = {
    // Front
    {{108.667168, 180.779129, 1}, {0, 0, 0, 1}, {0, 1}},
    {{110.708260, 121.006287, 1}, {0, 0, 0, 1}, {0, 0}},
    {{70.714813, 121.676971, 1}, {0, 0, 0, 1}, {1, 0}},
    {{66.360283, 180.254654, 1}, {0, 0, 0, 1}, {1, 1}}
};

/*const Vertex Vertices[] = {
    {{1, -1, 0}, {1, 0, 0, 1}},
    {{1, 1, 0}, {0, 1, 0, 1}},
    {{-1, 1, 0}, {0, 0, 1, 1}},
    {{-1, -1, 0}, {0, 0, 0, 1}}
};
 */

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

#pragma mark - OPEN GL METHODS

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self setupGL];
    [self update];
    
    glClearColor(0,0,0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_BLEND);
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glFlush();
        
    [_effect prepareToDraw];
    
    glBindVertexArrayOES(_vertexArray);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, [[TextureManager sharedTextureManager] getTexture:TEXTURE_BARRACK]);
    
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    
    glFlush();
}

- (void)update {
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, _glView.frame.size.width,_glView.frame.size.height,0, -1, 1);
    _effect.transform.projectionMatrix = projectionMatrix;
    
    /*GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, -3, 5, 0, 0, 0, 0, 7, 0);
    _effect.transform.modelviewMatrix = viewMatrix;
    _effect.transform.projectionMatrix = GLKMatrix4MakePerspective(0.125*M_TAU, 1.0, -1, 2);
     */
}

- (void) glkViewControllerUpdate:(GLKViewController *)controller {
    NSLog(@"UPDATE!");
}


- (void)render:(CADisplayLink*)displayLink {
    [_glView display];
}

#pragma mark setup and tearDown methods

-(void)setupGL {
    // using the existent context of Google Maps SDK
    EAGLContext *firstContext = [EAGLContext currentContext];
    
    _glView.context = firstContext;
    _glView.delegate = self;
    
    if (!_glView.context) {
        NSLog(@"Failed to create NSContext");
    }
    
    glFlush();
    
    _glView.drawableMultisample = GLKViewDrawableMultisample4X;
    _glView.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    _glView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    
    glEnable(GL_CULL_FACE);
    
    // init effect
    _effect = [[GLKBaseEffect alloc] init];
    
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
    /*CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [displayLink setFrameInterval:1/60];
    */
     
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
    
        glFlush();
}


-(void)tearDownGL {
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    
    _effect = nil;
     
}

#pragma mark Delegate implementation

-(void)updatedSquarePositions:(ViewController *)viewController squares:(NSArray *)squares {
    _squares = squares;
    [_glView setNeedsDisplay];
}

@end
