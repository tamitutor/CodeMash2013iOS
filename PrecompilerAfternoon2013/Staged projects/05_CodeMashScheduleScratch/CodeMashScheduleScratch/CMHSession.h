//
//  CMHSession.h
//  CodeMashSessions
//
//  Created by Chris Adamson on 1/5/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMHSession : NSObject <NSCoding>

@property (copy) NSString *speakerName;
@property (copy) NSString *title;
@property (copy) NSString *abstract;
@property (copy) NSString *room;
@property (strong) NSDate *start;
@property (copy) NSString *technology;
@property (copy) NSURL *url;

-(id) initWithJSONDictionary: (NSDictionary*) dict;

@end
