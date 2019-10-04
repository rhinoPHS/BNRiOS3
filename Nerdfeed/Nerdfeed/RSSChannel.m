//
//  RSSChannel.m
//  Nerdfeed
//
//  Created by rhino Q on 04/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSItem.h"

@implementation RSSChannel

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Create the container for the RSSItems this channel has;
        // we'll create the RSSItem class shortly.
        _items = [NSMutableArray new];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    NSLog(@"\t%@ found a %@ element", self, elementName);
    
    if([elementName isEqualToString:@"title"]) {
        _currentString = [NSMutableString new];
        [self setTitle:_currentString];
    } else if ([elementName isEqualToString:@"description"]) {
        _currentString = [NSMutableString new];
        [self setInfoString:_currentString];
    } else if ([elementName isEqualToString:@"item"]) {
        RSSItem *entry = [RSSItem new];
        [entry setParentParserDelegate:self];
        [parser setDelegate:entry];
        [_items addObject:entry];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    NSLog(@"abc string: %@", string);
    [_currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    _currentString = nil;
    if([elementName isEqualToString:@"channel"]) {
        [parser setDelegate:_parentParserDelegate];
    }
}

@end
