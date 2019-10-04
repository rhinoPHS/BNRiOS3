//
//  RSSItem.m
//  Nerdfeed
//
//  Created by rhino Q on 04/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "RSSItem.h"

@implementation RSSItem

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    NSLog(@"\t\t%@ found %@ element", self, elementName);
    
    if([elementName isEqualToString:@"title"]) {
        _currentString = [NSMutableString new];
        [self setTitle:_currentString];
    } else if ([elementName isEqualToString:@"link"]) {
        _currentString = [NSMutableString new];
        [self setLink:_currentString];
    } else if ([elementName isEqualToString:@"author"]) {
        _currentString = [NSMutableString new];
        [self setAuthor:_currentString];
    } else if ([elementName isEqualToString:@"category"]) {
        _currentString = [NSMutableString new];
        [self setCategory:_currentString];
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
    if([elementName isEqualToString:@"item"]) {
        [parser setDelegate:_parentParserDelegate];
    }
}

@end
