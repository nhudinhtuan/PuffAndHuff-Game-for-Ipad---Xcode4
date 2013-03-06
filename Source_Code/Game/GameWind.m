//
//  GameWind.m
//  Game
//
//  Created by DINH TUAN NHU on 21/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameWind.h"

const int windTypeFrameNumber[] = {10, 8, 9, 8};
const int windSkillRequired[] = {1, 5, 10, 15};

@implementation GameWind
@synthesize view;
@synthesize body;
@synthesize chipmunkObjects;
@synthesize shape;
@synthesize type;
@synthesize skillRequired;
@synthesize windFrameAnimation;
@synthesize windSuckAnimation;

- (id)initWithPosition:(CGPoint)position type:(int)typeWind {
    
    type = typeWind;
    skillRequired = windSkillRequired[type];
    
    CGImageRef imageToSplit = [UIImage imageNamed:[WIND_IMGS objectAtIndex:type]].CGImage;    
    windFrameAnimation = [[NSMutableArray alloc]init];
    for (int i = 0; i < windTypeFrameNumber[type]; i++) {
        CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(WIND_FRAME_SIZE * i, 0, WIND_FRAME_SIZE, WIND_FRAME_SIZE));
            [windFrameAnimation addObject:[UIImage imageWithCGImage:partOfImageAsCG]];
    }
    
    imageToSplit = [UIImage imageNamed:WIND_SUCK_IMG].CGImage;    
    windSuckAnimation = [[NSMutableArray alloc]init];
    for (int j = 0; j < 2; j++) {
        for (int i = 0; i < 4; i++) 
        {
            CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(WIND_SUCK_FRAME_WIDTH * i, WIND_SUCK_FRAME_HEIGHT * j, WIND_SUCK_FRAME_WIDTH, WIND_SUCK_FRAME_HEIGHT));
            [windSuckAnimation addObject:[UIImage imageWithCGImage:partOfImageAsCG]];
        }
    }
    
    view = [[UIImageView alloc] initWithImage:[windFrameAnimation objectAtIndex:0]];
    view.frame = CGRectMake(0, 0, WIND_FRAME_SIZE, WIND_FRAME_SIZE);
    view.center = position;
    
    cpFloat mass = WIND_MASS;
    cpFloat moment = cpMomentForCircle(mass, 5, 10, cpv(0, 0));
    body = [[ChipmunkBody alloc] initWithMass:mass andMoment:moment];
    body.pos = position;
    
    shape = [ChipmunkCircleShape circleWithBody:body radius:WIND_RADIUS offset:cpv(0,0)];
    shape.elasticity = WIND_ELASTICITY;
    shape.friction = WIND_FRICTION;
    shape.collisionType = [GameWind class];
    shape.data = self;
    chipmunkObjects = ChipmunkObjectFlatten(body, shape, nil);
    
    return self;
}

- (void)windSuck{
    view.animationImages = windSuckAnimation;
    view.animationDuration = 2;
    view.animationRepeatCount = 1;
    [view startAnimating];
}

- (void)windBlowed{
    [view stopAnimating];
    view.image = [windFrameAnimation objectAtIndex:(windFrameAnimation.count - 1)];
    view.animationImages = windFrameAnimation;
    view.animationDuration = WIND_LIFE_TIME;
    view.animationRepeatCount = 1;
    [view startAnimating];
}

+ (int)getSkillRequiredOfType:(int)type {
    
    return windSkillRequired[type];
}

- (void)updatePosition {
    
    view.transform = body.affineTransform;
    view.center = [body world2local:body.pos];
}
@end
