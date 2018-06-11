//
//  People.m
//  简易通讯录001
//
//  Created by YueWen on 15/9/11.
//  Copyright (c) 2015年 YueWen. All rights reserved.
//

#import "People.h"
#import "Pinyin.h"


@implementation People

@dynamic address;
@dynamic image;
@dynamic name;
@dynamic tele;
@dynamic firstWord;



-(void)setPeopleInfoName:(NSString *)name Tele:(NSString *)tele Address:(NSString *)address Image:(UIImage *)image
{
    self.name = name;
    self.tele = tele;
    self.address = address;
    self.image = UIImagePNGRepresentation(image);
    [self loadFirstWord];

}


//设置首字母
-(void)loadFirstWord
{
    //设置首字母
    if (![self.name isEqualToString:@""])
    {
        self.firstWord = [NSString stringWithFormat:@"%c",pinyinFirstLetter([self.name characterAtIndex:0]) - 32];
    }
    
    else
    {
        self.firstWord = @"#";
    }
}



@end
