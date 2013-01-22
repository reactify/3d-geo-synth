/**
 *  CubeMusicAppDelegate.h
 *  CubeMusic
 *
 *  Created by Yuli Levtov on 21/01/2013.
 *  Copyright __MyCompanyName__ 2013. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "CC3UIViewController.h"

#import "PdAudioController.h"
#import "PdBase.h"

@class PdFile;

@interface CubeMusicAppDelegate : NSObject <UIApplicationDelegate, PdReceiverDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) PdAudioController *pdAudioController;
@property (nonatomic, strong) AVAudioPlayer *avPlayer;

@property (strong, nonatomic) PdFile *patch;

- (void)openAndRunPdPatch;
- (void)closePdPatch;

@end
