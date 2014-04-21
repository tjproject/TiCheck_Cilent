//
//  AccountEditViewController.m
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-9.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "AccountEditViewController.h"
#import "AccountEditDetailViewController.h"
#import "UserData.h"
@interface AccountEditViewController ()
@property (strong, nonatomic) UITextField* cellPasswordDisplay;
@end

@implementation AccountEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"账号信息";
}
- (void)animationDidStart:(CAAnimation *)anim
{
    [self.tableView reloadData];
    NSLog(@"reload");
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    //[self.cellPasswordDisplay removeFromSuperview];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button event

- (IBAction)LogoutButtonEvent:(id)sender
{
    NSLog(@"log out");
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //
    [self setExtraCellLineHidden:tableView];
    [tableView setScrollEnabled:NO];
    //
    return 1;
}

//delete useless lines
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    //[view release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //use the cell defined in storyboard
    static NSString *CellIdentifier = @"AccountInfoCell";

    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //TODO: get the personal info
    NSString* cellTitle=@"tt";
    NSString* cellContent=@"tt";
    
    if(indexPath.row==0)
    {
        cellTitle=@"邮箱";
        cellContent=[UserData sharedUserData].email;
        cell.detailTextLabel.hidden=NO;
    }
    else if(indexPath.row==1)
    {
        cellTitle=@"用户名";
        cellContent=[UserData sharedUserData].userName;
        cell.detailTextLabel.hidden=NO;
    }
    else if(indexPath.row==2)
    {
        
        cellTitle=@"密码";
        cellContent=@"******";
        cell.detailTextLabel.hidden=YES;
        cell.detailTextLabel.text=cellContent;
        
        //hide the original label, and generate a uitextfield to show password
        if(self.cellPasswordDisplay==nil)
        {
            CGRect temp=cell.detailTextLabel.frame;
            self.cellPasswordDisplay=[[UITextField alloc] initWithFrame: CGRectMake(temp.origin.x-20, temp.origin.y+100, temp.size.width+100, temp.size.height)];
            self.cellPasswordDisplay.text=cellContent;
            self.cellPasswordDisplay.secureTextEntry=YES;
            self.cellPasswordDisplay.enabled=NO;
            [self.tableView addSubview:self.cellPasswordDisplay];
        }
    }
    
    cell.textLabel.text=cellTitle;
    cell.detailTextLabel.text=cellContent;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editDetail"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        AccountEditDetailViewController* tempController= [segue destinationViewController];
        
        if(indexPath.row==0)
        {
            NSLog(@"change name");
            tempController.navigationItem.title=@"修改邮箱";
        }
        else if(indexPath.row==1)
        {
            //e-mail
            tempController.navigationItem.title=@"修改用户名";
        }
        else if(indexPath.row==2)
        {
            tempController.navigationItem.title=@"修改密码";
        }
        [tempController setEditDetailType:indexPath.row];
    }
    
    //[self.tableView removeFromSuperview];
}
@end
