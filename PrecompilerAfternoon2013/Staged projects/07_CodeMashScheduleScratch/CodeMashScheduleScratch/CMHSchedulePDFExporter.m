//
//  CMHSchedulePDFExporter.m
//  CodeMashScheduleScratch
//
//  Created by Chris Adamson on 1/8/13.
//  Copyright (c) 2013 CodeMash '13. All rights reserved.
//

#import "CMHSchedulePDFExporter.h"
#import "CMHSchedule.h"
#import "CMHSession.h"

@implementation CMHSchedulePDFExporter

-(NSURL*) pathForExportedSchedule {
	NSArray *directories = [[NSFileManager defaultManager]
							URLsForDirectory:NSDocumentDirectory
							inDomains:NSUserDomainMask];
	NSURL *documentDirectory = [directories objectAtIndex:0];
	NSURL *pdfURL = [documentDirectory URLByAppendingPathComponent:@"codemash-schedule.pdf"];
	
	// draw to CGPDF context at this path
	CGRect pdfBox = CGRectMake (0.0, 0.0, 612.0, 792.0);
	CGContextRef context = CGPDFContextCreateWithURL((__bridge CFURLRef)(pdfURL),
													 &pdfBox,
													 NULL);
	CGContextBeginPage(context, &pdfBox);

    CGContextSelectFont(context,
                        "Helvetica Bold",
                        20.0,
                        kCGEncodingMacRoman);
    CGContextSetFillColorWithColor(context,
                                   [UIColor blackColor].CGColor);

	NSString *lineText = @"CodeMash Schedule";
	CGContextShowTextAtPoint(context,
                             200.0,
                             750.0,
							 [lineText UTF8String],
                             [lineText length]);

	CGFloat drawY = 700.0;
	
	NSArray *scheduledSessions = [CMHSchedule sharedInstance].mutableSessionDicts;
	for (NSDictionary *sessionsDict in scheduledSessions) {
		drawY -= 25.0;
		CGContextSelectFont(context,
							"Helvetica Bold",
							14.0,
							kCGEncodingMacRoman);
		lineText = [NSString stringWithFormat:@"%@", [sessionsDict valueForKey:@"start"]];
		CGContextShowTextAtPoint(context,
								 20.0,
								 drawY,
								 [lineText UTF8String],
								 [lineText length]);
		
		CGContextSelectFont(context,
							"Helvetica",
							12.0,
							kCGEncodingMacRoman);
		NSArray *sessions = [sessionsDict valueForKey:@"sessions"];
		for (CMHSession *session in sessions) {
			drawY -= 15.0;
			lineText = [NSString stringWithFormat:@"%@: %@",
						session.speakerName, session.title];
			CGContextShowTextAtPoint(context,
									 20.0,
									 drawY,
									 [lineText UTF8String],
									 [lineText length]);
		}

		
	}
	
	
	CGContextEndPage(context);
    CGContextFlush(context);
    CGContextRelease(context);
	
	// return the file url
	return pdfURL;
}

@end
