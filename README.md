# CCInput
一个简单的输入法键盘App Demo

> 前言
>
> 为啥我一个做社交、直播、图片后编辑方向的iOS开发突然想学输入法开发呢，这一切还得从我给搜狗投了份简历说起....
>
>我看到搜狗输入法的招聘里写到一条：`了解逆向优先`,此时我有个疑问，做输入法App开发和逆向有什么关系? 于是就有了想了解输入法App开发的兴趣，也就有个这篇文章
> 
> 首先在写这个前言的时候，我是压根不知道输入法怎么开发的。当想到要做一个输入法App时，我有如下疑问
>> 1. 为什么安装了搜狗输入法App后，系统键盘设置里会出现搜狗输入法，且有完全访问的选项(UISwith)，完全访问是做什么的？
>> 2. 为什么安装了搜狗输入法App后，在我自己的App里调起输入法后，调起的是第三方的搜狗输入法键盘
>> 3. 搜狗输入法App和搜狗输入法键盘两者之间有什么关联？ 如何关联？
>> 4. 第三方输入法和逆向之间有什么关联？逆向知识能为输入法类App带来什么?

如果你也有以上疑问，请耐心看下去(其实写到此处时能不能解答我也不知道...)

本文目录:
> 1. 调研着手
> 2. App实现(简单实现一个能在其它App内使用的输入法App)
> 3. 

# 1. 调研着手
#### 1.1 砸壳
在了解一款App怎么做之前，当然是先砸壳，看看有啥东西...

在砸完`搜狗输入法`壳后，看ipa内部的文件，我并没有看到与其它App有什么区别，无非是`icon资源`,`infoPlist`,`.mpa资源`,`Frameworks`、`lottie json文件夹`、`开启完全访问的.mp4教程`、`MJRefresh`、`/PlugIns/SogouAction.appex`以及`mach-o`
通过ipa，我发现两个关键点:
1. 搜狗工程师比较喜欢用plist做配置类数据存储(这点我觉得挺挺好的,便于管理，当然用.json也没问题)
2. 在`plugins`路径下，有一个`SogouAction.appex`文件，`.appex`一般是iOS拓展Target生成的文件，比如接入`NotificationService`同样会生成`push.appex`文件

此时，我对`百度输入法`同样进行砸壳操作，发现在`PlugIns`文件夹下，同样有`BaiduInputMethod.appex`、`NotificationContent.appex`这两个.appex结尾的文件

此时根据直觉，我觉得输入法类App的关键在添加了一个类似于`input`的拓展target实现

#### 1.2 class-dump
搜索了`SogouAction`仍然一无所获，想到我们的目标是正向开发一个App。此时我们暂时停止逆向，去百度...

#### 1.3 利用搜索引擎
我搜关键性的三篇文章：

