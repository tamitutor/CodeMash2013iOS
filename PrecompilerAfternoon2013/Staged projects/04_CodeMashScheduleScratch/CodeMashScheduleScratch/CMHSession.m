//
//  CMHSession.m
//  CodeMashSessions
//
//  Created by Chris Adamson on 1/5/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import "CMHSession.h"

NSDateFormatter *_dateFormatterSingleton;

@interface CMHSession()
+(NSDateFormatter*) dateFormatterSingleton;
@end

@implementation CMHSession

-(id) initWithJSONDictionary: (NSDictionary*) dict {
    self = [super init];
    if (self) {
		self.speakerName = [dict valueForKey:@"SpeakerName"];
    	self.title = [dict valueForKey:@"Title"];
		self.technology = [dict valueForKey:@"Technology"];
		self.room = [dict valueForKey:@"Room"];
		self.start = [[CMHSession dateFormatterSingleton] dateFromString: [dict valueForKey:@"Start"]];
		self.abstract = [dict valueForKey:@"Abstract"];
	}
    return self;
}

+(NSDateFormatter*) dateFormatterSingleton {
	if (! _dateFormatterSingleton) {
		_dateFormatterSingleton = [[NSDateFormatter alloc] init];
		[_dateFormatterSingleton setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];

	}
	return _dateFormatterSingleton;
}

-(NSString*) description {
	return [NSString stringWithFormat:@"%@: \"%@\" by %@",
			self.start, self.title, self.speakerName];
}

@end
