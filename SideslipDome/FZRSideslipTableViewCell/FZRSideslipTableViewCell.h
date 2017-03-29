//
//  BankCardTableViewCell.h
//  sender
//
//  Created by IOS-开发机 on 16/3/9.
//  Copyright © 2016年 IOS-开发机. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, SideslipStyle){
    
    /**
     *  单使用左按钮
     */
    SideslipStyleLeft= 0,
    
    /**
     *  单使用右按钮
     */
    SideslipStyleRight,
    
    /**
     *  同时使用连个按钮
     **/
    SideslipStyleDouble
    
};

@class FZRSideslipTableViewCell;


@protocol SideslipTableViewCellDelegate <NSObject>

@optional

- (void)cellClickAction :(FZRSideslipTableViewCell *)cell;

- (void)cellLeftButtonAction:(FZRSideslipTableViewCell *)cell;

- (void)cellRightButtonAction:(FZRSideslipTableViewCell *)cell;

@end

@interface FZRSideslipTableViewCell : UITableViewCell

@property (strong,nonatomic) UIView  *cellContentView;
@property (strong,nonatomic) id<SideslipTableViewCellDelegate>delegate;

/**
 MARK: -
 MARK: 恢复cell未滑动前
 **/
-(void)recoveryDefaultState;

/**
 MARK:         创建SideslipTableViewCell
 height        cell的高度
 leftText      左按钮 按钮名字
 rightText     右按钮 按钮名字
 **/
-(void)createSideslipTableViewCell:(CGFloat)height andSideslipStyle:(SideslipStyle)sideslipStyle andLeftText:(NSString*)leftText  andRightText:(NSString*)rightText;

/**
 MARK:            创建SideslipTableViewCell
 height           cell的高度
 leftText         左按钮 按钮名字
 leftTextColor    左按钮 按钮背景
 rightText        右按钮 按钮名字
 rightTextColor   右按钮 按钮背景
 **/
-(void)createSideslipTableViewCell:(CGFloat)height andSideslipStyle:(SideslipStyle)sideslipStyle andLeftText:(NSString*)leftText andLeftTextColor:(UIColor*)leftTextColor  andRightText:(NSString*)rightText andRightTextColor:(UIColor*)rightTextColor;


@end
