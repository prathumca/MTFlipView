MTFlipView
===========================================

using to make view transation animation. It can use for many types of animations such as the type of FlipBoard.


ScreenShot
===========================================

![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/iOS-模拟器屏幕快照“2012-7-21-上午12.51.08”.png)
![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/iOS-模拟器屏幕快照“2012-7-21-上午12.50.19”.png)
![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/iOS-模拟器屏幕快照“2012-7-21-上午12.50.16”.png)
![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/iOS-模拟器屏幕快照“2012-7-21-上午12.50.30”.png)

How to use
===========================================

1, Get code:```git clone https://github.com/dbsGen/MTFlipView.git```.

2, Make a ```MTDragFlipView```, such as : ```[[MTDragFlipView alloc] initWithType:MTFlipViewTypeUpAbove]```.

What is the ```MTFlipViewTypeUpAbove```?

```MTDragFlipView``` has 3 types:

    typedef enum {
      MTFlipViewTypeUpAbove,
      MTFlipViewTypeDownAbove,
      MTFlipViewTypeShowAbove
    } MTFlipViewType;
    
```MTFlipViewTypeUpAbove```:The view with small index is in the above.

![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/upabove.png)

```MTFlipViewTypeDownAbove```:The view with large index is in the above.

![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/downabove.png)

```MTFlipViewTypeShowAbove```:The showing view is in the above.

![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/showabove.png)

3, The delegate.

    //  return the subview at index, can reuse.
    - (UIView*)flipView:(MTDragFlipView*)flipView subViewAtIndex:(NSInteger)index;
    
    //  return number of subviews.
    - (NSInteger)numberOfFlipViewPage:(MTDragFlipView*)flipView;
    
    //  return the animation view at index, could reuse by using
    //  -dequeueReusableViewWithIdentifier:
    - (MTFlipAnimationView*)flipView:(MTDragFlipView*)flipView dragingView:(NSInteger)index;
    
The above 3 method must be implemented. Refer my demos.

4, ```MTFlipAnimationView```

The rendering of ```MTFlipAnimationView```:Because of saving memory and
asynchronous rendering, so I make the real interactive interface to be reused. 
The other side,  there is a animation to show the animations, It would showed 
when draging.

```-mainQueue``` is the rendering asynchronous queue. Each subclass will be
dealing deferent queue. And all the instances of the same class use the same
queue.

```-startRender:``` use to render image. You can invoke it after get datas.
block is how to render the image.

```-renderedImage``` receive the rendered image.

The animation of ```MTFlipAnimationView```:implement your animations.

- what is the ```percent```?
- ```percent``` is used to mark the state of the animation.
- When draging the view down, ```percent``` will be changed from 0 to -1
- Example: when not draging, ```percent``` the showing view is 0 ，the previous
- is 1,the next is -1.

```-setPercent:isBorder:``` invoked when the view of index 0 and also draging it down.
And set the percent of a new added view.

```-setAnimationPercent:preview:nextview:``` invoked when draging.Used to changed 
views.

    -turnPreviousPreview:nextview:overblock:
    -turnNextPreview:nextview:overblock:
    -restorePreview:nextview:overblock:
    -restoreAndShake:

The method to do each animation and when the animation over invoke the ```block```.
