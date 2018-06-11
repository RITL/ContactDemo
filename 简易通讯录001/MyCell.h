//
//  MyCell.h
//  简易通讯录001
//
//  Created by Ibokan on 15/9/11.
//  Copyright (c) 2015年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *titleImage;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *teleLabel;

@end
