/**
 *  CubeMusicAppDelegate.m
 *  CubeMusic
 *
 *  Created by Yuli Levtov on 21/01/2013.
 *  Copyright __MyCompanyName__ 2013. All rights reserved.
 */

#import "CubeMusicAppDelegate.h"
#import "CubeMusicLayer.h"
#import "CubeMusicScene.h"
#import "CC3CC2Extensions.h"

#import "PdFile.h"

#define kAnimationFrameRate		60		// Animation frame rate

@implementation CubeMusicAppDelegate {
	UIWindow* _window;
	CC3DeviceCameraOverlayUIViewController* _viewController;
}

-(void) dealloc {
	[_window release];
	[_viewController release];
	[super dealloc];
}

#if CC3_CC2_1
/**
 * In cocos2d 1.x, the view controller and CCDirector are different objects.
 *
 * NOTE: As of iOS6, supported device orientations are an intersection of the mask established for the
 * UIViewController (as set in this method here), and the values specified in the project 'Info.plist'
 * file, under the 'Supported interface orientations' and 'Supported interface orientations (iPad)'
 * keys. Specifically, although the mask here is set to UIInterfaceOrientationMaskAll, to ensure that
 * all orienatations are enabled under iOS6, be sure that those settings in the 'Info.plist' file also
 * reflect all four orientation values. By default, the 'Info.plist' settings only enable the two
 * landscape orientations. These settings can also be set on the Summary page of your project.
 */
