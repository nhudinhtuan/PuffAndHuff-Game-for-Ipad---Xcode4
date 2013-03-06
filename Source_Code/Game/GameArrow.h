//
//  GameArrow.h
//  Game
//
//  Created by DINH TUAN NHU on 19/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constant.h"
@interface GameArrow : UIViewController {
    UIImageView *arrow;
    UIImageView *degree;
    float angle;
}

@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UIImageView *degree;
@property (nonatomic, readonly) float angle;

- (id)initWithPosition:(CGPoint)position;
- (void)directArrow:(UIGestureRecognizer *)gesture;
- (void)updatePosition:(CGPoint)position;
@end
