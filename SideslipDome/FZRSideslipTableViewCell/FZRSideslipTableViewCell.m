//
//  BankCardTableViewCell.m
//  sender
//
//  Created by IOS-开发机 on 16/3/9.
//  Copyright © 2016年 IOS-开发机. All rights reserved.
//

#import "FZRSideslipTableViewCell.h"

static CGFloat _width = 90;


typedef NS_ENUM(NSInteger, SideslipDirectionType) {
    
    /**
     *  向左滑动
     */
    SideslipDirectionTypeLeft=0,
    
    /**
     *  恢复原状
     **/
    
    SideslipDirectionTypeDefault,
    
    /**
     *  先右滑动
     */
    SideslipDirectionTypeRight,
    
};

@interface FZRSideslipTableViewCell()<UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView    *scrollView;
@end


@implementation FZRSideslipTableViewCell
{
    
    SideslipDirectionType   _directionType;
    SideslipStyle           _sideslipStyle;
    CGFloat                 _direction_x;
    CGFloat                 _height;
    CGSize                  _size;
    UIColor                 *_leftTextColor;
    UIColor                 *_rightTextColor;
    
}


/**
 MARK:            创建SideslipTableViewCell
 sideslipStyle    滑动按钮类型
 height           cell的高度
 leftText         左按钮 按钮名字
 leftTextColor    左按钮 按钮背景
 rightText        右按钮 按钮名字
 rightTextColor   右按钮 按钮背景
 **/
-(void)createSideslipTableViewCell:(CGFloat)height andSideslipStyle:(SideslipStyle)sideslipStyle andLeftText:(NSString*)leftText andLeftTextColor:(UIColor*)leftTextColor  andRightText:(NSString*)rightText andRightTextColor:(UIColor*)rightTextColor
{
    _leftTextColor  = leftTextColor;
    _rightTextColor = rightTextColor;
    [self createSideslipTableViewCell:height andSideslipStyle:sideslipStyle andLeftText:leftText andRightText:rightText];
}


/**
 MARK:             创建SideslipTableViewCell
 sideslipStyle     滑动按钮类型
 height            cell的高度
 leftText          左按钮 按钮名字
 rightText         右按钮 按钮名字
 **/
-(void)createSideslipTableViewCell:(CGFloat)height andSideslipStyle:(SideslipStyle)sideslipStyle andLeftText:(NSString*)leftText  andRightText:(NSString*)rightText
{
    _sideslipStyle = sideslipStyle;
    
    [self createSideslipTableViewCell:height  andLeftText:leftText andRightText:rightText];
}

/**
 MARK:            创建SideslipTableViewCell
 height           cell的高度
 leftText         左按钮 按钮名字
 rightText        右按钮 按钮名字
 **/
-(void)createSideslipTableViewCell:(CGFloat)height andLeftText:(NSString*)leftText  andRightText:(NSString*)rightText
{
    _size = [UIScreen mainScreen].bounds.size;
    _height =  height-10;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _direction_x = _width;
    
    if(_sideslipStyle != SideslipStyleRight)
    {
        [self.contentView addSubview:[self setLeftButtonIcon:leftText]];
    }
    if(_sideslipStyle != SideslipStyleLeft)
    {
        [self.contentView addSubview:[self setRightButtonIcon:rightText]];
    }
    
    [self.contentView addSubview:[self createScrollView]];
    
    if(_sideslipStyle != SideslipStyleRight)
    {
        [_scrollView addSubview:[self setLeftButton]];
    }
    if(_sideslipStyle != SideslipStyleLeft)
    {
        [_scrollView addSubview:[self setRightButton]];
    }
    
    [self createCellContentView];
}

/**
 MARK: 创建 滑动控件 ScrollView
 **/
-(UIScrollView *)createScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake( 0, 0, _size.width, _height + 10)];
    _scrollView.bounces = NO;
    
    if (_sideslipStyle == SideslipStyleDouble) {
        _scrollView.contentSize = CGSizeMake(_size.width+(_width*2),0);
    }
    else
    {
        _scrollView.contentSize = CGSizeMake(_size.width+_width,0);
    }
    
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.delegate = self;
    if (_sideslipStyle == SideslipStyleRight) {
        [_scrollView setContentOffset:CGPointMake(0, 0)];
    }
    else
    {
        [_scrollView setContentOffset:CGPointMake(_width, 0)];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [_scrollView addGestureRecognizer:tapGestureRecognizer];
    return _scrollView;
}


/**
 MARK: 有效内容视图
 **/
