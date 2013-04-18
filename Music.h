//
//  Music.h
//  Music
//
//  Created by loveuu on 15/4/13.
//  Copyright (c) 2013年 loveuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject
{
    NSString* name;
    NSString* type;
}
@property (retain,nonatomic) NSString* name;
@property (retain,nonatomic) NSString* type;
-(id)initWithName:(NSString *)_name andType:(NSString *)_type;

@end
