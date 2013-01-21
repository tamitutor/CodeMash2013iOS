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
/*
 @property (copy) NSString *speakerName;
 @property (copy) NSString *title;
 @property (copy) NSString *abstract;
 @property (copy) NSString *room;
 @property (strong) NSDate *start;
 @property (copy) NSString *technology;
 @property (copy) NSURL *url;
*/

#pragma mark encode/decode
-(void) encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.speakerName forKey:@"speakerName"];
	[aCoder encodeObject:self.title forKey:@"title"];
	[aCoder encodeObject:self.abstract forKey:@"abstract"];
	[aCoder encodeObject:self.room forKey:@"room"];
	[aCoder encodeObject:self.start forKey:@"start"];
	[aCoder encodeObject:self.technology forKey:@"technology"];
	[aCoder encodeObject:self.url forKey:@"url"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		self.speakerName = [aDecoder decodeObjectForKey:@"speakerName"];
		self.title = [aDecoder decodeObjectForKey:@"title"];
		self.abstract = [aDecoder decodeObjectForKey:@"abstract"];
		self.room = [aDecoder decodeObjectForKey:@"room"];
		self.start = [aDecoder decodeObjectForKey:@"start"];
		self.technology = [aDecoder decodeObjectForKey:@"technology"];
		self.url = [aDecoder decodeObjectForKey:@"url"];
	}
	return self;
}

@end
