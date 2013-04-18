//
//  EmbeddedView.m
//  GMaps3D
//
//  Created by Igor Rendulic on 18/04/2013.
//  Copyright (c) 2013 Igor Rendulic. All rights reserved.
//

#import "EmbeddedView.h"

@implementation EmbeddedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"Test of hit");
    return nil;
}

-(BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
