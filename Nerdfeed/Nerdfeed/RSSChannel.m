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

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_items forKey:@"items"];
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_infoString forKey:@"infoString"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _items = [coder decodeObjectForKey:@"items"];
        [self setInfoString:[coder decodeObjectForKey:@"infoString"]];
        [self setTitle:[coder decodeObjectForKey:@"title"]];
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
    } else if ([elementName isEqualToString:@"item"]
               || [elementName isEqualToString:@"entry"]) {
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
        [self trimItemTitles];
    }
}

-(void)trimItemTitles {
    // Create a regular expression with the pattern: Author
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:@"Declarative"
                                                                    options:0 error:nil];
    // Loop through every title of the items in channel
    for(RSSItem *i in _items) {
        NSString *itemTitle = [i title];
        
        // Find matches in the title string. The range
        // argument specifies specifies how much of the title to search;
        // in this case, all of it.
        NSArray *matches =[reg matchesInString:itemTitle options:0 range:NSMakeRange(0, [itemTitle length])];
        
        // If there was a match...
        if([matches count] > 0) {
            //Print the location of the match in the string and the stirng
            NSTextCheckingResult *result = [matches objectAtIndex:0];
            NSRange r = [result range];
            NSLog(@"Match at {%d, %d} for %@!", (int)r.location, (int)r.length, itemTitle);
        }
    }
}

- (void)readFromJSONDictionary:(NSDictionary *)d {
    // The top-level object contains a "feed" object, which is the channel.
    NSDictionary *feed = [d objectForKey:@"feed"];
    
    // The feed has a title property, make this the title of our channel.
    [self setTitle:[[feed objectForKey:@"title"] objectForKey:@"label"]];
    
    // The feed also has an array of entries, for each one, make a new RSSItem.
    NSArray *entries = [feed objectForKey:@"entry"];
    for(NSDictionary *entry in entries) {
        RSSItem *i = [RSSItem new];
        
        // Pass the entry dictionary to the item so it can grab its ivars
        [i readFromJSONDictionary:entry];
        [_items addObject:i];
    }
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
