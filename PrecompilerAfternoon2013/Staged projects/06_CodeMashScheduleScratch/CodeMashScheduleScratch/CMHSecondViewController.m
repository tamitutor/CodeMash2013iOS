//
//  CMHSecondViewController.m
//  CodeMashScheduleScratch
//
//  Created by Chris Adamson on 1/8/13.
//  Copyright (c) 2013 CodeMash '13. All rights reserved.
//

#import "CMHSecondViewController.h"
#import "CMHSchedule.h"
#import "CMHSessionCell.h"
#import "CMHSchedulePDFExporter.h"

@interface CMHSecondViewController ()
@property (strong) NSDateFormatter *sectionHeaderDateFormatter;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(IBAction) handleUndoTapped: (id) sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (strong) UIDocumentInteractionController *interactionController; // has to stay around for ARC reasons
@end

@implementation CMHSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	if (! self.sectionHeaderDateFormatter) {
		self.sectionHeaderDateFormatter = [[NSDateFormatter alloc] init];
		[self.sectionHeaderDateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[self.sectionHeaderDateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	}
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleScheduleChanged:)
												 name:SCHEDULE_CHANGED_NOTIFICATION_NAME
											   object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table stuff
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	NSArray *sessionDicts = [CMHSchedule sharedInstance].mutableSessionDicts;
	return [sessionDicts count];
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSArray *sessionDicts = [CMHSchedule sharedInstance].mutableSessionDicts;
	NSDictionary *sessionsDict = [sessionDicts objectAtIndex:section];
	return [self.sectionHeaderDateFormatter stringFromDate:[sessionsDict valueForKey:@"start"]];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *sessionDicts = [CMHSchedule sharedInstance].mutableSessionDicts;
	NSDictionary *sessionsDict = [sessionDicts objectAtIndex:section];
	NSArray *sessions = [sessionsDict valueForKey:@"sessions"];
	return [sessions count];
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSLog (@"let's delete");
		NSArray *sessionDicts = [CMHSchedule sharedInstance].mutableSessionDicts;
		NSDictionary *sessionsDict = [sessionDicts objectAtIndex:indexPath.section];
		NSArray *sessions = [sessionsDict valueForKey:@"sessions"];
		CMHSession *session = [sessions objectAtIndex:indexPath.row];
		[[CMHSchedule sharedInstance] removeSession:session];
	}
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *sessionDicts = [CMHSchedule sharedInstance].mutableSessionDicts;
	NSDictionary *sessionsDict = [sessionDicts objectAtIndex:indexPath.section];
	NSArray *sessions = [sessionsDict valueForKey:@"sessions"];
	CMHSession *session = [sessions objectAtIndex:indexPath.row];
	CMHSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleSessionCell"];
	cell.titleLabel.text = session.title;
	cell.speakerLabel.text = session.speakerName;
	return cell;
}



-(void) handleScheduleChanged: (NSNotification*) notification {
	[self.tableView reloadData];
}

#pragma mark undo
-(IBAction) handleUndoTapped: (id) sender {
	NSLog (@"handleUndoTapped:");
	if (! [[CMHSchedule sharedInstance].undoManager canUndo]) {
		UIAlertView *cantUndoAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString (@"Can't undo", nil)
																message:NSLocalizedString(@"Nothing to undo", nil)
															   delegate:nil
													  cancelButtonTitle:NSLocalizedString(@"OK", nil)
													  otherButtonTitles: nil];
		[cantUndoAlert show];
	} else {
		[[CMHSchedule sharedInstance].undoManager undo];
		NSLog (@"undid!");
	}
}

-(IBAction) handleActionTapped: (id) sender {
	CMHSchedulePDFExporter *exporter = [[CMHSchedulePDFExporter alloc] init];
	NSURL *exportedURL = [exporter pathForExportedSchedule];
	NSLog (@"exported path to %@", exportedURL);
	self.interactionController =
	[UIDocumentInteractionController interactionControllerWithURL:exportedURL];
	// print, mail, copy icons on iOS 6
	[self.interactionController presentOptionsMenuFromBarButtonItem:self.actionButton
														   animated:YES];
	// none of the simulator apps can open a pdf, but this is cool on a real device
//	[self.interactionController presentOpenInMenuFromBarButtonItem:self.actionButton
//													 animated:YES];
				
}

@end
