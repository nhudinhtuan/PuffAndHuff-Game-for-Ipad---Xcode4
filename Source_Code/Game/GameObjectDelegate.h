//
//  GameObjectDelegate.h
//  Game
//
//  Created by DINH TUAN NHU on 26/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameObject;

@protocol GameObjectDelegate <NSObject>

@optional
- (void)addSubViewToPalette:(UIImageView *)view;
- (CGPoint)converPointFromPaletteToGameArea:(CGPoint)point;
- (void)addObjectToSpace:(id)object;
- (void)removeObjectFromSpace:(id)object;
- (void)addSubViewToMainView:(UIView *)view;

@required
- (void)addObject:(GameObject *)object;
- (void)removeObject:(GameObject *)object;
- (void)addSubViewToGameArea:(UIImageView *)view;
- (void)addSubViewToGameArea:(UIImageView *)view belowSubview:(UIImageView *)belowView;
- (void)addSubViewToGameArea:(UIImageView *)view;
@end

