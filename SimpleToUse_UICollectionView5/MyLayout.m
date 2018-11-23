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
    int itemCounts = (int)[self.collectionView numberOfItemsInSection:0];
    // 设置每个item的大小为 260*100
    atti.size = CGSizeMake(260, 100);
    
    
    
    /**
            . 下面我们一步步来实现3D的滚轮效果
          .. ..
           ...
     */
    // 首先，我们先将所有的item的位置都设置为collectionView的中心
    atti.center = CGPointMake(self.collectionView.frame.size.width / 2, self.collectionView.frame.size.height / 2 +self.collectionView.contentOffset.y);  // 将上面的布局的中心点设置加上一个动态的偏移量 +self.collectionView.contentOffset.y
    
    //  之后, 我们来设置每个item的3D效果 , 在上面的布局方法中添加如下代码:
    // 创建一个transform3D类
    // CATransform3D是一个类似矩阵的结构体
    // CATransform3DIdentity创建空的矩阵
    CATransform3D trans3D = CATransform3DIdentity;
    // 这个值设置的是透明度，影响视觉离投影平面的距离
    trans3D.m34 = -1 / 900.0;
    
    // 下面这些属性  后面会具体介绍
    // 这个是3D滚轮的半径
    CGFloat radius = 50 / tanf(M_PI * 2 / itemCounts / 2);
    
    // 获取当前的偏移量
    float offset = self.collectionView.contentOffset.y;
    // 计算每个item应该旋转的角度
    //    CGFloat angle = (CGFloat)(indexPath.row) / itemCounts * M_PI * 2;
    // 在角度设置上，添加一个偏移角度
    float angleOffset = offset/self.collectionView.frame.size.height;
    CGFloat angle = (float)(indexPath.row + angleOffset - 1) / itemCounts * M_PI * 2;
    
    
    
    // 这个方法返回一个新的CATransform3D对象，在原来的基础上进行旋转效果的追加
    // 第一个参数为旋转的弧度，后三个分别对应x,y,z轴，我们需要以x轴为中心进行旋转
    trans3D = CATransform3DRotate(trans3D, angle, 1.0, 0, 0);
    // 进行设置
    atti.transform3D = trans3D;
    
    // 这个方法也返回一个transform3D对象，追加平移效果，后面三个参数，对应平移的x，y，z轴，我们沿着z轴平移
    trans3D = CATransform3DTranslate(trans3D, 0, 0, radius);
    atti.transform3D = trans3D;  // 进行设置
    
    return atti;
}

#pragma mark -- 上面的是 静态布局 ，下面我们要想让 滚轮滑动起来
// 首先，我们需要z给collectionViewu一个滑动范围，我们以一屏collectionView的滑动距离来当做滚轮滚动一下的参照，我们在布局类中的如下方法中h返回滑动区域:
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height * ([self.collectionView numberOfItemsInSection:0] + 2));
}

// 上面方法写完之后，我们的collectionView已经可以进行滑动，但是并不是我们想要的效果，滚轮并没有f滚动，而是随着滑出了屏幕，因此，我们需要在滑动的时候不停的动态布局，将滚轮始终固定在collectionView的中心，先需要在布局类中实现如下方法：
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

// （在上面的布局中心点，添加上一个动态的偏移量之后），现在在运行，会发现滚轮会随着滑动始终固定在中间，但是还是不如人意，滚轮并没有转动起来，我们还需要动态的设置每个item的旋转角度，这样连续看起来，滚轮就转了起来，在上面设置布局的方法中，我们在添加一些处理：即(//获取当前的偏移量 ；//在角度设置上，添加一个偏移角度)

#pragma mark -- 让其循环滚动的逻辑 (之前所做的那些，只可以让滚轮 滚动一圈，不能无限滚动。 因此再下一步就是怎么使其循环滚动了)，代码 在ViewController中实现。。。





@end