-(void) establishDirectorController {
	
	// Establish the type of CCDirector to use.
	// Try to use CADisplayLink director and if it fails (SDK < 3.1) use the default director.
	// This must be the first thing we do and must be done before establishing view controller.
	if( ! [CCDirector setDirectorType: kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType: kCCDirectorTypeDefault];
	
	// Create the view controller for the 3D view.
	_viewController = [CC3DeviceCameraOverlayUIViewController new];
	_viewController.supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
	
	// Create the CCDirector, set the frame rate, and attach the view.
	CCDirector *director = CCDirector.sharedDirector;
	director.runLoopCommon = YES;		// Improves display link integration with UIKit
	director.animationInterval = (1.0f / kAnimationFrameRate);
	director.displayFPS = YES;
	director.openGLView = _viewController.view;
	
	// Enables High Res mode on Retina Displays and maintains low res on all other devices
	// This must be done after the GL view is assigned to the director!
	[director enableRetinaDisplay: YES];
}
#endif

#if CC3_CC2_2
/**
 * In cocos2d 2.x, the view controller and CCDirector are one and the same, and we create the
 * controller using the singleton mechanism. To establish the correct CCDirector/UIViewController
 * class, this MUST be performed before any other references to the CCDirector singleton!!
 *
 * NOTE: As of iOS6, supported device orientations are an intersection of the mask established for the
 * UIViewController (as set in this method here), and the values specified in the project 'Info.plist'
 * file, under the 'Supported interface orientations' and 'Supported interface orientations (iPad)'
 * keys. Specifically, although the mask here is set to UIInterfaceOrientationMaskAll, to ensure that
 * all orienatations are enabled under iOS6, be sure that those settings in the 'Info.plist' file also
 * reflect all four orientation values. By default, the 'Info.plist' settings only enable the two
 * landscape orientations. These settings can also be set on the Summary page of your project.
 */
-(void) establishDirectorController {
	_viewController = CC3DeviceCameraOverlayUIViewController.sharedDirector;
	_viewController.supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
	_viewController.animationInterval = (1.0f / kAnimationFrameRate);
	_viewController.displayStats = YES;
	[_viewController enableRetinaDisplay: YES];
}
#endif

-(void) applicationDidFinishLaunching: (UIApplication*) application {
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images.
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565. You can change anytime.
	CCTexture2D.defaultAlphaPixelFormat = kCCTexture2DPixelFormat_RGBA8888;
	
	// Establish the view controller and CCDirector (in cocos2d 2.x, these are one and the same)
	[self establishDirectorController];
	
	// Create the window, make the controller (and its view) the root of the window, and present the window
	_window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
	[_window addSubview: _viewController.view];
	_window.rootViewController = _viewController;
	[_window makeKeyAndVisible];
	
	// Set to YES for Augmented Reality 3D overlay on device camera.
	// This must be done after the window is made visible!
//	_viewController.isOverlayingDeviceCamera = YES;

	
	// ******** START OF COCOS3D SETUP CODE... ********
	
	// Create the customized CC3Layer that supports 3D rendering.
	CC3Layer* cc3Layer = [CubeMusicLayer node];
	
	// Create the customized 3D scene and attach it to the layer.
	// Could also just create this inside the customer layer.
	cc3Layer.cc3Scene = [CubeMusicScene scene];
	
	// Assign to a generic variable so we can uncomment options below to play with the capabilities
	CC3ControllableLayer* mainLayer = cc3Layer;
	

    
    
    [_viewController runSceneOnNode: mainLayer];
    
    
    
    // Init Pure Data
    //[self initPd];
}


-(void)initPd {
    
    self.pdAudioController = [[PdAudioController alloc] init];
    [self.pdAudioController configureAmbientWithSampleRate:44100
                                            numberChannels:2
                                             mixingEnabled:YES];
    [PdBase setDelegate:self];
    
    [PdBase clearSearchPath];
    
    [PdBase setDelegate:self];
    
    [self.pdAudioController setActive:YES];
    
    NSString *patchPath = [[NSBundle mainBundle] pathForResource:@"_main" ofType:@"pd"];
    
    self.patch = [PdFile openFileNamed:[patchPath lastPathComponent]
                                  path:[patchPath stringByDeletingLastPathComponent]];
    
    if (self.patch) NSLog(@"openAndRunPdPatch has run");
    
    [PdBase sendFloat:1.0 toReceiver:@"#OUTPUT-VOL"];
    
    [PdBase sendFloat:1.0 toReceiver:@"#MIX-BEAT"];
    
    [PdBase sendFloat:1.0 toReceiver:@"#MIX-BELLS"];
    
    [PdBase sendFloat:1.0 toReceiver:@"#MIX-BLEEPS"];
    
    [PdBase sendFloat:1.0 toReceiver:@"#MIX-SYNTH"];
    
}


-(void)initializeControls{
    [[CCDirector sharedDirector] setDepthTest:NO];
    //[self addButtons];
    
}



/** Pause the cocos3d/cocos2d action. */
-(void) applicationWillResignActive: (UIApplication*) application {
	[CCDirector.sharedDirector pause];
}

/** Resume the cocos3d/cocos2d action. */
-(void) resumeApp { [CCDirector.sharedDirector resume]; }

-(void) applicationDidBecomeActive: (UIApplication*) application {
	
	// Workaround to fix the issue of drop to 40fps on iOS4.X on app resume.
	// Adds short delay before resuming the app.
	[NSTimer scheduledTimerWithTimeInterval: 0.5f
									 target: self
								   selector: @selector(resumeApp)
								   userInfo: nil
									repeats: NO];
	
	// If dropping to 40fps is not an issue, remove above, and uncomment the following to avoid delay.
//	[self resumeApp];
}

-(void) applicationDidReceiveMemoryWarning: (UIApplication*) application {
	[CCDirector.sharedDirector purgeCachedData];
}

-(void) applicationDidEnterBackground: (UIApplication*) application {
	[CCDirector.sharedDirector stopAnimation];
}

-(void) applicationWillEnterForeground: (UIApplication*) application {
	[CCDirector.sharedDirector startAnimation];
}

-(void)applicationWillTerminate: (UIApplication*) application {
	[CCDirector.sharedDirector.view removeFromSuperview];
	[CCDirector.sharedDirector end];
}

-(void) applicationSignificantTimeChange: (UIApplication*) application {
	[CCDirector.sharedDirector setNextDeltaTimeZero: YES];
}


#pragma mark - PD messages

- (void)receiveSymbol:(NSString *)symbol fromSource:(NSString *)source {
    
    NSLog(@"Received new symbol: %@", symbol);
}

- (void)receivePrint:(NSString *)string {
    NSLog(@"PD Print: %@", string);
}

- (void)sendFloatToPd:(NSString *)receiver:(float)value {
    
    [PdBase sendFloat:value toReceiver:receiver];
}

- (void)sendBangToPd:(NSString *)receiver {
    
    [PdBase sendBangToReceiver:receiver];
}

- (void)sendSymbolToPd:(NSString *)symbol toReceiver:(NSString *)receiver {
    
    [PdBase sendSymbol:symbol toReceiver:receiver];
}


@end
