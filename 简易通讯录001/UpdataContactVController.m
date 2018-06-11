//
//  UpdataContactVController.m
//  简易通讯录001
//
//  Created by YueWen on 15/9/10.
//  Copyright (c) 2015年 YueWen. All rights reserved.
//

#import "UpdataContactVController.h"
#import "People.h"
#import "Pinyin.h"

@interface UpdataContactVController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UITextField *teleText;
@property (strong, nonatomic) IBOutlet UITextField *addressText;
@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, strong) People * people;
@property (nonatomic, strong) UIImagePickerController * imagePickerController;
@property (strong, nonatomic) IBOutlet UIButton *titleImageButton;

@end

@implementation UpdataContactVController

#pragma mark - Button Target Action
/**
 *  titleImageButton target action
 *
 *  @param sender 头像按钮
 */
- (IBAction)changeTitleImage:(UIButton *)sender
{
    //当图片选择器必须加载完毕后，才能跳
    if (self.imagePickerController != nil)
    {
        //跳至图片选择界面
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }

}

/**
 *  DoneItemButton target action
 *
 *  @param sender Done 按钮
 */
- (IBAction)doneKeepContext:(UIBarButtonItem *)sender
{
    //保存修改后的信息
    [self.people setPeopleInfoName:self.nameText.text Tele:self.teleText.text Address:self.addressText.text Image:self.titleImageButton.imageView.image];
    
    //上下文保存
    NSError * error;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    //跳回通讯录页面
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark - 加载面板属性
/**
 *  加载面板的各项信息
 */
-(void)loadPeopleContext
{
    self.nameText.text = self.people.name;
    self.teleText.text = self.people.tele;
    self.addressText.text = self.people.address;
    
    //设置button的图片
    [self.titleImageButton setImage:[UIImage imageWithData:self.people.image] forState:UIControlStateNormal];
    
}


#pragma mark - view加载方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化上下文对象
    self.managedObjectContext = [self applicationManagedObjectContext];
    
    //设置面板
    [self loadPeopleContext];
    
    //创建图片选择器,用子线程加载，不然会出现卡顿现象
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //异步加载相册
        self.imagePickerController = [[UIImagePickerController alloc]init];
       
        //用主线程来修改属性
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //可以编辑
            self.imagePickerController.allowsEditing = YES;
            
            //注册回调
            self.imagePickerController.delegate = self;
        });

    });
 
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





#pragma mark - 重写people的set方法
-(void)setPeople:(People *)people
{
    _people = people;
}





#pragma mark - 实现 UIImagePickerControllerDelegate 的方法
/**
 *  如果取消了图片选择
 *
 *  @param picker 当前的UIImagePickerController
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //调回原来的视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

//选择完图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取图片
    UIImage * image = info[UIImagePickerControllerEditedImage];
    
    //设置成button的背景图片
    [self.titleImageButton setImage:image forState:UIControlStateNormal];
    
    //返回上一页面
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
