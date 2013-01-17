//
//  ViewController.h
//  Scan_It
//
//  Created by Thomas DeMeo on 1/17/13.
//  Copyright (c) 2013 Thomas DeMeo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RedLaserSDK.h"

#import "OverlayController.h"
//#import "RLScanOptionsController.h"

@interface ViewController : UIViewController <BarcodePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource> {

    NSMutableArray				*scanHistory;
	IBOutlet UITableView 		*scanHistoryTable;
    
//    RLScanOptionsController 	*optionsController;
	BarcodePickerController		*pickerController;
}

-(IBAction)scanButtonPressed;


@end
