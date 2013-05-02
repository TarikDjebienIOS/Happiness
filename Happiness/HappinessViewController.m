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
@property (nonatomic,weak) IBOutlet UIToolbar *toolBar;
@end

@implementation HappinessViewController

@synthesize happiness = _happiness;
@synthesize faceView = _faceView;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolBar = _toolBar;

-(void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolBarItems = [self.toolBar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolBarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolBarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolBar.items = toolBarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

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
    
    // Ajout du Handler lors de l'event du mouvement du doigt vers le Haut / Bas
    [self.faceView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHappinessGesture:)]];
    
    // Ajout du controller en tant que DataSource de la vue
    self.faceView.dataSource = self;                            
}

-(void) handleHappinessGesture: (UIPanGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded){
        CGPoint translation = [gesture translationInView:self.faceView];
        self.happiness -= translation.y / 2;
        [gesture setTranslation:CGPointZero inView:self.faceView];
    }
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
