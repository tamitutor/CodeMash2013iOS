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
#import "CMHSchedule.h"

#define SESSIONS_URL_JSON @"http://rest.codemash.org/api/sessions.json"

#define USE_LOCAL_SESSIONS_URL

@interface CMHFirstViewController ()
// each member is a dict keyed by "start" (date) and "sessions" (array)
@property (strong) NSArray *sessionDicts;
@property (weak, nonatomic) IBOutlet UIView *hudView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong) NSDateFormatter *sectionHeaderDateFormatter;
@property (strong) CMHSession *selectedSessionForMenu;
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
#ifdef USE_LOCAL_SESSIONS_URL
			NSURL *localJSONURL = [[NSBundle mainBundle] URLForResource:@"codemash-13-sessions"
														  withExtension:@"json"];
			NSData *jsonData = [NSData dataWithContentsOfURL:localJSONURL];
#else
			NSData *jsonData = [NSData dataWithContentsOfURL:
								[NSURL URLWithString:SESSIONS_URL_JSON]];
#endif
			NSError *jsonErr = nil;
			id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
															options:0
															  error:&jsonErr];
			if (jsonErr) {
				NSLog (@"Error parsing JSON: %@", jsonErr);
			}
			
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath	{
	NSDictionary *sessionsDict = [self.sessionDicts objectAtIndex:indexPath.section];
	NSArray *sessions = [sessionsDict valueForKey:@"sessions"];
	CMHSession *session = [sessions objectAtIndex:indexPath.row];
	[[CMHSchedule sharedInstance] addSession:session];
	NSLog (@"schedule now: %@", [CMHSchedule sharedInstance].mutableSessionDicts);
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark gesture recognizers
-(IBAction) handleLongPress: (UIGestureRecognizer*) recognizer {
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		CGPoint tapPoint = [recognizer locationInView:self.tableView];
		NSIndexPath *tappedPath = [self.tableView indexPathForRowAtPoint:
								   tapPoint];
		NSLog (@"tapped on path %@", tappedPath);
		if (!tappedPath) {
			return;
		} else {
			// remember what was tapped on
			NSDictionary *sessionsDict = [self.sessionDicts objectAtIndex:tappedPath.section];
			NSArray *sessions = [sessionsDict valueForKey:@"sessions"];
			self.selectedSessionForMenu	= [sessions objectAtIndex:tappedPath.row];

			// show the menu
			[self.tableView becomeFirstResponder];
			[[UIMenuController sharedMenuController]
			 setTargetRect: CGRectMake(tapPoint.x, tapPoint.y, 1.0, 1.0)
			 inView:self.tableView];
			[[UIMenuController sharedMenuController] setMenuVisible:YES
														   animated:YES];
		}
	}
}

#pragma mark menu stuff
-(BOOL) canBecomeFirstResponder {
	return YES;
}

-(BOOL) canPerformAction:(SEL)action withSender:(id)sender {
	if (action == @selector(copy:)) {
		return YES;
	} else {
		return [super canPerformAction:action withSender:sender];
	}
}

-(void) copy: (id) sender {
	NSLog (@"copy: %@", self.selectedSessionForMenu);
	if (self.selectedSessionForMenu) {
		NSDictionary *pasteboardItem = @ {
			@"public.text" : [self.selectedSessionForMenu description]
		};
		[UIPasteboard generalPasteboard].items = @[pasteboardItem];
	}
}

@end
