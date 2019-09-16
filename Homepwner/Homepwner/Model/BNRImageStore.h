//
//  BNRImageStore.h
//  Homepwner
//
//  Created by rhino Q on 04/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNRImageStore : NSObject
{
    NSMutableDictionary  *dictionary;
}

+(instancetype)sharedStore;

-(void)setImage:(UIImage *)i forkey:(NSString *)s;
-(UIImage *)imageForKey:(NSString *)s;
-(void)deleteImageForKey:(NSString *)s;

-(NSString *)imagePathForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
