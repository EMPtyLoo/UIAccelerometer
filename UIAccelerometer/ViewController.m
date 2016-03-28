//
//  ViewController.m
//  UIAccelerometer
//
//  Created by EMPty on 3/29/16.
//  Copyright (c) 2016 EMPty. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIAccelerometerDelegate>
{
    UILabel* _ball;//球

}
#pragma mark 没有*
@property (nonatomic) CGPoint velocity;//保存X  Y的加速度

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _ball = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _ball.backgroundColor = [UIColor redColor];
    _ball.layer.cornerRadius = 10.0;
    [self.view addSubview:_ball];
    
//    _velocity = CGPointMake(0, 0);
    _velocity.x = 0;
    _velocity.y = 0;
    
    
    //1.利用单例获取采集对象
    UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
    
    //2.设置代理
    accelerometer.delegate = self;

    //3.设置采样时间
    accelerometer.updateInterval = 1/30;//一分钟30次
    
}


#pragma mark - 代理方法

//4.实现代理方法
/*
 只要采集到数据就会调用（调用非常频繁）
 accelerometer ： 出发事件的对象
 acceleration ： 获取到的数据
 
 */

//有一个重力加速度的作用  所以会有值

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
//    NSLog(@"X : %f,Y : %f,Z : %f",acceleration.x,acceleration.y,acceleration.z);
    
    
    //边界检测 防止东西出去屏幕以外
    if (_ball.frame.origin.x >= 0 && _ball.frame.origin.x <= [UIScreen mainScreen].bounds.size.width - _ball.bounds.size.width  && _ball.frame.origin.y >= 0 && _ball.frame.origin.y <= [UIScreen mainScreen].bounds.size.height - _ball.bounds.size.height) {
                
    
    /*
     速度 = 加速度 * 时间
     v = a * t = a * t1 + a* t2 ..
     
     */
    //修改对象结构体的属性成员
//    self.velocity.x = acceleration.x;
    _velocity.x += acceleration.x * 10;
        //不是一点一点加的  可能突然超出了  做一下判断
        if (_velocity.x >= [UIScreen mainScreen].bounds.size.width - _ball.bounds.size.width) {
            _velocity.x = [UIScreen mainScreen].bounds.size.width - _ball.bounds.size.width;
        }
        if (_velocity.x <= 0 ) {
            _velocity.x = 0;
        }
        
    //-获取到的y轴加速度和UIKit坐标系的Y值是相反的，想让小球往加速度的反方向运动
    _velocity.y -= acceleration.y * 10;
    
        if (_velocity.y >= [UIScreen mainScreen].bounds.size.height - _ball.bounds.size.height) {
            _velocity.y = [UIScreen mainScreen].bounds.size.height - _ball.bounds.size.height;
        }
        if (_velocity.y <= 0 ) {
            _velocity.y = 0;
        }
        
    /*
     移动距离=速度 * 时间
     s = vt = v * t1 + v * t2 ...
     */
    
    
    [_ball setFrame:CGRectMake(_velocity.x, _velocity.y, _ball.bounds.size.width, _ball.bounds.size.height)];
        
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
