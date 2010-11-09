//
//  TextCelerantAppDelegate.m
//  TextCelerant
//
//  Created by Eric Wagner on 6/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "TextCelerantAppDelegate.h"

@implementation TextCelerantAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    textViewController = [[TextViewController alloc] init];
    [window addSubview:[textViewController view]];

    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
