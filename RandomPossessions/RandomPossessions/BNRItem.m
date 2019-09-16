//
//  BNRItem.m
//  RandomPossessions
//
//  Created by rhino Q on 16/08/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

+ (instancetype)randomItem {
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy", @"Rusty", @"Shiny", nil];
    
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear", @"Spork", @"Mac" , nil];
    
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = rand() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0'+ rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomName
                                        valueInDollars:randomValue
                                          serialNumber:randomSerialNumber];
    
    return newItem;
}

- (instancetype)init
{
    return [self initWithItemName:@"Item"
                   valueInDollars:0
                     serialNumber:@""];
}

- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)number {
    self = [super init];
    if(self) {
        
        _itemName = name;
        _serialNumber = number;
        _valueInDollars = value;
        _dateCreated = [NSDate new];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@): Worth $%d, recorded on %@", _itemName, _serialNumber, _valueInDollars, _dateCreated];
}

- (void)dealloc
{
    NSLog(@"Destroyed : %@", self);
}

- (void)setContainedItem:(BNRItem *)containedItem {
    _containedItem = containedItem;
    [containedItem setContainer:self];
}

@end
