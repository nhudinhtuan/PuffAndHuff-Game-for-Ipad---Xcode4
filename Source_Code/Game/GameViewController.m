//
//  GameViewController.m
//  Game
//
//  Created by DINH TUAN NHU on 26/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameViewController.h"
#import "constant.h"


@implementation GameViewController

@synthesize background;
@synthesize playButton;
@synthesize playSound;
@synthesize pig;
@synthesize sound;
@synthesize audioPlayer;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    playSound = YES;
    
    // add background music
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:MUSIC_INTRO_FILE_NAME ofType:MUSIC_INTRO_FILE_TYPE];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioFilePath] error:nil];
    [audioPlayer prepareToPlay];
    audioPlayer.numberOfLoops = -1;
    
    // add swipe gesture recognizer (2 fingures - left direction) to background  
    background.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    swipe.numberOfTouchesRequired = 2;
    [background addGestureRecognizer:swipe];
    
    // add animation to pig view
    pig.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:PIG_IMG], [UIImage imageNamed:PIG_CRY_IMG], nil];
    pig.animationDuration = 2;
    [pig startAnimating];
    
    // add tap gesture recognizer to sound view
    sound.userInteractionEnabled = YES;
    [sound addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(soundControl:)]];
    
    // add tap gesture recognizer to playButton view
    playButton.userInteractionEnabled = YES;
    [playButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPlayView:)]];
}

- (void)viewDidAppear:(BOOL)animated {
    if (audioPlayer && playSound) {
        [audioPlayer play];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [audioPlayer stop];
}

- (void)viewDidUnload {
    
    [self setPig:nil];
    [self setSound:nil];
    [self setPlayButton:nil];
    [self setBackground:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // only support Landscape
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)soundControl:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (playSound) {
            sound.image = [UIImage imageNamed:OFF_SOUND_IMG];
            playSound = NO;
            [audioPlayer stop];
        } else {
            sound.image = [UIImage imageNamed:ON_SOUND_IMG];
            playSound = YES;
            [audioPlayer play];
        }
    }
}

- (void)openPlayView:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:@"LevelMenu" sender:self];
    }
}

- (void)swipeRecognizer:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft){
        [self performSegueWithIdentifier:@"LevelMenu" sender:self];
    }
}

@end
