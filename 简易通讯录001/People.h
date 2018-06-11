//
//  People.h
//  简易通讯录001
//
//  Created by YueWen on 15/9/11.
//  Copyright (c) 2015年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>


@interface People : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * tele;
@property (nonatomic, retain) NSString * firstWord;

-(void)setPeopleInfoName:(NSString *)name Tele:(NSString *)tele Address:(NSString *)address Image:(UIImage *)image;

@end
