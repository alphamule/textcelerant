//
//  TextViewController.m
//  TextCelerant
//
//  Created by Eric Wagner on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TextViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation TextViewController

@synthesize label, textProgress, speedSlider, words, scrollView, doneLabel, speedLabel, pausedLabel, charactersPerFrame, textSize;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
        return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    wordsPerMinute = 1000;
    state = PAUSED;
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"snow-crash" ofType:@"txt"];
    NSString *wordsText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    words = [[wordsText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] retain];
    charactersPerWord = 1.0 * ([wordsText length] - [words count]) / [words count];
    NSLog(@"charactersPerWord = %f", charactersPerWord);

    [textProgress setMinimumValue:0];
    [textProgress setMaximumValue:[words count] - 1];
    [textProgress setValue:0];
    [textProgress addTarget:self action:@selector(refreshWord) forControlEvents:UIControlEventAllEvents];

    [speedSlider setMinimumValue:100];
    [speedSlider setMaximumValue:1200];
    [speedSlider setValue:350];
    [speedSlider addTarget:self action:@selector(refreshWord) forControlEvents:UIControlEventAllEvents];

    [charactersPerFrame setMinimumValue:0];
    [charactersPerFrame setMaximumValue:50];
    [charactersPerFrame setValue:0];
    [charactersPerFrame setAlpha:0];
    [charactersPerFrame addTarget:self action:@selector(refreshWord) forControlEvents:UIControlEventAllEvents];

    [textSize setMinimumValue:6];
    [textSize setMaximumValue:100];
    [textSize setValue:label.font.pointSize];
    [textSize setAlpha:0.0];
    [textSize addTarget:self action:@selector(refreshWord) forControlEvents:UIControlEventAllEvents];

    [pausedLabel setText:@"paused"];
    [pausedLabel setAlpha:0.0];

    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touched, state=%d", state);

    if (state == RUNNING) {
        NSLog(@"pausing");
        state = PAUSED;
        [self showControls];
        [self refreshWord];
        [timer invalidate];
//      [charactersPerFrame setAlpha:1];
//      [textSize setAlpha:1];

    } else if (state == PAUSED && [[touches anyObject] tapCount] == 2) {
        NSLog(@"running, state=%d", state);
        state = RUNNING;
        [self hideControls];
//      [charactersPerFrame setAlpha:0];
//      [textSize setAlpha:0];
        wordsPerFrame = charactersPerFrame.value / charactersPerWord;
        if (wordsPerFrame < 1) {
            wordsPerFrame = 1;
        }
        [self alarmFired];
        NSLog(@"wordsPerFrame = %d", wordsPerFrame);
    } else {
        NSLog(@"Doing nothing, state=%d", state);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)refreshWord
{
    NSMutableString *text = [NSMutableString stringWithCapacity:charactersPerFrame.value];
    [text appendString:[words objectAtIndex:textProgress.value]];
    int extrawords = 0;
    while (TRUE) {
        if ((textProgress.value + extrawords + 1) >= [words count]) {
            break;
        }

        NSString *nextWord = [words objectAtIndex:(textProgress.value + extrawords + 1)];
        if (charactersPerFrame.value > [text length] + [nextWord length]) {
            [text appendString:[NSString stringWithFormat:@" %@", nextWord]];
            extrawords++;
        } else {
            break;
        }
    }

    currentFramwWordCount = 1 + extrawords;
    if (label.font.pointSize != textSize.value) {
        label.font = [label.font fontWithSize:textSize.value];
    }
    [label setText:text];

    [doneLabel setText:[NSString stringWithFormat:@"%.f%%", (textProgress.value * 100.0 / [words count])]];
    [speedLabel setText:[NSString stringWithFormat:@"%.fwpm", speedSlider.value]];
}

- (void)alarmFired
{
    //  [textProgress setValue:(1.0 * iteration / [words count]) animated:YES];
    // iteration++;
    textProgress.value += currentFramwWordCount;
    if (textProgress.value >= [words count]) {
        return;
    }

    [self refreshWord];

    float delay = 60.0 * wordsPerFrame / speedSlider.value;

    timer = [NSTimer scheduledTimerWithTimeInterval:delay
                                             target:self selector:@selector(alarmFired)
                                           userInfo:nil
                                            repeats:NO];
}

- (void)showControls {
    // Set the Ending Alpha to 1.0 (Fully Opaque).
    charactersPerFrame.alpha = 1.0;
    textSize.alpha = 1.0;
    pausedLabel.alpha = 1.0;

    CABasicAnimation *fadeInAnimation;
    fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];

    fadeInAnimation.duration = .5;

    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0];

    fadeInAnimation.toValue = [NSNumber numberWithFloat:1];
    [fadeInAnimation setDelegate: self];

    [[charactersPerFrame layer] addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    [[textSize layer] addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    [[pausedLabel layer] addAnimation:fadeInAnimation forKey:@"animateOpacity"];
}

- (void)hideControls {
    if (charactersPerFrame.alpha == 0) {
        return;
    }
    // Begin the Animation Block.
    CABasicAnimation *fadeOutAnimation;
    fadeOutAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];

    fadeOutAnimation.duration = .5;

    fadeOutAnimation.fromValue = [NSNumber numberWithFloat:1.0];

    fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.0];
    [fadeOutAnimation setDelegate: self];


    [[charactersPerFrame layer] addAnimation:fadeOutAnimation forKey:@"animateOpacity"];
    [[textSize layer] addAnimation:fadeOutAnimation forKey:@"animateOpacity"];
    [[pausedLabel layer] addAnimation:fadeOutAnimation forKey:@"animateOpacity"];

    charactersPerFrame.alpha = 0.0;
    textSize.alpha = 0.0;
    pausedLabel.alpha = 0.0;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    NSLog(@"too many timers!");
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [label release];
    [super dealloc];
}


@end
