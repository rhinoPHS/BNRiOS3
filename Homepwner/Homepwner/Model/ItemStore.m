//
//  ItemStore.m
//  Homepwner
//
//  Created by rhino Q on 14/08/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "ItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@implementation ItemStore

+ (instancetype)sharedStore {
    static ItemStore *sharedStore = nil;
    if(!sharedStore)
        sharedStore = [[ItemStore alloc] init];
    return sharedStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemsMoreThan = [[NSMutableArray alloc] init];
        _itemsRest = [[NSMutableArray alloc] init];
//        _allItems = [[NSMutableArray alloc] init];
        
        NSString *path = [self itemArchivePath];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        NSSet *classes = [NSSet setWithArray:@[
                                           [NSMutableArray class],
                                           [BNRItem class],
                                           [NSDate class],
                                           [NSData class]]];
        
        NSError *error;
        _allItems = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:&error];
        
        if(error) {
            NSLog(@"unarchive error : %@", error);
        }
        
        // If the array hadn't been saved previously, create a new empty one
        if(!_allItems) {
            _allItems = [NSMutableArray new];
        }
    }
    return self;
}

- (void)removeItem:(BNRItem *)p {
    NSString *key = [p imageKey];
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [_allItems removeObjectIdenticalTo:p];
}

- (BNRItem *)createItem {
//    BNRItem *p = [BNRItem randomItem];
    BNRItem *p = [[BNRItem alloc] init];
    [_allItems addObject:p];
    return p;
}

- (void)divideInValue:(int)value {
    if ( [self allItems].count <= 0 ) { return; }
    for (BNRItem* item in [self allItems]) {
        if(item.valueInDollars > value) {
            [_itemsMoreThan addObject:item];
        } else {
            [_itemsRest addObject:item];
        }
    }
}

- (void)moveItemAtIndex:(int)from
                toIndex:(int)to
{
    if (from == to) {
        return;
    }
    // Get pointer to object being moved so we can re-insert it
    BNRItem *p = [_allItems objectAtIndex:from];
    
    // Remove p from array
    [_allItems removeObjectAtIndex:from];
    
    // Insert p in array at new location
    [_allItems insertObject:p atIndex:to];
}

- (NSString *)itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges {
    // returns success or failure
    NSString *path = [self itemArchivePath];
    NSLog(@"%@",path);
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_allItems requiringSecureCoding:YES error:&error];
    
    if(error) {
        NSLog(@"error : %@", error);
    }
    
    return [data writeToFile:path atomically:NO];
}


@end
