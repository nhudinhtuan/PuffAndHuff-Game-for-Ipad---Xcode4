//
//  GameObject.m
//  Game
//
//  Created by DINH TUAN NHU on 29/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"


@implementation GameObject
@synthesize view, model, delegate, pan, pinch, rotate, doubleTap;
@synthesize body;
@synthesize chipmunkObjects;
@synthesize shape;
@synthesize isInGame;

- (GameModel *)model {
    model.center = view.center;
    return model;
}

- (id)initWithUIImage:(UIImage *)img objectType:(GameObjectType)type frame:(CGRect)f isInGameArea:(BOOL)isInGameArea subType:(int)subType {
    // EFFECTS: constructs a new GameObject from the UIImage
    
    self = [super init];
    view = [[UIImageView alloc] initWithImage:img];
    view.userInteractionEnabled = YES;
    view.frame = f;
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(translate:)];
    pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
    rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [view addGestureRecognizer:pan];
    [view addGestureRecognizer:doubleTap];
    [view addGestureRecognizer:rotate];
    [view addGestureRecognizer:pinch];
    
    if (isInGameArea) {
        [self.delegate addSubViewToGameArea:view];
    } else {
        [self.delegate addSubViewToPalette:view];
    }
    
    //init the model
    model = [[GameModel alloc] initWithType:type subType:subType center:view.center rotation:0 scale:1];
    self.isInGame = isInGameArea;
    return self;
}
 
- (id)initWithIsInGameArea:(BOOL)isInGameArea subType:(int)subType delegate:(id)d {
    return self;
}

- (void)setPhysicalEngine {
    body.pos = view.center;
    body.angle = model.rotation;  
    [self removeAllGestureRecognizers];
}

- (void)updatePosition {
    view.center = body.pos;
    if (model.rotation != body.angle) {
        view.transform = CGAffineTransformRotate(view.transform, body.angle - model.rotation);
        model.rotation = body.angle;
    }
}

- (id)initWithModel:(GameModel *)m isInGameArea:(BOOL)isInGameArea delegate:(id)d {
    // EFFECTS: constructs a new GameObject from the model
    
    self = [self initWithIsInGameArea:isInGameArea subType:m.subType delegate:d];
    if (isInGameArea) {
        model = m;
        view.transform = CGAffineTransformRotate(view.transform, model.rotation);
        view.transform = CGAffineTransformScale(view.transform, model.scale, model.scale);
        view.center = model.center;
    }
    return self;
}

- (void)translate:(UIPanGestureRecognizer *)gesture {
    // MODIFIES: object model (coordinates)
    // REQUIRES: game in designer mode
    // EFFECTS: the user drags around the object with one finger
    //          if the object is in the palette, it will be moved in the game area
    
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state ==UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:view.superview];	
        [view setCenter:CGPointMake(view.center.x + translation.x, view.center.y + translation.y)];
        if (CGRectGetMinX(view.frame) < MIN_X_COORDINATE || CGRectGetMaxX(view.frame) > MAX_X_COORDINATE || CGRectGetMinY(view.frame) < MIN_Y_COORDINATE || CGRectGetMaxY(view.frame) > MAX_Y_COORDINATE) {
            [view setCenter:CGPointMake(view.center.x - translation.x, view.center.y - translation.y)];
        }
        [gesture setTranslation:CGPointZero inView:view.superview];
    }
}

- (void)rotate:(UIRotationGestureRecognizer *)gesture {
    // MODIFIES: object model (rotation)
    // REQUIRES: game in designer mode, object in game area
    // EFFECTS: the object is rotated with a two-finger rotation gesture
    
    if (!self.isInGame) {
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, gesture.rotation);
        model.rotation += gesture.rotation;
        gesture.rotation = 0;
    }
}

- (void)zoom:(UIPinchGestureRecognizer *)gesture {
    // MODIFIES: object model (size)
    // REQUIRES: game in designer mode, object in game area
    // EFFECTS: the object is scaled up/down with a pinch gesture
    
    if (!self.isInGame) {
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, gesture.scale, gesture.scale);
        model.scale *= gesture.scale;
        gesture.scale = 1;
    }
}


- (void)doubleTap:(UITapGestureRecognizer *)gesture {
    // REQUIRES: game in designer mode, object in game area
    // EFFECTS: delete and return object to the object palette
    
    if (!self.isInGame) {
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [view removeFromSuperview];
        [self.delegate removeObject:self];
    }
    
}

- (void)destroy {
 
    [self.delegate removeObjectFromSpace:self];
    [view removeFromSuperview];
    [self.delegate removeObject:self];
}

- (void)removeAllGestureRecognizers {
    
    [view removeGestureRecognizer:pan];
    [view removeGestureRecognizer:doubleTap];
    [view removeGestureRecognizer:rotate];
    [view removeGestureRecognizer:pinch];
    
}
@end
