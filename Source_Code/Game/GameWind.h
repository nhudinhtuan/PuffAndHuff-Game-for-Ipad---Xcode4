//
//  GameWind.h
//  Game
//
//  Created by DINH TUAN NHU on 21/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveChipmunk.h"
#import "constant.h"

@interface GameWind : UIViewController{
    UIImageView *view;
    ChipmunkBody *body;
    NSSet *chipmunkObjects;
    ChipmunkShape *shape;
    int type;
    int skillRequired;
    NSMutableArray *windFrameAnimation;
    NSMutableArray *windSuckAnimation;
}
@property (nonatomic, strong) UIImageView *view;

//Chipmunk
@property (nonatomic, readonly) ChipmunkBody *body;
@property (nonatomic, readonly) NSSet *chipmunkObjects;
@property (nonatomic, readonly) ChipmunkShape *shape;
@property (nonatomic, readonly) int type;
@property (nonatomic, readonly) int skillRequired;
@property (nonatomic, readonly) NSMutableArray *windFrameAnimation;
@property (nonatomic, readonly) NSMutableArray *windSuckAnimation;

- (id)initWithPosition:(CGPoint)position type:(int)typeWind;
- (void)updatePosition;
- (void)windSuck;
- (void)windBlowed;
+ (int)getSkillRequiredOfType:(int)type;
@end
