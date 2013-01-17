//
//  ViewController.m
//  Scan_It
//
//  Created by Thomas DeMeo on 1/17/13.
//  Copyright (c) 2013 Thomas DeMeo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    pickerController = [[BarcodePickerController alloc] init];
    [pickerController setDelegate:self];
	[pickerController prepareToScan];
}

- (void) barcodePickerController:(BarcodePickerController*)picker returnResults:(NSSet *)results
{
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
	// Restore main screen (and restore title bar for 3.0)
    [self dismissViewControllerAnimated:YES completion:^(void) {
        
    }];
    
    if (results && [results count])
	{
		NSMutableDictionary *scanSession = [[NSMutableDictionary alloc] init];
		[scanSession setObject:[NSDate date] forKey:@"Session End Time"];
		[scanSession setObject:[results allObjects] forKey:@"Scanned Items"];
        NSLog(@"Keys: %@ Values: %@", [scanSession allKeys], [scanSession allValues]);
        BarcodeResult *barcode = [[scanSession objectForKey:@"Scanned Items"] objectAtIndex:0];

        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Scanned Data"
                              message: barcode.barcodeString
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction) scanButtonPressed
{
	// Make ourselves an overlay controller and tell the SDK about it.
	OverlayController *overlayController = [[OverlayController alloc] initWithNibName:@"OverlayController" bundle:nil];
	[pickerController setOverlay:overlayController];
	
	// hide the status bar and show the scanner view
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self presentViewController:pickerController animated:YES completion:^(void) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
