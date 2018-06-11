//
//  ContactsTVController.m
//  简易通讯录
//
//  Created by YueWen on 15/9/10.
//  Copyright (c) 2015年 YueWen. All rights reserved.
//

#import "ContactsTVController.h"
#import "AddContactVController.h"
#import <CoreData/CoreData.h>
#import "People.h"
#import "UpdataContactVController.h"
#import "MyCell.h"

@interface ContactsTVController ()<NSFetchedResultsControllerDelegate,UISearchControllerDelegate,UISearchResultsUpdating>
@property (nonatomic, strong) NSManagedObjectContext * mangaedOjectContext;//上下文对象
@property (nonatomic, strong) NSFetchedResultsController * fetchResultsController;
@property (nonatomic, strong) UISearchController * searchController;

@end

@implementation ContactsTVController

#pragma mark - UISearchResultsUpdating 协议
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //获取输入搜索的内容
    NSString * text = self.searchController.searchBar.text;
    
    //创建请求
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"People"];
    
    //创建排序器
    NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstWord" ascending:YES];
    [request setSortDescriptors:@[descriptor]];
    
    //创建谓词
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name contains %@",text];
    [request setPredicate:predicate];
    
    //初始化fetchResulteController
    self.fetchResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.mangaedOjectContext sectionNameKeyPath:@"firstWord" cacheName:nil];
    
    //执行
    NSError * error;
    if (![self.fetchResultsController performFetch:&error])
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    //刷新当前tableView
    [self.tableView reloadData];
}

#pragma mark - UISearchControllerDelegate 协议

/**
 *  搜索栏已经消失后
 *
 *  @param searchController 当前 searchController
 */
- (void)didDismissSearchController:(UISearchController *)searchController
{

    //重新设置fetchResultsController的属性
    [self loadMyFetchResultsController];
    
    //刷新当前的tableView
    [self.tableView reloadData];
    

}


#pragma mark - 配置相关控件

/**
 *  加载FRC
 */
-(void)loadMyFetchResultsController
{
    /***************配置fetchResultsController************/
    
    //创建请求
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass([People class])];
    
    //创建一个排序描述
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstWord" ascending:YES];
    
    //加在排序
    [request setSortDescriptors:@[sortDescriptor]];
    
    //创建fetchResultsController
    self.fetchResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.mangaedOjectContext sectionNameKeyPath:@"firstWord" cacheName:nil];
    
    
    //执行fetchResultsController
    NSError * error;
    if (![self.fetchResultsController performFetch:&error])
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    //设置fetchResultsController的代理
    self.fetchResultsController.delegate = self;
}

/**
 *  加载SearchController
 */
-(void)loadMySearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    //添加搜索栏
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    //这是搜索的代理
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    
    //搜索时背景不暗淡
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
}


#pragma mark - 添加联系人的目标动作回调
- (IBAction)addContact:(UIBarButtonItem *)sender
{
    //获取storyboard
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    //从storyboard中获得添加联系人的页面
    UINavigationController * addContactNVController = [storyboard instantiateViewControllerWithIdentifier:@"addContactNVController"];
    
    //以模态的形式跳出
    [self presentViewController:addContactNVController animated:YES completion:nil];
    
}


#pragma mark - 默认的加载方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题
    self.navigationItem.title = @"通讯录";
    
    //设置左上角的编辑 bar button item
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //获取该应用的上下文对象
    self.mangaedOjectContext = [self applicationManagedObjectContext];
    
    //配置fetchResultsController数据
    [self loadMyFetchResultsController];
    
    //配置searchController
    [self loadMySearchController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//返回的是tableView的分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //获取fetchResultsController的所有组
    NSArray * sections = [self.fetchResultsController sections];
    
    return sections.count;
}

//返回的是每组 的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //获取fetchResultsController的所有的组
    NSArray * sections = [self.fetchResultsController sections];
    
    //获取每组的信息
    id <NSFetchedResultsSectionInfo> section0 = sections[section];
    
    return [section0 numberOfObjects];
}


//返回的是每个cell的显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //获取模型对象
    People * people = [self.fetchResultsController objectAtIndexPath:indexPath];
    
    //创建MyCell,是自定义的cell
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    
    //设置cell右侧的小箭头
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    //为cell赋值
    cell.titleImage.image = [UIImage imageWithData:people.image];
    cell.nameLabel.text = people.name;
    cell.teleLabel.text = people.tele;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//设置头标
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //获得所有的sections
    NSArray * sections = [self.fetchResultsController sections];
    
    //返回title
    return [sections[section] name];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //从上下文中获得该模型
        People * people = [self.fetchResultsController objectAtIndexPath:indexPath];
        
        //从上下文中删除该模型
        [self.mangaedOjectContext deleteObject:people];
        
        //上下文保存
        NSError * error;
        if (![self.mangaedOjectContext save:&error])
        {
            NSLog(@"%@",[error localizedDescription]);
        }
        
        //跳转至根视图
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

//点击tableView中的元素执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //获取模型对象
    People * people = [self.fetchResultsController objectAtIndexPath:indexPath];
    
    //获取stroyboard
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    //创建一个 UpdataContactVController 准备跳转
    UpdataContactVController *  updataContactVController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([UpdataContactVController class])];
    
    //将模型对象赋值给 跳转页面的属性
    [updataContactVController setPeople:people];
    
    //设置标题
    updataContactVController.navigationItem.title = @"更新联系人";
    
    [self.navigationController pushViewController:updataContactVController animated:YES];
    
    [self.searchController setActive:NO];
    
}




// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/**
 *  为tableView 添加侧栏
 *
 *  @param tableView 当前tableView
 *
 *  @return 侧栏数组
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray * sections = [self.fetchResultsController sections];//获取所有的组
    NSMutableArray * titles = [NSMutableArray array];//用来存储组名的数据
    
    for (id section in sections)//开始便利
    {
        [titles addObject:[section name]];
    }
    
    //返回侧栏的数组
    return titles;
}


//-(void)viewWillDisappear:(BOOL)animated
//{
//    [self.searchController setActive:NO];
//}


#pragma mark - 实现 UITableViewConrollerDelegate 方法

//返回该行的row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//更改删除按键的title
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
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

#pragma mark - 实现 NSFetchResultsControllerDelegate 的方法

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    //tableView开始更新
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    switch(type) {
        //如果是加入了新的组
        case NSFetchedResultsChangeInsert:
            //tableView插入新的组
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        //如果是删除了组
        case NSFetchedResultsChangeDelete:
            //tableView删除新的组
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        //如果是组中加入新的对象
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        //如果是组中删除了对象
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        //如果是组中的对象发生了变化
        case NSFetchedResultsChangeUpdate:
            //**********我们需要修改的地方**********
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        //如果是组中的对象位置发生了变化
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //用自己算好的最有算法，进行排列更新
    [self.tableView endUpdates];
}

@end
