//
//  ViewController.m
//  SimpleToUse_UICollectionView5
//
//  Created by Geraint on 2018/11/23.
//  Copyright © 2018 kilolumen. All rights reserved.
//

#import "ViewController.h"
#import "MyLayout.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建一个layout布局类
    MyLayout *layout = [[MyLayout alloc] init];
    
    // 创建collectionView 通过一个布局策略layout来创建
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 400) collectionViewLayout:layout];
    collect.delegate = self;
    collect.dataSource = self;
    collect.backgroundColor = [UIColor lightGrayColor];
    
    // 注册item类型，这里使用系统的类型 (在完成代理回调前，必须注册一个cell)
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [self.view addSubview:collect];
    
    // Masonry 布局，覆盖上面的 layout布局  -- CGRectMake(0, 0, 320, 400)
    [collect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(50, 10, 10, 10));
    }];
    
    
    // 因为咱们的环状布局，上面的逻辑刚好可以无缝对接，但是会有新的问题，一开始运行，滚轮就是出现在最后一个item的位置，而不是第一个，并且有些相关的地方，我们也需要一些适配：
    // 一开始将collectionView的偏移量设置为 1屏 的偏移量
    collect.contentOffset = CGPointMake(0, 400);
    
}


#pragma mark -- 代理方法（前两个必写）
// 分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区之中的item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

// 其实这个cell是item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random() % 255/255.0 green:arc4random() % 255/255.0 blue:arc4random() % 255/255.0 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 80)];
    label.text = [NSString stringWithFormat:@"我是第%ld行", (long)indexPath.row];   // 上面我们创建了10个item，并且在每个item上添加了一个标签，标写的是“第几行”
    [cell.contentView addSubview:label];
    return cell;
}

#pragma mark -- 让其循环滚动的逻辑 (之前所做的那些，只可以让滚轮 滚动一圈，不能无限滚动。 因此再下一步就是怎么使其循环滚动了)，代码 在ViewController中实现。。。
#pragma mark ==  我们再进一步，如果滚动可以循环，这个控件将更加炫酷，添加这样的逻辑也很简单，通过监测scrollView的偏移量，我们可以对齐进行处理，因为collectionView继承于scrollView，我们可以直接在ViewController中实现其代理方法，如下：
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 小于半屏 则放到最后一屏多半屏
    if (scrollView.contentOffset.y < 200) {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y + 10 * 400);
        
        // 大于最后一屏多一屏  返回第一屏
    } else if (scrollView.contentOffset.y > 11 *400) {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y - 10 *400);
    }
    
}




@end
