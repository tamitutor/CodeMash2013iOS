//
//  Employee.m
//  NSPredicatesTalkCoreData
//
//  Created by Josh Smith on 1/8/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import "Employee.h"
#import "Manager.h"


@implementation Employee

@dynamic name;
@dynamic salary;
@dynamic manager;

- (BOOL) validateName:(id *) ioValue error:(NSError **) error {
    NSPredicate *okname = [NSPredicate predicateWithFormat:@"self matches %@",@"[A-Z]+[a-z ']+"];
    return [okname evaluateWithObject:*ioValue];
}

@end