[Keyboards and Input](https://developer.apple.com/documentation/uikit/keyboards_and_input)

[iOS输入法_开发系统架构](https://www.jianshu.com/p/f2d6c6e70f12)

[iOS输入法开发(Swift)](https://blog.csdn.net/SHZnt/article/details/50585706)

其中文章一是苹果官方文档,主要讲构建输入法App用到的API
其中文章二主要将输入法App的App架构与通信，通过此文章我们大概知道为什么搜狗的iOS需要逆向经验
其中文章三是构建一个简单的输入法App
我决定跟着文章三开发一个简单的App，了解其原理

# 2. App搭建

#### 3.1 创建一个名为InputApp的项目（为了练练手，我们采用OC编码，与链接内不同，后续我应该会创建Swift版本上传Git）

![创建项目](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/eed20d38c25a481ea8b650cf3d12ba37~tplv-k3u1fbpfcp-watermark.image)

#### 3.2 创建键盘Target

拓展Target命名为`CustomKeyboard`

![CustomKeyboard](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c00bca112c6c4363ace5c8467af9e660~tplv-k3u1fbpfcp-watermark.image)

弹出`Activate “CustomKeyboard” scheme?` 选择`activate`

此时我们注意到，添加CustomKeyboard后，默认生成了一个类`KeyboardViewController`

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a3fa6a1f237e4718b83eb0f95c853659~tplv-k3u1fbpfcp-watermark.image)

!!!注意一个很容易忽视的问题：记得修改`CustomKeyboard` Target支持的最低版本，如果支持的最低版本高于设备版本，xcode编译时不会报错，但运行时这个target不会运行,添加`NotificationService时同样`

此时我们启动App，在设置-通用-键盘-添加键盘里能看到我们的自定义键盘，同时，也有开启完全访问的选项

<center class="half">
    <img src="https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cd521dabf02e448f9c5e13561773e081~tplv-k3u1fbpfcp-watermark.image" width="200"/> <> <img src="https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c0064cb4727d40d8b0fc809060529240~tplv-k3u1fbpfcp-watermark.image" width="200"/> <> <img src="https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5c3fc8f9bb244e5aa16fb69c8064c84e~tplv-k3u1fbpfcp-watermark.image"
    width = "200">
</center>
添加键盘后，我们将键盘切换到我们自定义的键盘，任意App内调起键盘可以看到如图

<center class="half">
    <img src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/79496fdbb6cc435b9a24de9928df0e44~tplv-k3u1fbpfcp-watermark.image" width="200"/> <> <img src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/38a51d7209194ab1a071807cb8146a25~tplv-k3u1fbpfcp-watermark.image" width="200"/>
</center>

此时弹出我们的自定义键盘，可以看到，键盘有一个添加Target时默认生成代码的button。我们在`KeyboardViewController`类里做键盘的自定义布局

# 3.3 键盘UI布局 
[Objective-C Demo地址]()

键盘的UI布局我以简单以搜狗输入法的数字键盘为例，这里附上代码说明，具体请查看Demo代码
> `KeyboardViewController` 创建keyboard extension时，系统自动创建的vc，继承自`UIInputViewController`,键盘的布局、逻辑处理都在此类中
>
> `CCLeftTableView` 左侧符号输入，是一个TabView,，支持增加符号数据源
>
> `CCCenterView` 中间数字键盘及底部切换、数字0、空格功能
>
> `CCRightView` 右侧删除、句号、@符号、换行功能
>
> `CCKeyboardModel` 键盘数据源Model，Model有两个属性，分别是
>> `NSString *string` 用于键盘按钮文本的展示
>> `CCKeyboardAction keyboardAction` 是点击事件的枚举类型，点击键盘的时候通过此属性统一处理
>>
>> 简单的写了个通过runtime自动获取属性解析json为model的方法

键盘的布局基本是UI和数据结构，此处不深入探究，感兴趣请看demo，此处有个自定义键盘高度的坑注意下:
> 1. 通过简单的setframe无法更改键盘默认高度
> 2. 需要通过设置`NSLayoutConstraint`的方式，切在viewDidLoad方法中设置无效
> 3. 需在`viewDidAppear`之前设置键盘高度

这个问题的解决方案因为国内做键盘的公司比较少，百度搜索不到相关资料，附上stackoverflow链接
[stackoverflow: iOS 8 Custom Keyboard: Changing the Height](https://stackoverflow.com/questions/24167909/ios-8-custom-keyboard-changing-the-height/25819565#25819565)


[Demo下载]()

![Demo效果.gif](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/861d3a744fa845269058c03639f77225~tplv-k3u1fbpfcp-watermark.image)

同时附上Demo中代码

```

static CGFloat KEYBOARDHEIGHT = 256;

@interface KeyboardViewController ()
<CCTopBarDelegate,
CCLeftViewDelegate,
CCCenterViewDelegate,
CCRightViewDelegate>


/// 用于设置键盘自定义高度
@property (nonatomic, assign) NSLayoutConstraint *heightConstraint;

@end

@implementation KeyboardViewController

- (void)prepareHeightConstraint {
    if (self.heightConstraint == nil) {
        UILabel *dummyView = [[UILabel alloc] initWithFrame:CGRectZero];
        dummyView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:dummyView];
        
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:KEYBOARDHEIGHT];
        self.heightConstraint.priority = 750;
        [self.view addConstraint:self.heightConstraint];
    } else {
        self.heightConstraint.constant = KEYBOARDHEIGHT;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareHeightConstraint];
}

/// 重写的父类方法，苹果建议在此处updateViewConstraints
- (void)updateViewConstraints {
    [super updateViewConstraints];

    if (self.view.frame.size.width == 0 && self.view.frame.size.height == 0) {
        return;
    }
    [self prepareHeightConstraint];
}
```

UIInputViewController 涉及到的方法说明:
- `advanceToNextInputMode` 切换到下一个输入法
- `dismissKeyboard` 退出键盘（相当于`resignFirstResponder`）
- `insertText` 插入文本(尾部)
- `deleteBackward` 删除输入框内上一个文本
