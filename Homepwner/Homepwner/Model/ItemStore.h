//
//  ItemStore.h
//  Homepwner
//
//  Created by rhino Q on 14/08/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNRItem;

NS_ASSUME_NONNULL_BEGIN

@interface ItemStore : NSObject

@property NSMutableArray<BNRItem*> *allItems;
@property NSMutableArray<BNRItem*> *itemsMoreThan;
@property NSMutableArray<BNRItem*> *itemsRest;
+(instancetype)sharedStore;
-(BNRItem *)createItem;
-(void)divideInValue:(int)value;
-(void)removeItem:(BNRItem *)p;

- (void)moveItemAtIndex:(int)from
                toIndex:(int)to;


- (NSString *)itemArchivePath;
- (BOOL)saveChanges;

@end

NS_ASSUME_NONNULL_END
