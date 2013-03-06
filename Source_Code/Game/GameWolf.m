//
//  GameWolf.m
//  Game
//
//  Created by DINH TUAN NHU on 29/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameWolf.h"
#define RIGHT_ANGLE_RADIAN 1.57
const CGPoint PALETTE_WOLF_POSITION = {5.0f, 10.0f};
const CGRect WOLF_INIT_IMG_POSITION = {0, 0, GAMEAREA_WOLF_WIDTH, GAMEAREA_WOLF_HEIGHT};
@implementation GameWolf
@synthesize press;
@synthesize power;
@synthesize arrow;
@synthesize wind;
@synthesize timer;
@synthesize typeOfWind;
@synthesize skill;

- (id)initWithIsInGameArea:(BOOL)isInGameArea subType:(int)subType delegate:(id)d{
    // EFFECTS: Constructs a new GameWolf
    
    // set delegate
    self.delegate = d;
    typeOfWind = 0;
    skill = 0;
    
    // wolf frames for breathe animation
    wolfFrameAnimation = [[NSMutableArray alloc]init];
    CGImageRef imageToSplit = [UIImage imageNamed:WOLF_BREATHE_ANIMATION_IMG].CGImage;
    for (int j = 0; j < 3; j++) {
        for (int i = 0; i < 5; i++) 
        {
            CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(GAMEAREA_WOLF_WIDTH * i, GAMEAREA_WOLF_HEIGHT * j, GAMEAREA_WOLF_WIDTH, GAMEAREA_WOLF_HEIGHT));
            [wolfFrameAnimation addObject:[UIImage imageWithCGImage:partOfImageAsCG]];
        }
    }
   
    if (isInGameArea) {
        self = [super initWithUIImage:[wolfFrameAnimation objectAtIndex:0] 
                           objectType:kGameObjectWolf 
                                frame:CGRectMake(0, 0, GAMEAREA_WOLF_WIDTH, GAMEAREA_WOLF_HEIGHT)
                         isInGameArea:isInGameArea 
                              subType:subType];
    } else {
        self = [super initWithUIImage:[wolfFrameAnimation objectAtIndex:0]  
                           objectType:kGameObjectWolf 
                                frame:CGRectMake(PALETTE_WOLF_POSITION.x, PALETTE_WOLF_POSITION.y, PALETTE_WOLF_WIDTH, PALETTE_WOLF_HEIGHT)
                         isInGameArea:isInGameArea 
                              subType:subType];
    }
    
    return self;
}

- (BOOL)setTypeWind:(int)type {
    // EFFECTS: return true if wolf skills >= the skills required for the wind type 
    
    if (skill < [GameWind getSkillRequiredOfType:type]) {
        return NO;
    } else {
        typeOfWind = type;
        return YES;
    }
}

- (void)setPhysicalEngine {
    
    //Physics Engine
    body = [[ChipmunkBody alloc] initWithMass:WOLF_MASS 
                                    andMoment:cpMomentForBox(WOLF_MASS, GAMEAREA_WOLF_WIDTH * model.scale, GAMEAREA_WOLF_HEIGHT * model.scale)];
    
    shape = [ChipmunkPolyShape boxWithBody:body 
                                     width:GAMEAREA_WOLF_WIDTH * model.scale
                                    height:GAMEAREA_WOLF_HEIGHT * model.scale];
    shape.elasticity = WOLF_ELASTICITY;
    shape.friction = WOLF_FRICTION;
    shape.collisionType = [GameWolf class];
    shape.data = self;
    chipmunkObjects = ChipmunkObjectFlatten(body, shape, nil);
    
    // add long press gesture recognizer to wolf
    press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(press:)];
    [view addGestureRecognizer:press];
    
    // add arrow view to gamearea
    arrow = [[GameArrow alloc] initWithPosition:[self positionOfMouth]];
    [delegate addSubViewToGameArea:arrow.degree belowSubview:self.view];
    [delegate addSubViewToGameArea:arrow.arrow belowSubview:self.view];
    
    // add power view to main view
    power = [[GamePower alloc] initWithPosition:CGPointMake(POWER_BAR_POSITION_X, POWER_BAR_POSITION_Y)];
    [delegate addSubViewToMainView:power.view];
    
    [super setPhysicalEngine];
}

