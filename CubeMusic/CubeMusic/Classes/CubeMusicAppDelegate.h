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

@interface CubeMusicAppDelegate : NSObject <UIApplicationDelegate, PdReceiverDelegate>

@property (strong, nonatomic) PdAudioController *pdAudioController;
@property (strong, nonatomic) PdFile *patch;

- (void)openAndRunPdPatch;
- (void)closePdPatch;

- (void)receiveSymbol:(NSString *)symbol fromSource:(NSString *)source;
- (void)receivePrint:(NSString *)string;
- (void)sendFloatToPd:(NSString *)receiver:(float)value;
- (void)sendBangToPd:(NSString *)receiver;
- (void)sendSymbolToPd:(NSString *)symbol toReceiver:(NSString *)receiver;

@end
