//
//  MusicViewController.m
//  Music
//
//  Created by loveuu on 15/4/13.
//  Copyright (c) 2013年 loveuu. All rights reserved.
//
/****
未解决的问题，
 选中播放上一首下一首的bug
 歌词和歌曲时间不一样长的时候会崩溃
 歌词居中
 ***/

#import "MusicViewController.h"

@interface MusicViewController ()

@end

@implementation MusicViewController
/***三个初始化分别初始化 Data LRc viewDidLoad strart***/
#pragma mark-
#pragma mark Init Funtion 
-(void)initData:(Music *)AgainMusic
{
    Music* music1 = [[Music alloc]initWithName:@"Goodgirl" andType:@"mp3"];
    Music* music2 = [[Music alloc]initWithName:@"没离开过" andType:@"mp3"];
    Music* music3 = [[Music alloc]initWithName:@"倾城" andType:@"mp3"];
    MusicArray = [[NSMutableArray alloc]initWithCapacity:3];
    [MusicArray addObject:music1];
    [MusicArray addObject:music2];
    [MusicArray addObject:music3];
    if (AgainMusic == nil) {
        currentMusic = music1;
        currentMusicKey =0;
        AudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:currentMusic.name ofType:currentMusic.type]] error:nil];
    }else{
         NSLog(@"initData MusicArray =%u",[MusicArray indexOfObject:currentMusic]);
        AudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:AgainMusic.name ofType:AgainMusic.type]] error:nil];
    }
   
    [music1 release];
    [music2 release];
    [music3 release];
}
-(void)initLRC
{
    
    NSString* LRCPath = [[NSBundle mainBundle]pathForResource:currentMusic.name ofType:@"lrc"];
    NSString* contentStr = [NSString stringWithContentsOfFile:LRCPath encoding:NSUTF8StringEncoding error:nil];
    NSArray* array = [contentStr componentsSeparatedByString:@"\n"];
    for(int i=0;i<[array count];i++)
    {
        NSString* lineStr = [array objectAtIndex:i];
        NSArray* lineArray = [lineStr componentsSeparatedByString:@"]"];
        if([[lineArray objectAtIndex:0] length]>5)
        {
            NSString* lrcStr = [lineArray objectAtIndex:1];
            NSString* lrcTime = [[lineArray objectAtIndex:0] substringWithRange:NSMakeRange(1, 5)];
            [lrcDitionary setObject:lrcStr forKey:lrcTime];
            [timeArray addObject:lrcTime];
        }
    }
    //command +? 是批量注释NSDictionary 是一种hash表, 是乱序的, 如果想要顺序就用NSArray
    //    for(id key in  lrcDitionary)
    //    {
    //        NSLog(@"key=%@ and valueTime=%@",key,[lrcDitionary objectForKey:key]);
    //    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isPlay=YES;;
    listHidden=YES;
    _listTableView.hidden=YES;
    _progressSlider.value=0.0f;
  
    //构造一个导航的rightbarbutton 然后加到navigation里
    //并且通过showListView来控制lishTableView的显示
    UIButton *listBtn  = [UIButton buttonWithType:0];
    listBtn.frame = CGRectMake(0, 0, 40, 40);
    [listBtn setImage:[UIImage imageNamed:@"list.png"]forState:UIControlStateNormal];
    [listBtn addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:listBtn];
    timeArray = [[NSMutableArray alloc]initWithCapacity:20];
    lrcDitionary = [[NSMutableDictionary alloc]initWithCapacity:20];
    if (currentMusic ==nil) {
        [self initData:nil];
    }else{
        //NSLog(@"%u",[MusicArray indexOfObject:currentMusic]);
        [self initData:currentMusic];
    }
    [self initLRC];
}

/***三个初始化分别初始化 Data LRc viewDidLoad end ***/
#pragma mark-
#pragma mark callBack Function 
-(void)displaySongWord:(NSUInteger)time
{
    
    //NSLog(@"timeArraytime= %@",[timeArray objectAtIndex:time]);
    //输出的是时间time= 00:55
    static int index=0;
    NSArray* array = [[timeArray objectAtIndex:index] componentsSeparatedByString:@":"];
    NSUInteger atTime = [[array objectAtIndex:0] intValue]*60 +[[array objectAtIndex:1]intValue];
    if(time == atTime)
    {
        [self selectTimeShowLrc:index];
        index++;
    }
}
-(void)selectTimeShowLrc:(NSUInteger)index
{
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_LRCTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}
-(void)showListView
{
    if(listHidden)
    {
        _listTableView.hidden=NO;
        listHidden = NO;
    }else{
        _listTableView.hidden=YES;
        listHidden = YES;
    }
}
-(void)showTime
{
   // 实现循环播放 先判断时间完了，然后
     
    if((int)AudioPlayer.duration == (int)AudioPlayer.currentTime+1)
    {
        int i = [MusicArray indexOfObject:currentMusic];
        currentMusic = [MusicArray objectAtIndex:i+1];
        [self reloadMusic];
    }
    if((int)AudioPlayer.currentTime%60<10)
    {
        _currentTime.text = [NSString stringWithFormat:@"%d:0%d",(int)AudioPlayer.currentTime/60,(int)AudioPlayer.currentTime%60];
    }else{
        _currentTime.text = [NSString stringWithFormat:@"%d:%d",(int)AudioPlayer.currentTime/60,(int)AudioPlayer.currentTime%60];
    }
    _progressSlider.value=AudioPlayer.currentTime/AudioPlayer.duration;
    [self displaySongWord:AudioPlayer.currentTime];
}

