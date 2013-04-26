//
//  FaceView.m
//  Happiness
//
//  Created by Tarik Djebien on 26/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) drawCircleAtPoint:(CGPoint) p withRadius:(CGFloat) radius inContext:(CGContextRef)context
{
    // Recupere une connexion sur le contexte
    UIGraphicsPushContext(context);
    
    
    // Libere la connexion une fois les modifications sur le contexte terminées
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect
{
    // Recupere le contexte graphique
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw face (circle)
    
    // Draw eyes (2 circles)
    
    // no nose
    
    // Draw the mouth
}

@end
