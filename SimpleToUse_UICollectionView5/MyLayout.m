//
//  MyLayout.m
//  SimpleToUse_UICollectionView5
//
//  Created by Geraint on 2018/11/23.
//  Copyright © 2018 kilolumen. All rights reserved.
//

#import "MyLayout.h"

@implementation MyLayout


#pragma mark  -- 对于.m文件的内容，前几篇博客中我们都是在prepareLayout中进行布局的静态设置，那是因为我们前几篇博客中的布局都是静态的，布局并不会随着我们的手势操作而发生太大的变化，因此我们全部在prepareLayout中一次配置完了。而我们这次要讨论的布局则不同，pickerView会随着我们手指的拖动而进行滚动，因此UICollectionView中的每一个item的布局是在不断变化的，所以这次，我们采用动态配置的方式，在layoutAttributesForItemAtIndexPath方法中进行每个item的布局属性设置。（至于 layoutAttributesForItemAtIndexPath方法 ，它也是UICollectionViewLayout类中的方法，用于我们自定义时进行重写，至于为什么动态布局要在这里配置item的布局属性，后面再说：）现在 ViewController.m 里实现代码。。。



// 在我们自定义的布局类中重写layoutAttitudesForElementsInRect，在其中返回我们的布局数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    
    // 遍历设置每个item的布局属性
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    return attributes;
}

// 在布局类中 重写 LlayoutAttitudesForItemAtIndexpath: 方法
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 创建一个item布局属性类
    UICollectionViewLayoutAttributes *atti = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // 获取item的个数
    int itemCount = (int)[self.collectionView numberOfItemsInSection:0];
    // 设置每个item的大小
    atti.size = CGSizeMake(260, 100);
    
    /**
            . 下面我们一步步来实现3D的滚轮效果
          .. ..
           ...
     */
    //
    
    return atti;
}


@end
