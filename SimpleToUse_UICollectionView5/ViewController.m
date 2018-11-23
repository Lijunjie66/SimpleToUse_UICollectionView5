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



@end
