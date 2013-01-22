//
//  ViewController.m
//  Scan_It
//
//  Created by Thomas DeMeo on 1/17/13.
//  Copyright (c) 2013 Thomas DeMeo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (void) appBecameActive:(NSNotification *) notification;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    if (self = [super initWithNibName:nibBundleOrNil bundle:nibBundleOrNil])
	{
		// Load in any saved scan history we may have
		@try {
    		NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                          NSUserDomainMask, YES) objectAtIndex:0];
			NSString *archivePath = [documentsDir stringByAppendingPathComponent:@"ScanHistoryArchive"];
			scanHistory = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
		}
		@catch (...)
		{
    	}
        
        // We create the BarcodePickerController here so that we can call prepareToScan before
        // the user actually requests a scan.
        pickerController = [[BarcodePickerController alloc] init];
        [pickerController setDelegate:self];
        
		if (!scanHistory) {
			scanHistory = [[NSMutableArray alloc] init];
        }
        
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecameActive:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[pickerController prepareToScan];
}

- (void) barcodePickerController:(BarcodePickerController*)picker returnResults:(NSSet *)results
{
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
	// Restore main screen (and restore title bar for 3.0)
    [self dismissViewControllerAnimated:YES completion:^(void) {
        if (results && [results count])
        {
            NSMutableDictionary *scanSession = [[NSMutableDictionary alloc] init];
            [scanSession setObject:[NSDate date] forKey:@"Session End Time"];
            [scanSession setObject:[results allObjects] forKey:@"Scanned Items"];
            NSLog(@"Keys: %@ Values: %@", [scanSession allKeys], [scanSession allValues]);
            
            for( NSObject *bar in [results allObjects] ) {
                [scanHistory insertObject:bar atIndex:0];
            }

//            [scanHistory insertObject:scanSession atIndex:0];
            
            // Save our new scans out to the archive file
            NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                          NSUserDomainMask, YES) objectAtIndex:0];
            NSString *archivePath = [documentsDir stringByAppendingPathComponent:@"ScanHistoryArchive"];
            [NSKeyedArchiver archiveRootObject:scanHistory toFile:archivePath];
            
            [scanHistoryTable reloadData];
        }
    }];
}

// When the app launches or is foregrounded, this will get called via NSNotification
// to warm up the camera.
- (void) appBecameActive:(NSNotification *) notification
{
	[pickerController prepareToScan];
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

-(IBAction)emailButtonPressed {
    NSString *csvFullString = [scanHistory componentsJoinedByString:@","];
    NSLog(@"csvFullString:%@",csvFullString);
    NSMutableString *csvString = [NSMutableString string];
    
    for (int i = 0; i < [scanHistory count]; i++) {
        [csvString appendString:[[scanHistory objectAtIndex:i] barcodeString]];
        if ([scanHistory count] > i+1) {
            [csvString appendString:@", "];
        }
    }
    NSLog(@"csvString:%@",csvString);

    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    [mailer setSubject:@"CSV File"];
    [mailer addAttachmentData:[csvString dataUsingEncoding:NSUTF8StringEncoding]
                     mimeType:@"text/csv"
                     fileName:@"Event Attendies.csv"];
    [self presentViewController:mailer animated:YES completion:nil];    
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissModalViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Scan Count: %i", [scanHistory count]);
	return [scanHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BarcodeResult"];
    if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:@"BarcodeResult"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	// Get the barcodeResult that has the data backing this cell
	NSMutableDictionary *scanSession = [scanHistory objectAtIndex:indexPath.section];
	BarcodeResult *barcode = [scanHistory objectAtIndex:indexPath.row];
    
    cell.textLabel.text = barcode.barcodeString;
	
    return cell;
}


@end
