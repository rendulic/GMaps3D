//
//  ButtonView.m
//  GMaps3D
//
//  Created by Igor Rendulic on 4/16/13.
//  Copyright (c) 2013 Igor Rendulic. All rights reserved.
//

#import "MapMenuView.h"

@implementation MapMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // info button
        UIButton *buttonInfo = [UIButton buttonWithType:UIButtonTypeInfoDark];
        buttonInfo.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        [buttonInfo addTarget:self action:@selector(buttonInfoPressed) forControlEvents:UIControlEventTouchDown];
        [self addSubview:buttonInfo];
        
        // rounded rect button
        UIButton *buttonContact = [UIButton buttonWithType:UIButtonTypeContactAdd];
        buttonContact.frame = CGRectMake(0, offsetButton, buttonWidth, buttonHeight);
        [buttonContact addTarget:self action:@selector(buttonAddContactPressed) forControlEvents:UIControlEventTouchDown];
        [self addSubview:buttonContact];
    }
    return self;
}

#pragma mark Button pressed handlers
-(void) buttonAddContactPressed {
    NSLog(@"Round button pressed");
}

-(void) buttonInfoPressed {
    NSLog(@"Info pressed");
    UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Igor Rendulic, Amplio d.o.o., Slovenia" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [infoAlert show];
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