- (IBAction)play:(id)sender {
    if(isPlay)
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showTime) userInfo:nil repeats:YES];
        [AudioPlayer play];
        [self.playbtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        isPlay=NO;
        
        //这里使用setImage生效 使用setbackground的不生效
    }else
    {
        [AudioPlayer pause];
        [_playbtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        isPlay=YES;
    }
    _totalTime.text = [NSString stringWithFormat:@"%d:%d",(int)AudioPlayer.duration/60,(int)AudioPlayer.duration%60];
    
}

//- (void)playAgain:(Music *)cutMusic
//{
//    int i = [MusicArray indexOfObject:cutMusic];
//    currentMusic = [MusicArray objectAtIndex:i+1];
//    isPlay=YES;
//    [self play:currentMusic];
//    NSLog(@"is excute..");
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [_playbtn release];
    [_soundSlider release];
    [_progressSlider release];
    [_currentTime release];
    [_totalTime release];
    [_listTableView release];
    [_LRCTableView release];
    [super dealloc];
}

/***控制函数 上一首下一首 声音on off... start**/

#pragma mark -
#pragma mark  Control Function list 
- (IBAction)above:(id)sender {
    //[AudioPlayer release];
    //NSLog(@"abc :%d",123);
    NSLog(@"abovekey=%d",currentMusicKey);
    for (int i=0; i<[MusicArray count]; i++) {
        NSLog(@"blowoutputmusicarray:%@",[MusicArray objectAtIndex:i]);
    }
    
    if(currentMusicKey!=0)
    {
        [AudioPlayer release];
        currentMusic = [MusicArray objectAtIndex:currentMusicKey-1];
        currentMusicKey--;
        [self reloadMusic];
    }else{
        [AudioPlayer release];
        currentMusic = [MusicArray objectAtIndex:0];
        [self reloadMusic];
    }
}

- (IBAction)blow:(id)sender {

    NSLog(@"%d",currentMusicKey);
    
    if(currentMusicKey<[MusicArray count]-1)
    {
        [AudioPlayer release];
        currentMusic = [MusicArray objectAtIndex:++currentMusicKey];
         
        [self reloadMusic];
    }else{
        [AudioPlayer release];
        currentMusicKey=0;
        currentMusic = [MusicArray objectAtIndex:currentMusicKey];
        [self reloadMusic];
    }
}
- (void)reloadMusic
{
        isPlay=YES;
        [self initData:currentMusic];
        [self viewDidLoad];
        [_LRCTableView reloadData];
        [self play:currentMusic];
       
}
- (IBAction)stop:(id)sender {
    [AudioPlayer stop];
}

- (IBAction)pregressChange:(id)sender {
    AudioPlayer.currentTime = _progressSlider.value*AudioPlayer.duration;
}

- (IBAction)soundChange:(id)sender {
    AudioPlayer.volume =_soundSlider.value;
}

- (IBAction)soundoff:(id)sender {
    AudioPlayer.volume = 0.0f;
    _soundSlider.value = 0.0f;
}

- (IBAction)soundon:(id)sender {
    AudioPlayer.volume+=0.1f;
    _soundSlider.value+=AudioPlayer.volume;
}
 
/***控制函数 上一首下一首 声音on off... end**/

#pragma mark-
#pragma mark DateSource Required 

//*******dataSource里的要实现的方法****//
//加入在.h文件中有声明tableView这个变量和这个
//(UITableView *)tableView冲突有有个警告需要这么处理
//(UITableView *)_tableView 就可以了
//第一个是返回cell行数 第二个是根据唯一标示来填充cell的内容和样式
//这里的tableView是(UITableView *)tableView传过来的参数 所以做判断的时候一定要用tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(tableView.tag==999)
    {
        return  [MusicArray count];
    }else{
        return  [timeArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   //这里的tableView是(UITableView *)tableView传过来的参数
    
    if(tableView.tag == 999)
    {
        static NSString* cellIdentifier=@"cell";
        UITableViewCell *cell = [_listTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        Music *music = [MusicArray objectAtIndex:indexPath.row];
        cell.textLabel.text = music.name;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor yellowColor];
        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor=[UIColor orangeColor];        
        return cell;
        
    }else{
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        static NSString* cellIdentifier=@"LRCcell";
        UITableViewCell *cell = [_LRCTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text= [lrcDitionary objectForKey:[timeArray objectAtIndex:indexPath.row]];
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
//当选中tableview里的Section返回row然后拿到row播放音乐
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      
    NSUInteger row = [indexPath row];
    currentMusicKey=row;
    if(0<=currentMusicKey<(int)[MusicArray count])
    {
        [AudioPlayer release];
        currentMusic = [MusicArray objectAtIndex:currentMusicKey];
        [self reloadMusic];
    }else{
        currentMusic = [MusicArray objectAtIndex:0];
        [self reloadMusic];
    }
}
@end
