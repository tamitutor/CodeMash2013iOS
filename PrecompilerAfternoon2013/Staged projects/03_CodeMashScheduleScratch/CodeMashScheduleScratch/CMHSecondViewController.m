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

@interface CMHSecondViewController ()
@property (strong) NSDateFormatter *sectionHeaderDateFormatter;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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

@end