-(void)createCellContentView
{
    
    self.cellContentView = [[UIView alloc]initWithFrame:_sideslipStyle ==SideslipStyleRight?CGRectMake(5, 5, _size.width - 10, _height): CGRectMake(_width+5, 5, _size.width - 10, _height)];
    self.cellContentView.backgroundColor = [UIColor whiteColor];
    self.cellContentView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.cellContentView.layer.shadowOffset = CGSizeMake(2,2);
    self.cellContentView.layer.shadowOpacity = 0.4;
    self.cellContentView.layer.shadowRadius = 2;//阴影半径，默认3
    self.cellContentView.layer.cornerRadius = 5;
    self.cellContentView.layer.borderColor  = [self color:@"#CCCCCC"].CGColor;
    self.cellContentView.layer.borderWidth  = 0.3;
    [_scrollView addSubview:self.cellContentView];
    
}


/**
 MARK: - 释放滑动 将上一个cell 恢复原状
 **/
-(void)recoveryDefault
{
    static FZRSideslipTableViewCell *cell;
    if (cell!=nil && ![self isEqual:cell]) {
        [cell recoveryDefaultState];
    }
    cell = self;
}

/**
 MARK: 将cell恢复未滑动前
 **/
-(void)recoveryDefaultState
{
    if (_sideslipStyle == SideslipStyleRight)
    {
        [self animation:_scrollView candontentOffset:CGPointMake(0, 0) andDuration:0.15 andDelay:0];
    }
    else
    {
        [self animation:_scrollView candontentOffset:CGPointMake(_width, 0) andDuration:0.15 andDelay:0];
    }
    
}


/**
 MARK: - 设置设置按钮
 MARK: 设置左按钮
 **/

-(UIButton *)setLeftButton
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, _width, _height)];
    button.tag = 1000;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


/**
 MARK: 设置右按钮
 **/
-(UIButton *)setRightButton
{
    UIButton *button = [[UIButton alloc]initWithFrame:_sideslipStyle==SideslipStyleRight?CGRectMake(_size.width, 5, _width, _height) :CGRectMake(_size.width+_width, 5, _width, _height)];
    button.tag = 1001;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


/**
 MARK: 设置左按钮背景
 **/
-(UIView *)setLeftButtonIcon:(NSString *)leftName
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5 , 5, (_size.width-10)/2, _height)];
    
    if (!_leftTextColor) {
        view.backgroundColor = [self color:@"#37BF75"];
    }
    else
    {
        view.backgroundColor = _leftTextColor;
    }
    
    
    
    view.layer.cornerRadius = 5;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0 , _height/2-20, _width, 40)];
    
    label.font = [UIFont systemFontOfSize:13.0f];
    
    label.textColor = [UIColor whiteColor];
    
    if (leftName) {
        label.text = leftName;
    }
    else{
        label.text = @"选中";
    }
    
    label.numberOfLines = 0;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.backgroundColor = [UIColor clearColor];
    
    [view addSubview:label];

    return view;
}




/**
 MARK: 设置右按钮背景
 **/
-(UIView *)setRightButtonIcon:(NSString *)rightName
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(_size.width/2 , 5, (_size.width-10)/2, _height)];
    
    if (!_rightTextColor) {
        view.backgroundColor = [self color:@"#FB6E6D"];
    }
    else
    {
        view.backgroundColor = _rightTextColor;
    }
    
    view.layer.cornerRadius = 5;
    
    CGFloat width = view.frame.size.width;
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(width -_width/2-7.5, _height/2 - 18, 15, 18)];
    
    icon.backgroundColor = [UIColor clearColor];
    
    icon.image = [UIImage imageNamed:@"del_icon"];
    
    [view addSubview:icon];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width -_width , _height/2, _width, 30)];
    
    label.font = [UIFont systemFontOfSize:13.0f];
    
    label.textColor = [UIColor whiteColor];
    
    if (rightName) {
        label.text = rightName;
    }
    else{
        label.text = @"删除";
    }
    
    label.numberOfLines = 0;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.backgroundColor = [UIColor clearColor];
    
    [view addSubview:label];
    
    return view;
}



/**
 MARK: - UIScrollView代理
 MARK: 记录cell滑动方向
 **/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self recoveryDefault];
    if (scrollView.contentOffset.x >= _direction_x ) {
        _directionType = SideslipDirectionTypeLeft;
    }
    else if(scrollView.contentOffset.x < _direction_x )
    {
        _directionType = SideslipDirectionTypeRight;
    }
    _direction_x = scrollView.contentOffset.x;

}

