//
//  FaceView.m
//  Happiness
//
//  Created by Tarik Djebien on 26/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView

@synthesize scale = _scale;

@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 0.90
#define EYE_H 0.35
#define EYE_V 0.35
#define EYE_RADIUS 20 

#define MOUTH_H 0.45
#define MOUTH_V 0.40
#define MOUTH_SMILE 0.25

-(CGFloat) scale
{
    if(!_scale) {
        return DEFAULT_SCALE;
    }else{
        return _scale;
    }
}

-(void)setScale:(CGFloat)scale
{
    // Optimisation de performance, on ne redessine pas le contexte graphique si le scale reste inchangé
    if(scale != _scale){
        _scale = scale;
        [self setNeedsDisplay];
    }
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded){
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

-(void) setUp
{
    self.contentMode = UIViewContentModeRedraw;
}

-(void)awakeFromNib
{
    [self setUp];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}


- (void) drawCircleAtPoint:(CGPoint) p withRadius:(CGFloat) radius inContext:(CGContextRef)context
{
    // Recupere une connexion sur le contexte
    UIGraphicsPushContext(context);
    
    // Trace notre cercle
    CGContextBeginPath(context);
    
    // context : notre contexte
    // x,y : coordonnee du centre du cercle
    // radius : rayon du cercle
    // startAngle : 0
    // endAngle : 2pi = 360 degree
    // clockwise : sens des aiguille d'une montre
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    
    // On dessine/remplie le chemin sur la/les zone tracees
    CGContextStrokePath(context);
    
    // Libere la connexion une fois les modifications sur le contexte terminées
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect
{
    // Recupere le contexte graphique
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Recupere le centre de notre FaceView 
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size = self.bounds.size.width / 2;
    if(self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height / 2;
    
    // le rayon de la face fera 90% de la size
    size *= self.scale;
    
    // Initialise la largeur des lignes
    CGContextSetLineWidth(context, 5.0);
    
    // Initialise la couleur bleu des lignes
    [[UIColor blueColor] setStroke];
    
    // Draw face (circle)
    [self drawCircleAtPoint:midPoint withRadius:size inContext:context];
    
    // Draw eyes (2 circles)
    CGPoint eyePoint;
    eyePoint.x = midPoint.x - size * EYE_H ;
    eyePoint.y = midPoint.y - size * EYE_V ;
    
    [self drawCircleAtPoint:eyePoint withRadius:EYE_RADIUS inContext:context];
    eyePoint.x += size * EYE_H * 2;
    [self drawCircleAtPoint:eyePoint withRadius:EYE_RADIUS inContext:context];
    
    // Draw the mouth
    CGPoint mouthStart;
    mouthStart.x = midPoint.x - MOUTH_H * size;
    mouthStart.y = midPoint.y + MOUTH_V * size;
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x += MOUTH_H * size * 2;
    CGPoint mouthCP1 = mouthStart;
    mouthCP1.x += MOUTH_H * size * 2/3;
    CGPoint mouthCP2 = mouthEnd;
    mouthCP2.x -= MOUTH_H * size * 2/3;
    
    // if dataSource is nill, my smile will be 0, that's Ok, it's fine with result expected
    float smile = [self.dataSource smileForFaceView:self];
    if (smile < -1) smile = -1;
    if (smile > 1) smile = 1;
    
    CGFloat smileOffSet = MOUTH_SMILE * size * smile;
    mouthCP1.y += smileOffSet;
    mouthCP2.y += smileOffSet;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
    CGContextStrokePath(context);
    
}

@end
