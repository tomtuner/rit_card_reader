//
//  ViewController.m
//  Sweep
//
//  Created by Thomas DeMeo on 1/30/13.
//  Copyright (c) 2013 Thomas DeMeo. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()



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
        
        // Set up swipe from bottom geasture
        UISwipeGestureRecognizer *swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleLeftSwipe:)];
        swipeUpRecognizer.numberOfTouchesRequired = 2;
        swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeUpRecognizer];

        
//        pickerController = [[BarcodePickerController alloc] init];
//        [pickerController setDelegate:self];
        
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
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)scanPressed:(id)sender {
	
    BarcodeCaptureViewController *vc = [[BarcodeCaptureViewController alloc] initWithNibName:nil bundle:nil];
    [self presentModalViewController:vc animated:YES];
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

- (void)handleDoubleLeftSwipe:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Double left Swipe!");
    [self clearScannedCodes];
    
    // Save our new scans out to the archive file
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
    NSString *archivePath = [documentsDir stringByAppendingPathComponent:@"ScanHistoryArchive"];
    [NSKeyedArchiver archiveRootObject:scanHistory toFile:archivePath];
}

- (void) clearScannedCodes {
    [scanHistory removeAllObjects];
	[self.scanHistoryTable reloadData];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
	ZXResult *barcode = [scanHistory objectAtIndex:indexPath.row];
    
    cell.textLabel.text = barcode.text;
	
    return cell;
}

@end