- (void)translate:(UIPanGestureRecognizer *)gesture {
    // MODIFIES: object model (coordinates)
    // REQUIRES: game in designer mode
    // EFFECTS: the user drags around the object with one finger
    //          if the object is in the palette, it will be moved in the game area
    
    if (!self.isInGame) {
        CGPoint newOrigin = [self.delegate converPointFromPaletteToGameArea:view.frame.origin];
        view.frame = CGRectMake(newOrigin.x, newOrigin.y, GAMEAREA_WOLF_WIDTH, GAMEAREA_WOLF_HEIGHT);
        [self.delegate addSubViewToGameArea:view];
        self.isInGame = YES;
    }
    [super translate:gesture];
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture{
    // REQUIRES: game in designer mode, object in game area
    // EFFECTS: delete and return object to the object palette
    
    GameWolf *wolf = [[GameWolf alloc] initWithIsInGameArea:NO subType:0 delegate:self.delegate];
    [self.delegate addObject:wolf];
    [super doubleTap:gesture];
}

- (void)press:(UIGestureRecognizer *)gesture {
    // REQUIRES: game in designer mode, object in game area, game started
    // EFFECTS: change the power of wind and call method to breathe
    
    UILongPressGestureRecognizer *pressGesture = (UILongPressGestureRecognizer *) gesture;
    if (pressGesture.state == UIGestureRecognizerStateBegan) {
        if (skill < [GameWind getSkillRequiredOfType:typeOfWind]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showDialogNotEnoughSkillOnGame" object:self];
        } else {
            [self initBreath];
            [power startChangePower];
        }
    }
    
    if (pressGesture.state == UIGestureRecognizerStateEnded) {
        if (skill >= [GameWind getSkillRequiredOfType:typeOfWind]){
            [view startAnimating];
            [power endChangePower];
            [self startBreath];
        }
    }
   
}

- (void)updatePosition {
    
    if (wind) {
        [wind updatePosition];
    }
    if (!CGPointEqualToPoint(view.center, body.pos) && arrow && power) {
        [arrow updatePosition:[self positionOfMouth]];
    }
    [super updatePosition];
}

- (CGPoint)positionOfMouth {
    return CGPointMake(view.frame.origin.x + (GAMEAREA_WOLF_WIDTH - 10) * model.scale, view.frame.origin.y + 40 * model.scale);
}

- (void)initBreath {
    
    view.image = [wolfFrameAnimation objectAtIndex:5];
    view.animationImages = [wolfFrameAnimation subarrayWithRange:NSMakeRange(0, 6)];
    view.animationDuration = 2;
    view.animationRepeatCount = 1;
    [view startAnimating];
    wind = [[GameWind alloc] initWithPosition:[self positionOfMouth] type:typeOfWind];
    [delegate addSubViewToGameArea:wind.view];
    [wind windSuck];
}

- (void)startBreath {

    [view removeGestureRecognizer:press];    
    view.image = [wolfFrameAnimation objectAtIndex:14];
    [view stopAnimating];
    view.animationImages = [wolfFrameAnimation subarrayWithRange:NSMakeRange(6, 9)];
    view.animationDuration = 0.5;
    view.animationRepeatCount = 1;
    [view startAnimating];
    
    [wind windBlowed];
    skill -= wind.skillRequired;

    // apply impulse to wind
    [wind.body applyImpulse: cpvmult(cpv(cos(RIGHT_ANGLE_RADIAN - arrow.angle), -sin(RIGHT_ANGLE_RADIAN - arrow.angle)), power.power * POWER_TO_IMPULSE_FORCE) offset:cpv(0,0)];
    [delegate addObjectToSpace:wind];
    timer = [NSTimer scheduledTimerWithTimeInterval:WIND_LIFE_TIME
                                     target:self
                                   selector:@selector(stopBreath)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)stopBreath {

    if (wind) {
        [timer invalidate];
        [delegate removeObjectFromSpace:wind];
        [wind.view removeFromSuperview];
        wind = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateWolfSkillOnGame" object:self];
        [view addGestureRecognizer:press];
    }
}

- (void)die {
    NSMutableArray *wolfDieAnimation = [[NSMutableArray alloc]init];
    CGImageRef imageToSplit = [UIImage imageNamed:WOLF_DIE_ANIMATION_IMG].CGImage;
    for (int j = 0; j < 4; j++) {
        for (int i = 0; i < 4; i++) 
        {
            CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(237 * i, 185 * j, 237, 185));
            [wolfDieAnimation addObject:[UIImage imageWithCGImage:partOfImageAsCG]];
        }
    }
    view.image = [wolfDieAnimation objectAtIndex:wolfDieAnimation.count - 1];
    view.animationImages = wolfDieAnimation;
    view.animationDuration = 4;
    view.animationRepeatCount = 1;
    [arrow.degree removeFromSuperview];
    [arrow.arrow removeFromSuperview];
    [power.view removeFromSuperview];
    [view startAnimating];
}
@end;