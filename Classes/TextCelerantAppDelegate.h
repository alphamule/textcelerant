//
//  TextCelerantAppDelegate.h
//  TextCelerant
//
//  Created by Eric Wagner on 6/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextViewController.h"


@interface TextCelerantAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TextViewController *textViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

