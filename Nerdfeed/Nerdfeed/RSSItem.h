//
//  RSSItem.h
//  Nerdfeed
//
//  Created by rhino Q on 04/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSSItem : NSObject<NSXMLParserDelegate, JSONSerializable, NSCoding, NSSecureCoding>

@property (nonatomic, copy) NSMutableString *currentString;
@property (nonatomic, weak) id parentParserDelegate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSDate *publicationDate;

@end

NS_ASSUME_NONNULL_END
