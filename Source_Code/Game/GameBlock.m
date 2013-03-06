//
//  GameBlock.m
//  Game
//
//  Created by DINH TUAN NHU on 29/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameBlock.h"
const CGPoint PALETTE_BLOCK_POSITION = {210.0f, 20.0f};
const float blockMass[] = {1.0, 2.0, 3.0, 4.0};
const float blockElasticity[] = {0.5, 0.3, 0.1, 0.0}; 
const float blockFriction[] = {1.0, 1.0, 1.0, 1.0}; 
@implementation GameBlock
@synthesize singleTap;
- (id)initWithIsInGameArea:(BOOL)isInGameArea subType:(int)subType delegate:(id)d {
    // EFFECTS: Constructs a new GameBlock
    
    UIImage *image = [UIImage imageNamed:[images objectAtIndex:subType]];
    self.delegate = d;
    if (isInGameArea) {
        self = [super initWithUIImage:image 
                           objectType:kGameObjectBlock 
                                frame:CGRectMake(0, 0, GAMEAREA_BLOCK_WIDTH, GAMEAREA_BLOCK_HEIGHT) 
                         isInGameArea:isInGameArea 
                              subType:subType];
    } else {
        self = [super initWithUIImage:image 
                           objectType:kGameObjectBlock 
                                frame:CGRectMake(PALETTE_BLOCK_POSITION.x, PALETTE_BLOCK_POSITION.y, PALETTE_BLOCK_WIDTH, PALETTE_BLOCK_HEIGHT) 
                         isInGameArea:isInGameArea 
                              subType:subType];
    }
    
    singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [view addGestureRecognizer:singleTap];
    type = subType;
    return self;
}

- (void)setPhysicalEngine {
    
    body = [[ChipmunkBody alloc] initWithMass:blockMass[model.subType] * model.scale
                                    andMoment:cpMomentForBox(blockMass[model.subType] , GAMEAREA_BLOCK_WIDTH * model.scale, GAMEAREA_BLOCK_HEIGHT * model.scale)];
    
    shape = [ChipmunkPolyShape boxWithBody:body 
                                     width:GAMEAREA_BLOCK_WIDTH * model.scale 
                                    height:GAMEAREA_BLOCK_HEIGHT * model.scale];
    shape.elasticity = blockElasticity[model.subType];
    shape.friction = blockFriction[model.subType];
    shape.collisionType = [GameBlock class];
    shape.data = self;
    chipmunkObjects = ChipmunkObjectFlatten(body, shape, nil);
    [super setPhysicalEngine];
}

- (void)translate:(UIPanGestureRecognizer *)gesture {
    // MODIFIES: object model (coordinates)
    // REQUIRES: game in designer mode
    // EFFECTS: the user drags around the object with one finger
    //          if the object is in the palette, it will be moved in the game area
    
    if (!self.isInGame) {
        CGPoint newOrigin = [self.delegate converPointFromPaletteToGameArea:view.frame.origin];
        view.frame = CGRectMake(newOrigin.x, newOrigin.y, 30, 130);
        [self.delegate addSubViewToGameArea:view];
        GameBlock *block = [[GameBlock alloc] initWithIsInGameArea:NO subType:0 delegate:self.delegate];
        [self.delegate addObject:block];
        self.isInGame = YES;
    }
    [super translate:gesture];
}


- (void)tap:(UITapGestureRecognizer *)gesture {	
    // MODIFIES: object model (path)
    // REQUIRES: game in designer mode, object in game area
    // EFFECTS: change the type of the block
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        type++;
        if (type == 4) {
            type = 0;
        }
        NSString *imgName = [images objectAtIndex:type];
        UIImage *stateImage = [UIImage imageNamed:imgName];
        [view setImage:stateImage];
        model.subType = type;
    }
}

- (void)removeAllGestureRecognizers {
    [view removeGestureRecognizer:singleTap];
    [super removeAllGestureRecognizers];
}

@end;