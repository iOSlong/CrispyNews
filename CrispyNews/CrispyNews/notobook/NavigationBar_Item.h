//
//  NavigationBar_Item.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/9.
//  Copyright © 2016年 letv. All rights reserved.
//

#ifndef NavigationBar_Item_h
#define NavigationBar_Item_h


导航条是应用中很核心的一个可视空间，这里列举一些比较常用的设置导航条的方法。

1. 设置导航条上可视元素背景颜色方法：

    /// 1.1 设置Bar背景颜色 以及默认BarItem的颜色
    [self.navigationBar setBarTintColor:RGBCOLOR_HEX(0xf95900)];
    [self.navigationBar setTintColor:[UIColor whiteColor]];

    /// 1.2全局设置
    UINavigationBar.appearance().barTintColor = UIColor(red: 242.0/255.0, green: 116.0/255.0, blue: 119.0/255.0, alpha: 	1.0)
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()


2. 设置导航条上的 字体颜色方法
    /// 2.1 设置导航条上的字体颜色
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:24],NSFontAttributeName, nil];
    [self.navigationBar setTitleTextAttributes:attributes];

    /// 2.2 全局设置方法
    if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), 		NSFontAttributeName:barFont]
    

3. iOS 7 之后，导航条默认的半透明状态设置
    /// 如果是YES， 默认状态是YES VC的子视图的y_0点将默认可视区域上移44，改为NO之后，VC的姿势图的y_0点将是导航条的y_0点。
    [self.navigationBar setTranslucent:YES];
        
        
4. 取消Push子视图默认返回导航BackItem的文字
        ///注意：VC_A.nav pushTo VC_B  那么代码需要写在VC_A中。
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        
5. iOS 8 之后，导航控制器之间，在滑动导航时候隐藏导航条（“Hiding a Navigation Bar on Swipe）
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            
            navigationController?.hidesBarsOnSwipe = false
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        
6. iOS 7，可以为每一个VC 单独更改状态栏样式
        /// 只需要在VC.m 中实现方法
        override func preferredStatusBarStyle() -> UIStatusBarStyle {
            return .LightContent
        }
        /// 也可以全局的设置 两种方法  首先是代码
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        /// 然后是plist文件修改：
        Under the Info tab of the OBJect target, insert a new key named View controller-based status bar appearance and set the value to NO
        
7. 自己添加一个UIBarButtomItem
        ///直接上代码
        @class CNBarButtonItem;
        
        typedef void(^BBIBlock)(CNBarButtonItem *barBItem);
        
        @interface CNBarButtonItem : UIBarButtonItem
        
        
        - (instancetype)barMenuButtomItem;
        - (instancetype)barButtomItem:(NSString *)title;
        
        - (void)barBlock:(BBIBlock )thisBlock;
        
        ========.h   下面是实现文件 -->.m
        @implementation CNBarButtonItem{
            BBIBlock _bbiBlock;
        }
        
        
        - (instancetype)barButtomItem:(NSString *)title {
            UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
            [itemButton addTarget:self action:@selector(barItemEvent:) forControlEvents:UIControlEventTouchUpInside];
            [itemButton setTitle:title forState:UIControlStateNormal];
            [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            itemButton.size = [self sizeOfBtn:itemButton];
            return  [self initWithCustomView:itemButton];
        }
        
        
        - (CGSize)sizeOfBtn:(UIButton *)btn
        {
            CGSize sizeBtn = [btn.titleLabel sizeThatFits:CGSizeMake(100,30)];
            CGSize sizeReal    = CGSizeMake(sizeBtn.width + 10, 40);
            CGSize minSize     = CGSizeMake(40, 40);
            CGSize lastSize    = sizeBtn.width + 10  > 40 ? sizeReal : minSize;
            return lastSize;
        }
        
        
        - (void)barItemEvent:(UIButton *)btn {
            if (_bbiBlock) {
                _bbiBlock(self);
            }
        }
        
        - (void)barBlock:(BBIBlock)thisBlock {
            _bbiBlock = thisBlock;
        }
        
        =================DestVC_中使用如下
        CNBarButtonItem *editItem = [[CNBarButtonItem alloc] barButtomItem:@"Edit"];
        [editItem barBlock:^(CNBarButtonItem *barBItem) {
            NSLog(@"Edit Click");
            //        [self showChannelSetView];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            CNNewsDetailViewController *_newsDetail = [[CNNewsDetailViewController alloc] init];
            [self.navigationController pushViewController:_newsDetail animated:YES];
        }];
        UIBarButtonItem *rightSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        rightSpaceItem.width =  iPhone6Plus? -15:-8;
        self.navigationItem.rightBarButtonItems = @[rightSpaceItem,editItem];
        
        
        --------------------------------------------------
        
        
        
        
        

#endif /* NavigationBar_Item_h */
