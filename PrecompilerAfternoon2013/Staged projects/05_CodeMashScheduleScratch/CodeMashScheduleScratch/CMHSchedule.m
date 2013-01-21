//
//  CMHSchedule.m
//  CodeMashScheduleScratch
//
//  Created by Chris Adamson on 1/8/13.
//  Copyright (c) 2013 CodeMash '13. All rights reserved.
//

#import "CMHSchedule.h"

CMHSchedule *global_cmhSchedule;



@implementation CMHSchedule

#pragma mark init/dealloc
-(id) initWithFileURL:(NSURL *)url {
	self = [super initWithFileURL:url];
	if (self) {
		self.mutableSessionDicts = [[NSMutableArray alloc] init];
	}
	return self;
}

#pragma mark singleton
+(CMHSchedule*) sharedInstance {
	if (!global_cmhSchedule) {
		NSArray *directories = [[NSFileManager defaultManager]
								URLsForDirectory:NSDocumentDirectory
								inDomains:NSUserDomainMask];
		NSURL *documentDirectory = [directories objectAtIndex:0];
		NSURL *documentURL = [documentDirectory URLByAppendingPathComponent:@"mydocument.cmhschedule"];
		global_cmhSchedule = [[CMHSchedule alloc] initWithFileURL:documentURL];
	}
	return global_cmhSchedule;
}

#pragma defined methods
-(void) addSession: (CMHSession*) session {
	BOOL addedSession = NO;
	for (NSDictionary *sessionsDict in [self.mutableSessionDicts copy]) {
		NSDate *currentDate = [sessionsDict valueForKey:@"start"];
		if ([currentDate compare:session.start] == NSOrderedSame) {
			// add to this array
			NSMutableArray *sessions = [sessionsDict valueForKey:@"sessions"];
			[sessions addObject:session];
			addedSession = YES;
			break;
		} else if ([currentDate compare:session.start] == NSOrderedDescending) {
			// went too far, create a new one here
			NSMutableArray *sessions = [[NSMutableArray alloc] initWithObjects:session, nil];
			NSDictionary *newSessionsDict = @ {@"start" : session.start, @"sessions" : sessions};
			[self.mutableSessionDicts addObject:newSessionsDict]; // concurrent modification danger?
			addedSession = YES;
			break;
		}
	}
	if (!addedSession) {
		// if we never added, append to end
		NSMutableArray *sessions = [[NSMutableArray alloc] initWithObjects:session, nil];
		NSDictionary *newSessionsDict = @ {@"start" : session.start, @"sessions" : sessions};
		[self.mutableSessionDicts addObject:newSessionsDict];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:SCHEDULE_CHANGED_NOTIFICATION_NAME
														object:self];
	[self.undoManager registerUndoWithTarget:self
									selector:@selector(removeSession:)
									  object:session];
}

-(void) removeSession: (CMHSession*) session {
	for (NSDictionary *sessionsDict in [self.mutableSessionDicts copy]) {
		NSMutableArray *sessions = [sessionsDict valueForKey:@"sessions"];
		[sessions removeObject:session];
		// trash the dict if it's empty (otherwise we get extra sections in sked view)
		if ([sessions count] == 0) {
			[self.mutableSessionDicts removeObject:sessionsDict];
		}
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:SCHEDULE_CHANGED_NOTIFICATION_NAME
														object:self];
	[self.undoManager registerUndoWithTarget:self
									selector:@selector(addSession:)
									  object:session];
}


#pragma mark uidocument persistence
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError {
	NSLog (@"contentsForType: %@", typeName);
    return [NSKeyedArchiver archivedDataWithRootObject:self.mutableSessionDicts];
}

- (BOOL)loadFromContents:(id)contents
                  ofType:(NSString *)typeName
                   error:(NSError *__autoreleasing *)outError {
	NSLog (@"loadFromContents:ofType:error:. type = %@", typeName);
    BOOL success = NO;
    if([contents isKindOfClass:[NSData class]] && [contents length] > 0) {
        NSData *data = (NSData *)contents;
        self.mutableSessionDicts = [NSMutableArray arrayWithArray:
                         [NSKeyedUnarchiver unarchiveObjectWithData:data]];
        success = YES;
    }
    return success;
}


#pragma mark our load method
-(void) load {
	[self openWithCompletionHandler:^(BOOL success) {
		if (success) {
			[[NSNotificationCenter defaultCenter] postNotificationName:SCHEDULE_CHANGED_NOTIFICATION_NAME
																object:self];
		}
	}];
}

@end
