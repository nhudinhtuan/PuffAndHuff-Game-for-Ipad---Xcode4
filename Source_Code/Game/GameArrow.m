//
//  GameArrow.m
//  Game
//
//  Created by DINH TUAN NHU on 19/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameArrow.h"

@implementation GameArrow
@synthesize arrow, degree, angle;

- (id)initWithPosition:(CGPoint)position {
    
    UIImage *img = [UIImage imageNamed:DEGREE_IMG];
    degree = [[UIImageView alloc] initWithImage:img];
    degree.frame = CGRectMake(position.x, position.y - img.size.width, img.size.width, img.size.height);
    
    img = [UIImage imageNamed:ARROW_IMG];
    arrow = [[UIImageView alloc] initWithImage:img];
    arrow.userInteractionEnabled = YES;
    arrow.exclusiveTouch = YES;
    arrow.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    arrow.center = position;

    [arrow addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(directArrow:)]];

    angle = MIN_DEGREE;
    arrow.transform = CGAffineTransformRotate(arrow.transform, angle);
    return self;
    
}


- (void)directArrow:(UIGestureRecognizer *)gesture {
    
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gesture;
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state ==UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:arrow.superview];	
        float newAngle = angle + translation.y/100;
	if (newAngle <= MAX_DEGREE && newAngle >= MIN_DEGREE) {
            arrow.transform = CGAffineTransformRotate(arrow.transform, translation.y/100);
            [panGesture setTranslation:CGPointZero inView:arrow.superview];
            angle = newAngle;
        };
    }
    UIImage *arrowSelectedImg = [UIImage imageNamed:ARROW_SELECTED_IMG];
    UIImage *arrowImg = [UIImage imageNamed:ARROW_IMG];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        [arrow setImage:arrowSelectedImg];
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        [arrow setImage:arrowImg];
    }
}

- (void)updatePosition:(CGPoint)position {
    degree.frame = CGRectMake(position.x, position.y - degree.frame.size.width, degree.frame.size.width, degree.frame.size.height);
    arrow.center = position;
}

@end
