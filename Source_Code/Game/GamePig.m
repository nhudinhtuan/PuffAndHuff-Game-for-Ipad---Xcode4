//
//  GamePig.m
//  Game
//
//  Created by DINH TUAN NHU on 29/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GamePig.h"
const CGPoint PALETTE_PIG_POSITION = {110.0f, 20.0f};
@implementation GamePig
@synthesize health;
@synthesize inDestroyProcess;


- (id)initWithIsInGameArea:(BOOL)isInGameArea subType:(int)subType delegate:(id)d {
    // EFFECTS: Constructs a new GamePig.
    
    UIImage *image = [UIImage imageNamed:PIG_IMG];
    self.delegate = d;
    health = PIG_HEATH;
    
    if (isInGameArea) {
        self = [super initWithUIImage:image 
                           objectType:kGameObjectPig 
                                frame:CGRectMake(0, 0, GAMEAREA_PIG_WIDTH, GAMEAREA_PIG_HEIGHT)  
                         isInGameArea:isInGameArea 
                              subType:subType];
    } else {
        self = [super initWithUIImage:image 
                           objectType:kGameObjectPig 
                                frame:CGRectMake(PALETTE_PIG_POSITION.x, PALETTE_PIG_POSITION.y, PALETTE_PIG_WIDTH, PALETTE_PIG_HEIGHT) 
                         isInGameArea:isInGameArea 
                              subType:subType];
    }

    // pig die animation
    pigDieAnimation = [[NSMutableArray alloc]init];
    CGImageRef imageToSplit = [UIImage imageNamed:PIG_DIE_IMG].CGImage;
    for (int j = 0; j < 2; j++) {
        for (int i = 0; i < 5; i++) 
        {
            CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(80 * i, 80 * j, 80, 80));
            [pigDieAnimation addObject:[UIImage imageWithCGImage:partOfImageAsCG]];
        }
    }

    view.animationImages = pigDieAnimation;
    view.animationDuration = 1.5;
    view.animationRepeatCount = 1;
    
    inDestroyProcess = NO;
    return self;
}

- (void)setPhysicalEngine {
    body = [[ChipmunkBody alloc] initWithMass:PIG_MASS * model.scale
                                    andMoment:cpMomentForBox(PIG_MASS, GAMEAREA_PIG_WIDTH * model.scale, GAMEAREA_PIG_HEIGHT * model.scale)];
    
    shape = [ChipmunkPolyShape boxWithBody:body 
                                     width:GAMEAREA_PIG_WIDTH * model.scale 
                                    height:GAMEAREA_PIG_HEIGHT * model.scale];
    shape.elasticity = PIG_ELASTICITY;
    shape.friction = PIG_FRICTION;
    shape.collisionType = [GamePig class];
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
        view.frame = CGRectMake(newOrigin.x, newOrigin.y, GAMEAREA_PIG_WIDTH, GAMEAREA_PIG_HEIGHT);
        [self.delegate addSubViewToGameArea:view];
        // more than one pigs are allowed
        GamePig *pig = [[GamePig alloc] initWithIsInGameArea:NO subType:0 delegate:self.delegate];
        [self.delegate addObject:pig];
        self.isInGame = YES;
    }
    [super translate:gesture];
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture {
    // REQUIRES: game in designer mode, object in game area
    // EFFECTS: delete and return object to the object palette
    
    GamePig *pig = [[GamePig alloc] initWithIsInGameArea:NO subType:0 delegate:self.delegate];
    [self.delegate addObject:pig];
    [super doubleTap:gesture];
}

- (void)reduceHeath:(float)number {
    
    if (inDestroyProcess) {
        return;
    }
    
    health -= number;
    if (health < 0) {
        view.image = [pigDieAnimation objectAtIndex:(pigDieAnimation.count - 1)];
        [view startAnimating];
        [NSTimer scheduledTimerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(destroy)
                                       userInfo:nil
                                        repeats:NO];
        inDestroyProcess = YES;
    } else if (health < 0.5 * PIG_HEATH) {
        view.image = [UIImage imageNamed:PIG_CRY_IMG];
    }
}
@end
