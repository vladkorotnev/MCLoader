//
//  NSArray+TableHAck.m
//  mcloader
//
//  Created by Vladislav Korotnev on 1/7/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "NSArray+TableHAck.h"

//
// Makes an NSArray work as an NSTableDataSource.
@implementation NSArray (TableHAck)

// just returns the item for the right row
- (id)     tableView:(NSTableView *) aTableView
objectValueForTableColumn:(NSTableColumn *) aTableColumn
                 row:(int) rowIndex
{
    return [self objectAtIndex:rowIndex];
}

// just returns the number of items we have.
- (NSUInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [self count];
}
@end