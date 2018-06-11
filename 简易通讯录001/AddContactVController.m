//
//  AddContactVController.m
//  简易通讯录
//
//  Created by YueWen on 15/9/10.
//  Copyright (c) 2015年 YueWen. All rights reserved.
//

#import "AddContactVController.h"
#import <CoreData/CoreData.h>
#import "People.h"
#import "Pinyin.h"
@interface AddContactVController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//姓名的nameText
@property (strong, nonatomic) IBOutlet UITextField *nameText;
//电话的teleText
@property (strong, nonatomic) IBOutlet UITextField *teleText;
//地址的addressText
@property (strong, nonatomic) IBOutlet UITextField *addressText;
//上下文对象
@property (strong, nonatomic) NSManagedObjectContext * mamagedObjectContext;
//图片选择器
@property (strong, nonatomic) UIImagePickerController * imagePickerController;
//显示头像的按钮
@property (strong, nonatomic) IBOutlet UIButton *titleImageButton;


@end

@implementation AddContactVController

#pragma mark - 按钮的目标动作回调

/**
 *  titleImageButton target action
 *
 *  @param sender 图片按钮
 */
- (IBAction)changeTitleImage:(UIButton *)sender
{
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}


/**
 *  DoneBarButtonItem target action
 *
 *  @param sender Done按钮
 */
- (IBAction)doneAddContact:(UIBarButtonItem *)sender
{
    //获取一个实体托管对象 people
    People * people = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([People class]) inManagedObjectContext:self.mamagedObjectContext];
    
    //为托管对象设置属性
    [people setPeopleInfoName:self.nameText.text Tele:self.teleText.text Address:self.addressText.text Image:self.titleImageButton.imageView.image];
    
    //上下文对象保存
    NSError * error;
    if (![self.mamagedObjectContext save:&error])
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    //跳到模态
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 *  CancleBarButtonItem target action
 *
 *  @param sender Cancle 按钮
 */
- (IBAction)cancleAddContact:(UIBarButtonItem *)sender
{
    //跳出模态状态
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 自带的加载方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置title
    self.navigationItem.title = @"添加联系人";
    
    //获取应用的上下文
    self.mamagedObjectContext = [self applicationManagedObjectContext];
    
    //初始化imagePickerController
    self.imagePickerController = [[UIImagePickerController alloc]init];
    
    //可以编辑
    self.imagePickerController.allowsEditing = YES;
    
    //注册回调
    self.imagePickerController.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取本应用的上下文对象
-(NSManagedObjectContext *)applicationManagedObjectContext
{
    //获取应用的单例对象
    UIApplication * application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    
    //返回应用的上下文对象
    return [delegate managedObjectContext];
}


#pragma mark - 实现 imagePickerControllerDelegate 方法
/**
 *  UIImagePickerController 点击Cancle
 *
 *  @param picker 当前UIImagePickerController
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //返回原来的界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  UIImagePickerController 点击Choose
 *
 *  @param picker 当前UIImagePickerController
 *  @param info   存取 对照片的操作 字典
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //获取到编辑好的图片
    UIImage * image = info[UIImagePickerControllerEditedImage];
    
    //把获取的图片设置成用户的头像
    [self.titleImageButton setImage:image forState:UIControlStateNormal];
    
    //返回原来的view
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
