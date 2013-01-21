//
//  CMHSchedule.h
//  CodeMashScheduleScratch
//
//  Created by Chris Adamson on 1/8/13.
//  Copyright (c) 2013 CodeMash '13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMHSession.h"

#define SCHEDULE_CHANGED_NOTIFICATION_NAME @"schedule-changed"

@interface CMHSchedule : UIDocument

+(CMHSchedule*) sharedInstance;
-(void) addSession: (CMHSession*) session;
-(void) removeSession: (CMHSession*) session;
@property (strong) NSMutableArray *mutableSessionDicts;
@end
