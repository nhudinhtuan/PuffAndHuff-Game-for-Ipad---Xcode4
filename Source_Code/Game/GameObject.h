//
//  GameObject.h
//  Game
//
//  Created by DINH TUAN NHU on 29/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constant.h"
#import "GameObjectDelegate.h"
#import "GameModel.h"
#import "ObjectiveChipmunk.h"

@class GameObject;

@interface GameObject : UIViewController {
    
    UIImageView *view;
    GameModel *model;
    BOOL isInGame;
    id <GameObjectDelegate> delegate;
    
    ChipmunkBody *body;
    NSSet *chipmunkObjects;
    ChipmunkShape *shape;
    
    UIPanGestureRecognizer *pan;
    UIRotationGestureRecognizer *rotate;
    UIPinchGestureRecognizer *pinch;
    UITapGestureRecognizer *doubleTap;
}

@property (nonatomic, strong) UIImageView *view;
@property (nonatomic, readonly) GameModel *model;
@property (nonatomic, readwrite) BOOL isInGame;
@property (nonatomic, retain) id <GameObjectDelegate> delegate;


//Chipmunk physical engine components
@property (nonatomic, readonly) ChipmunkBody *body;
@property (nonatomic, readonly) NSSet *chipmunkObjects;
@property (nonatomic, readonly) ChipmunkShape *shape;

// guestures
@property (nonatomic, readonly) UIPanGestureRecognizer *pan;
@property (nonatomic, readonly) UIRotationGestureRecognizer *rotate;
@property (nonatomic, readonly) UIPinchGestureRecognizer *pinch;
@property (nonatomic, readonly) UITapGestureRecognizer *doubleTap;

- (void)translate:(UIPanGestureRecognizer *)gesture;
// MODIFIES: object model (coordinates)
// REQUIRES: game in designer mode
// EFFECTS: the user drags around the object with one finger
//          if the object is in the palette, it will be moved in the game area

- (void)rotate:(UIRotationGestureRecognizer *)gesture;
// MODIFIES: object model (rotation)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is rotated with a two-finger rotation gesture

- (void)zoom:(UIPinchGestureRecognizer *)gesture;
// MODIFIES: object model (size)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is scaled up/down with a pinch gesture

// You will need to define more methods to complete the specification. 

- (void)doubleTap:(UITapGestureRecognizer *)gesture;
// REQUIRES: game in designer mode, object in game area
// EFFECTS: delete and return object to the object palette


- (id)initWithUIImage:(UIImage *)img objectType:(GameObjectType)type frame:(CGRect)f isInGameArea:(BOOL)isInGameArea subType:(int)subType;
// EFFECTS: constructs a new GameObject from the UIImage

- (id)initWithIsInGameArea:(BOOL)isInGameArea subType:(int)subType delegate:(id)d;
- (id)initWithModel:(GameModel *)m isInGameArea:(BOOL)isInGameArea delegate:(id)d;
- (void)setPhysicalEngine;
- (void)updatePosition;
- (void)removeAllGestureRecognizers;
- (void)destroy;
@end

