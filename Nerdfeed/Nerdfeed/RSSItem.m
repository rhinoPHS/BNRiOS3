//
//  RSSItem.m
//  Nerdfeed
//
//  Created by rhino Q on 04/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "RSSItem.h"

@implementation RSSItem

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_link forKey:@"link"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        [self setTitle:[coder decodeObjectForKey:@"title"]];
        [self setLink:[coder decodeObjectForKey:@"link"]];
    }
    return self;
}

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
    if([elementName isEqualToString:@"item"]
       ||[elementName isEqualToString:@"entry"]) {
        [parser setDelegate:_parentParserDelegate];
    }
}

- (void)readFromJSONDictionary:(NSDictionary *)d {
    [self setTitle:[[d objectForKey:@"title"] objectForKey:@"label"]];
    
    // Inside each entry is an array of links, each has an attribute object
    NSArray *links = [d objectForKey:@"link"];
    if([links count] > 1) {
        NSDictionary *sampleDict = [[links objectAtIndex:1] objectForKey:@"attributes"];
        
        // the href of an attribute object is the URL for sample audio file
        [self setLink:[sampleDict objectForKey:@"href"]];
    }
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
