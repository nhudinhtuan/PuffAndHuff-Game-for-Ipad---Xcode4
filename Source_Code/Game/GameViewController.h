//
//  GameViewController.h
//  Game
//
//  Created by DINH TUAN NHU on 26/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "GameDatabaseAccess.h"

@interface GameViewController : UIViewController {
    AVAudioPlayer *audioPlayer;
    BOOL playSound;
}

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIImageView *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *pig;
@property (weak, nonatomic) IBOutlet UIImageView *sound;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (readonly, nonatomic) BOOL playSound;

@end