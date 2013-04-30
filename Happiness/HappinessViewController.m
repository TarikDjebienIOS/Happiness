//
//  HappinessViewController.m
//  Happiness
//
//  Created by Tarik Djebien on 26/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "HappinessViewController.h"
#import "FaceView.h"


/*
 * HappinessViewController implemente le protocole FaceViewDataSource
 * car c'est lui qui fournit la source de donnée à la vue. (MVC pattern)
 */
@interface HappinessViewController() <FaceViewDataSource>
@property (nonatomic,weak) IBOutlet FaceView *faceView;
@end

@implementation HappinessViewController

@synthesize happiness = _happiness;
@synthesize faceView = _faceView;

-(void) setHappiness:(int)happiness
{
    _happiness = happiness;
    [self.faceView setNeedsDisplay];
}

-(void)setFaceView:(FaceView *)faceView
{
    _faceView = faceView;
    
    // Ajout du Handler lors de l'event agrandir / reduire
    [self.faceView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.faceView action:@selector(pinch:)]];
    
    // Ajout du controller en tant que DataSource de la vue
    self.faceView.dataSource = self;                            
}

-(float) smileForFaceView:(FaceView *)sender
{
    // Le controller doit interpreter le model pour le presenter à la vue
    // i.e ici notre model est un entier 0 < happiness < 100
    // alors que notre vue utilise un -1 < smile < 1
    return (self.happiness - 50.0) / 50.0;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
