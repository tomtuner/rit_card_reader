//
//  ViewController.h
//  Scan_It
//
//  Created by Thomas DeMeo on 1/17/13.
//  Copyright (c) 2013 Thomas DeMeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "RedLaserSDK.h"

#import "OverlayController.h"
//#import "RLScanOptionsController.h"

@interface ViewController : UIViewController <BarcodePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate> {

    NSMutableArray				*scanHistory;
    
//    RLScanOptionsController 	*optionsController;
	BarcodePickerController		*pickerController;
}

@property(nonatomic, strong) IBOutlet UITableView *scanHistoryTable;

-(IBAction)scanButtonPressed;
-(IBAction)emailButtonPressed;


@end
