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
    [coder encodeObject:_publicationDate forKey:@"publicationDate"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        [self setTitle:[coder decodeObjectForKey:@"title"]];
        [self setLink:[coder decodeObjectForKey:@"link"]];
        [self setPublicationDate:[coder decodeObjectForKey:@"publicationDate"]];
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
    } else if ([elementName isEqualToString:@"pubdate"]) {
        _currentString = [[NSMutableString alloc] init];
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
    
    // If the pubDate ends, use a date forammter to turn it into an NSDate
    if([elementName isEqualToString:@"pubdate"]) {
        static NSDateFormatter *dateFormatter = nil;
        if(!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        }
        NSLog(@"pubdate: %@", [dateFormatter dateFromString:_currentString]);
        [self setPublicationDate:[dateFormatter dateFromString:_currentString]];
    }
    
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

- (BOOL)isEqual:(id)object {
    // Make sure we are comparing an RSSItem!
    if(![object isKindOfClass:[RSSItem class]]) {
        return NO;
    }
    
    // Now only return YES if the links are equal.
    return [self.link isEqualToString:[object link]];
}

@end
