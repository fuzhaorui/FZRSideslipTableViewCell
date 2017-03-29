//
//  ViewController.m
//  SideslipDome
//
//  Created by fuzhaurui on 2017/3/14.
//  Copyright © 2017年 fuzhaurui. All rights reserved.
//

#import "ViewController.h"

#import "ATableViewCell.h"

@interface ViewController ()<SideslipTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic ,strong)IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ATableViewCell  *cell = [[ATableViewCell alloc] init];
    cell.delegate = self;
    
    
    
    NSInteger i = indexPath.row%3;
    
    if (i==0) {
        [cell createSideslipTableViewCell:100 andSideslipStyle:SideslipStyleLeft andLeftText:@"这是左按钮" andRightText:nil];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 200, 30)];
        [cell.cellContentView addSubview:label];
        label.text = @"这是左按钮cell";
    }
    else if (i==1) {
        [cell createSideslipTableViewCell:100 andSideslipStyle:SideslipStyleRight andLeftText:nil andRightText:@"这是右按钮"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 200, 30)];
        [cell.cellContentView addSubview:label];
        label.text = @"这是右按钮cell";
    }
    else if (i==2) {
        [cell createSideslipTableViewCell:100 andSideslipStyle:SideslipStyleDouble andLeftText:@"这是左按钮" andRightText:@"这是右按钮"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 200, 30)];
        [cell.cellContentView addSubview:label];
        label.text = @"这是左,右按钮cell";
    }
    
    
    
    
    
    

    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(void)cellClickAction:(FZRSideslipTableViewCell *)cell
{
    NSLog(@"这是按钮实现方法");
}

-(void)cellLeftButtonAction:(FZRSideslipTableViewCell *)cell
{
    NSLog(@"这是左按钮实现方法");
}

-(void)cellRightButtonAction:(FZRSideslipTableViewCell *)cell
{
    NSLog(@"这是右按钮实现方法");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
