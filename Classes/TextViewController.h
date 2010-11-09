//
//  TextViewController.h
//  TextCelerant
//
//  Created by Eric Wagner on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PAUSED 0
#define RUNNING 1

@interface TextViewController : UIViewController <UIScrollViewDelegate> {
    UILabel *label;
    UILabel *doneLabel;
    UILabel *speedLabel;
    UILabel *pausedLabel;
    UISlider *speedSlider;
    UISlider *textProgress;
    UISlider *charactersPerFrame;
    UISlider *textSize;
    NSTimer *timer;
    NSArray *words;
    UIScrollView *scrollView;
    int iteration;
    int wordsPerMinute;
    int state;
    int wordsPerFrame;
    int currentFramwWordCount;
    float charactersPerWord;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UILabel *doneLabel;
@property (nonatomic, retain) IBOutlet UILabel *speedLabel;
@property (nonatomic, retain) IBOutlet UILabel *pausedLabel;
@property (nonatomic, retain) IBOutlet UISlider *speedSlider;
@property (nonatomic, retain) IBOutlet UISlider *charactersPerFrame;
@property (nonatomic, retain) IBOutlet UISlider *textSize;
@property (nonatomic, retain) IBOutlet UISlider *textProgress;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSArray *words;

- (void)alarmFired;
- (void)refreshWord;
- (void)showControls;
- (void)hideControls;

@end