/**
 MARK: cell结束滑动 记录结束 cell  继续之后的滑动
 **/
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{

    if (_directionType == SideslipDirectionTypeLeft) {
        
        if (_direction_x<_width) {
            [self setContentOffset:_scrollView.contentOffset.x];
        }
        else if(_width<_direction_x<_width*2 && _sideslipStyle ==SideslipStyleDouble)
        {
            [self setContentOffset:_scrollView.contentOffset.x-_width];
        }
        
    }
    else if (_directionType == SideslipDirectionTypeRight) {
        
        if (_direction_x<_width) {
            [self setContentOffset:_width-_scrollView.contentOffset.x];
        }
        else if(_width<_direction_x<_width*2 &&_sideslipStyle ==SideslipStyleDouble)
        {
            [self setContentOffset:2*_width-_scrollView.contentOffset.x];
        }
        
    }
    
}

/**
 MARK: cell后续滑动
 **/
-(void)setContentOffset:(CGFloat)float_x
{
    
    NSTimeInterval  time = 0.15 *(float_x/(_width));
    
    if (_directionType == SideslipDirectionTypeLeft) {
        
        if (_direction_x<_width) {

            [self animation:_scrollView candontentOffset:CGPointMake(_width, 0) andDuration:time andDelay:0];
        }
        else if(_width<_direction_x<_width*2 && _sideslipStyle ==SideslipStyleDouble)
        {
            
            [self animation:_scrollView candontentOffset:CGPointMake(_width*2, 0) andDuration:time andDelay:0];
        }
        
    }
    else if (_directionType == SideslipDirectionTypeRight) {
       
        if (_direction_x<_width) {
            
            [self animation:_scrollView candontentOffset:CGPointMake(0, 0) andDuration:time andDelay:0];
        }
        else if(_width<_direction_x<_width*2 && _sideslipStyle ==SideslipStyleDouble)
        {
            
            [self animation:_scrollView candontentOffset:CGPointMake(_width, 0) andDuration:time andDelay:0];
        }
        
    }
}




/**
 MARK: - cell实现方法
 MARK: 点击滑动按钮
 **/
-(void)buttonAction:(UIButton *)sender
{
    // MARK: 点击左按钮
    if (sender.tag == 1000) {
        [self.delegate cellLeftButtonAction:self];
    }
    // MARK: 点击左按钮
    else if (sender.tag == 1001) {
        [self.delegate cellRightButtonAction:self];
    }
}

/**
 MARK: 点击cell有效内容
 **/
-(void)tapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if ((_scrollView.contentOffset.x == _width&&_sideslipStyle==SideslipStyleDouble)||(_scrollView.contentOffset.x == _width&&_sideslipStyle==SideslipStyleLeft)||(_scrollView.contentOffset.x == 0&&_sideslipStyle==SideslipStyleRight))
    {
        [self.delegate cellClickAction:self];
    }
    else
    {
        if (_sideslipStyle==SideslipStyleRight) {
             [self animation:_scrollView candontentOffset:CGPointMake(0, 0) andDuration:0.15 andDelay:0];
        }
        else
        {
             [self animation:_scrollView candontentOffset:CGPointMake(_width, 0) andDuration:0.15 andDelay:0];
        }
    }
    
}

/**
 MARK: - 工具类
 MARK: UIView的动画
 1.point :动画后 UIView的contentOffset
 2.duration :动画耗时
 3.delay :动画延迟时间
 **/
-(void)animation:(UIView *)view candontentOffset:(CGPoint)point andDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay
{
    
    UIScrollView *scrollView = (UIScrollView *)view;
    //创建动画
    [UIView beginAnimations:nil context:nil];
    //动画时间
    [UIView setAnimationDuration:duration];
    //延迟时间
    [UIView setAnimationDelay:delay];
    //移动后的位置
    scrollView.contentOffset = *(&point);
    //开始动画
    [UIView commitAnimations];
}


/**
 MARK:  将NSString 转换为 UIColor
 1.colorStr: 二进制色值 NSString
 **/
-(UIColor *)color:(NSString *)colorStr
{
    if (!colorStr || [colorStr isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = colorStr.length == 7?1:0;
    [[NSScanner scannerWithString:[colorStr substringWithRange:range]] scanHexInt:&red];
    range.location = colorStr.length == 7?3:2;
    [[NSScanner scannerWithString:[colorStr substringWithRange:range]] scanHexInt:&green];
    range.location = colorStr.length == 7?5:4;
    [[NSScanner scannerWithString:[colorStr substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}



@end
