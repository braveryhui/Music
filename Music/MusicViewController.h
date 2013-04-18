//
//  MusicViewController.h
//  Music
//
//  Created by loveuu on 15/4/13.
//  Copyright (c) 2013年 loveuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Music.h"

@interface MusicViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate >
{
    AVAudioPlayer* AudioPlayer;
    NSMutableArray* MusicArray;
    BOOL isPlay;
    BOOL listHidden;
    Music* currentMusic;
    NSMutableArray* timeArray;
    NSMutableDictionary* lrcDitionary;
    int currentMusicKey;
}
- (IBAction)above:(id)sender;
- (IBAction)blow:(id)sender;
- (IBAction)play:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *playbtn;
- (IBAction)stop:(id)sender;
@property (retain, nonatomic) IBOutlet UISlider *soundSlider;
@property (retain, nonatomic) IBOutlet UISlider *progressSlider;
@property (retain, nonatomic) IBOutlet UILabel *currentTime;
@property (retain, nonatomic) IBOutlet UILabel *totalTime;
@property (retain, nonatomic) IBOutlet UITableView *listTableView;
@property (retain, nonatomic) IBOutlet UITableView *LRCTableView;
- (IBAction)pregressChange:(id)sender;
- (IBAction)soundChange:(id)sender;
- (IBAction)soundoff:(id)sender;
- (IBAction)soundon:(id)sender;


@end
