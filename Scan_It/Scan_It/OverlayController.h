//
//  OverlayController.h
//  Scan_It
//
//  Created by Thomas DeMeo on 1/17/13.
//  Copyright (c) 2013 Thomas DeMeo. All rights reserved.
//

#import "RedLaserSDK.h"
#import "AudioToolbox/AudioServices.h"
#import <QuartzCore/QuartzCore.h>

@interface OverlayController : CameraOverlayViewController {
	
	IBOutlet UILabel 			*textCue;
	IBOutlet UIBarButtonItem 	*cancelButton;
	IBOutlet UIBarButtonItem 	*frontButton;
	IBOutlet UIBarButtonItem 	*flashButton;
	IBOutlet UIImageView 		*redlaserLogo;
	
	BOOL 						viewHasAppeared;
	
	SystemSoundID 				scanSuccessSound;
	
	CAShapeLayer 				*rectLayer;
}

- (IBAction) cancelButtonPressed;
- (IBAction) flashButtonPressed;
- (IBAction) rotateButtonPressed;
- (IBAction) cameraToggleButtonPressed;

- (void) setLayoutOrientation:(UIImageOrientation) newOrientation;

@end
