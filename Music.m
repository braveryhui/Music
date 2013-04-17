//
//  Music.m
//  Music
//
//  Created by loveuu on 15/4/13.
//  Copyright (c) 2013年 loveuu. All rights reserved.
//

#import "Music.h"

@implementation Music
@synthesize name,type;
-(id)initWithName:(NSString *)_name andType:(NSString *)_type
{
    if(self=[super init])
    {
        self.name=_name;
        self.type=_type;
    }
    return self;
}
-(void)dealloc
{
    [type release];
    [name release];
    [super dealloc];
}
@end
