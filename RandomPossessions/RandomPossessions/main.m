//
//  main.m
//  RandomPossessions
//
//  Created by rhino Q on 16/08/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        BNRItem *p = [[BNRItem alloc] initWithItemName:@"Red Sofa"
//                                        valueInDollars:100
//                                          serialNumber: @"A1B2C"];
//        NSLog(@"%@",p);
        
        NSMutableArray<BNRItem*> *items = [NSMutableArray new];
//
//        for(int i =0; i<10; i++) {
//            BNRItem *p = [BNRItem randomItem];
//            [items addObject:p];
//        }
//
//        for(BNRItem * item in items) {
//            NSLog(@"%@", item);
//        }
//
        
        BNRItem *backpack = [BNRItem new];
        backpack.itemName = @"Backpack";
        [items addObject:backpack];
        
        BNRItem *calcualtor = [BNRItem new];
        calcualtor.itemName = @"Calculator";
        [items addObject:calcualtor];
        
        backpack.containedItem = calcualtor;
//        calcualtor.container = backpack;
        
        NSLog(@"Setting items to nil...");
        items = nil;
        
    }
    return 0;
}
