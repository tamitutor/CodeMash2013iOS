//
//  CMHFirstViewController.m
//  CodeMashScheduleScratch
//
//  Created by Chris Adamson on 1/8/13.
//  Copyright (c) 2013 CodeMash '13. All rights reserved.
//

#import "CMHFirstViewController.h"
#import "CMHSession.h"
#import "CMHSessionCell.h"

#define SESSIONS_URL_JSON @"http://rest.codemash.org/api/sessions.json"

@interface CMHFirstViewController ()
// each member is a dict keyed by "start" (date) and "sessions" (array)
@property (strong) NSArray *sessionDicts;
@property (weak, nonatomic) IBOutlet UIView *hudView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong) NSDateFormatter *sectionHeaderDateFormatter;
@end


@implementation CMHFirstViewController

@synthesize sessionDicts = _sessionDicts;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	if (! self.sectionHeaderDateFormatter) {
		self.sectionHeaderDateFormatter = [[NSDateFormatter alloc] init];
		[self.sectionHeaderDateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[self.sectionHeaderDateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	}
	
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark property override
-(NSArray*) sessionDicts {
	// lazy load
	if (!_sessionDicts) {
		dispatch_async(dispatch_get_global_queue
					   (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
		{
			NSData *jsonData = [NSData dataWithContentsOfURL:
								[NSURL URLWithString:SESSIONS_URL_JSON]];
			NSError *jsonErr = nil;
			id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
															options:0
															  error:&jsonErr];
			if (jsonErr) {
				NSLog (@"Error parsing JSON: %@", jsonErr);
			}
			NSLog (@"got back %@", [[jsonObject class] description]);
			
			NSMutableArray *mutableSessions = [[NSMutableArray alloc] init];
			for (NSDictionary *sessionDict in jsonObject) {
				CMHSession *session = [[CMHSession alloc] initWithJSONDictionary:sessionDict];
				[mutableSessions addObject:session];
			}
			
			// build our object model
			NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"start" ascending:YES];
			[mutableSessions sortUsingDescriptors:@[dateSort]];
			
			NSMutableArray *mutableDicts = [[NSMutableArray alloc] init];
			NSDictionary *dictForCurrentTime = nil;
			NSDate *currentTime = nil;
			for (CMHSession *session in mutableSessions) {
				if (!currentTime || [session.start compare:currentTime] != NSOrderedSame) {
					// need a new dict for this time
					currentTime = session.start;
					NSMutableArray *sessions = [[NSMutableArray alloc] init];
					dictForCurrentTime = @{
					@"start" : session.start,
					@"sessions": sessions};
					[mutableDicts addObject:dictForCurrentTime];
				}
				[[dictForCurrentTime valueForKey:@"sessions"] addObject:session];
			}
			
			_sessionDicts = [NSArray arrayWithArray:mutableDicts];
			
			// update the ui
			dispatch_async(dispatch_get_main_queue(), ^{
				self.hudView.hidden = YES;
				[self.tableView reloadData];
				NSLog (@"sessionDicts: %@", _sessionDicts);
			});
		});
		
	}
	return _sessionDicts;
	
}

-(void) setSessionDicts:(NSArray *)sessionDicts {
	if (_sessionDicts != sessionDicts) {
		_sessionDicts = sessionDicts;
	}
}

#pragma mark table stuff
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.sessionDicts count];
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSDictionary *sessionsDict = [self.sessionDicts objectAtIndex:section];
	return [self.sectionHeaderDateFormatter stringFromDate:[sessionsDict valueForKey:@"start"]];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *sessionsDict = [self.sessionDicts objectAtIndex:section];
	NSArray *sessions = [sessionsDict valueForKey:@"sessions"];
	return [sessions count];
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *sessionsDict = [self.sessionDicts objectAtIndex:indexPath.section];
	NSArray *sessions = [sessionsDict valueForKey:@"sessions"];
	CMHSession *session = [sessions objectAtIndex:indexPath.row];
	CMHSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionCell"];
	cell.titleLabel.text = session.title;
	cell.speakerLabel.text = session.speakerName;
	return cell;
}

@end
