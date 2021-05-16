# CCInput 
第三方输入法App开发原理调研及Demo

> 前言
>
> 为啥我一个做社交、直播、图片后编辑方向的iOS开发突然想学输入法开发呢，这一切还得从我看到搜狗输入法的招聘JD说起....
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
> 3. 输入法类App原理
> 4. 输入法App和逆向(个人瞎猜，可能鲁迅人本身根本没这么想)

# 1. 调研着手
#### 1.1 砸壳
因为了解输入法App的念头起源于`逆向`，所以此处我先砸壳，看看什么发现...

在砸完`搜狗输入法`壳后，看ipa内部的文件，我并没有看到与其它App有什么区别，无非是`icon资源`,`infoPlist`,`.mpa资源`,`Frameworks`、`lottie json文件夹`、`开启完全访问的.mp4教程`、`MJRefresh等第三方库`、`/PlugIns/SogouAction.appex`以及`mach-o`。

通过ipa，我发现两个关键点:
1. 搜狗工程师比较喜欢用plist做配置类数据存储(这点我觉得挺挺好的,便于管理，当然用.json也没问题)
2. 在`plugins`路径下，有一个`SogouAction.appex`文件，`.appex`一般是iOS`拓展Extension`生成的文件，比如接入`NotificationService`同样会生成`push.appex`文件

此时，我对`百度输入法`同样进行砸壳操作，发现在`PlugIns`文件夹下，同样有`BaiduInputMethod.appex`、`NotificationContent.appex`这两个.appex结尾的文件

此时根据直觉，我觉得输入法类App的关键在添加了一个类似于`inputKeyboard`的拓展`Extension`实现

#### 1.2 class-dump
头文件里搜索了`SogouAction`仍然一无所获

#### 1.3 Reveal
简单看了下搜狗的UI架构，想通过Reveal看看能不能找出对应的class，结果不但没找到，Reveal里压根没显示出来键盘的UI(键盘是系统层UI，所有Reveal不到)。想到我们的目标是了解如何开发一个输入法App。此时我们暂时停止逆向，直接去百度...

#### 1.3 利用搜索引擎
百度搜到的东西很少，大多是检测键盘弹出高度，只搜到关键性的三篇文章：

[Keyboards and Input](https://developer.apple.com/documentation/uikit/keyboards_and_input)

[iOS输入法_开发系统架构](https://www.jianshu.com/p/f2d6c6e70f12)

[iOS输入法开发(Swift)](https://blog.csdn.net/SHZnt/article/details/50585706)

其中文章一是苹果官方文档,主要讲构建输入法App用到的API
其中文章二主要将输入法App的App架构与通信，通过此文章我们大概知道为什么搜狗的iOS需要逆向经验
其中文章三是构建一个简单的输入法App
我决定跟着文章三开发一个简单的App，了解其原理

# 2. App搭建

#### 2.1 创建一个名为InputApp的项目（为了练练手，我们采用OC编码，与链接内不同，后续我应该会创建Swift版本上传Github）
<center class="half">
    <img src="https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/eed20d38c25a481ea8b650cf3d12ba37~tplv-k3u1fbpfcp-watermark.image" width="800"/>
</center>

#### 2.2 创建键盘Target

拓展Target命名为`CustomKeyboard`
<center class="half">
    <img src="https://github.com/MTerence/CCInput/blob/main/InputApp/Resource/c00bca112c6c4363ace5c8467af9e660%7Etplv-k3u1fbpfcp-watermark.png" width="800"/>
</center>

弹出`Activate “CustomKeyboard” scheme?` 选择`activate`

此时我们注意到，添加CustomKeyboard后，默认生成了一个类`KeyboardViewController`
<center class="half">
    <img src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a3fa6a1f237e4718b83eb0f95c853659~tplv-k3u1fbpfcp-watermark.image" width="800"/>
</center>

!!! 注意一个很容易忽视的问题：记得修改`CustomKeyboard` Target支持的最低版本，如果支持的最低版本高于设备版本，xcode编译时不会报错，但运行时这个target不会运行,添加`NotificationService时同样`有这个容易忽视的问题

此时我们启动App，在设置-通用-键盘-添加键盘里能看到我们的自定义键盘，同时，也有开启完全访问的选项

<center class="half">
    <img src="https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cd521dabf02e448f9c5e13561773e081~tplv-k3u1fbpfcp-watermark.image" width="300"/>
    <img src="https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c0064cb4727d40d8b0fc809060529240~tplv-k3u1fbpfcp-watermark.image" width="300"/> 
    <img src="https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5c3fc8f9bb244e5aa16fb69c8064c84e~tplv-k3u1fbpfcp-watermark.image"
    width = "300">
</center>


添加键盘后，我们将键盘切换到我们自定义的键盘，任意App内调起键盘可以看到如图

<center class="half">
    <img src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/79496fdbb6cc435b9a24de9928df0e44~tplv-k3u1fbpfcp-watermark.image" width="300"/> 
    <img src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/38a51d7209194ab1a071807cb8146a25~tplv-k3u1fbpfcp-watermark.image" width="300"/>
</center>

此时弹出我们的自定义键盘，可以看到，键盘有一个添加Extension时默认生成代码的button。我们将会在`KeyboardViewController`类里做键盘的自定义布局

# 2.3 键盘UI布局 
我把源码上传到了Github
[CCInput](https://github.com/MTerence/CCInput)

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

主要是UI和数据结构，此处不深入探究，感兴趣请看demo，此处有个自定义键盘高度的坑注意下:
> 1. 通过简单的setframe无法更改键盘默认高度
> 2. 需要通过设置`NSLayoutConstraint`的方式，切在viewDidLoad方法中设置无效
> 3. 需在`viewDidAppear`之前设置键盘高度

这个问题的解决方案因为国内做键盘的公司比较少，百度搜索不到相关资料，附上stackoverflow链接
[stackoverflow: iOS 8 Custom Keyboard: Changing the Height](https://stackoverflow.com/questions/24167909/ios-8-custom-keyboard-changing-the-height/25819565#25819565)

![Demo效果.gif](https://github.com/MTerence/CCInput/blob/main/InputApp/Resource/ScreenRecording_05-16-2021%2015-47-24.gif)

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

# 3. 输入法类App原理

#### 3.1 主程序与键盘拓展的关系
![图源自网络](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3ae79b08000e4bb7a68716fc4b2f5666~tplv-k3u1fbpfcp-watermark.image)

第三方输入法，分为主程序(containing App)、键盘(extension)， 分别对应Demo中的`InputApp`、`CustomKeyboard`, 主程序在桌面可见，Host App则是使用输入法的其它App, 
> - 主程序和键盘Extension正常情况是无法共享数据的(沙箱隔离)
>
> - 在开启完全访问时，主程序和键盘Extension可以共享数据(通过app groups)
>
> - 主程序和Host App无法共享数据(沙箱隔离)
>
> - 键盘Extension和Host App只能共享文本数据(通过系统UITextDocumentProxy)


#### 3.2 完全访问
在设置-通用-键盘中，苹果有对完全访问做说明，摘录如下
> 第三方键盘提供了另一种途径来键入键盘数据。这些键盘可以访问您键入的所有数据，包括银行账户、信用卡号码、街道地址及其他个人信息与敏感信息。这些键盘还可能访问相邻文本及数据，这些信息对改进自动更正功能卓有帮助。
>
> 如果您启用“完全访问”，开发者即获得许可访问、收集与传输您键入的数据。此外，如果附带键盘的第三方应用程序获得您的许可访问地理位置信息、照片、或其他个人数据，那么此键盘也可收集并将该信息传输至键盘开发者的服务器上。如果您停用某第三方键盘的“完全访问”，之后再重新启用，那么键盘开发者则可能能够访问、收集并传输网络访问禁用期间所键入的信息。
>
> 如果您不启用“完全访问”，那么开发者则不可收集与传输您键入的数据。未经您许可，任何未授权的数据收集或传输行为均违反其开发者协议。此外，技术限制同样在防止未经许可的访问方面起作用。任何试图破坏此类限制的尝试同样违反开发者协议。
>
> 你任何时候均可选择停用第三方键盘。打开“设置”，轻点“键盘”，将该键盘从键盘列表中移除即可。
>
> 如果您使用第三方键盘，即需遵守键盘开发者的条款、隐私政策及做法。使用此类键盘App与服务之前，您应仔细阅读其条款、隐私政策和做法，以了解他们如何使用您的数据及其他信息。

总结就是，只有开启了完全访问，输入法App才能:
- 访问、收集、传输输入的数据
- 访问并上传位置、照片、个人数据(通讯录之类权限隐私数据)
- 如果开启之后又关闭，那么开发者还是能够传输禁用期间的数据
- 如果不开启，那么因为苹果的技术限制(沙箱)，开发者并不能上传键盘Extension获取到的数据

#### 3.3 App Groups数据共享
[官方文档：Sharing Data with Your Containing App](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html#//apple_ref/doc/uid/TP40014214-CH21-SW6)


![app_extensions_container_restrictions_2x.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1d204b2d3dd045f79c35a5d073bd70b4~tplv-k3u1fbpfcp-watermark.image)


简单来说，开启了app groups，相当于生成一个中间数据共享区(shared container)来将`App's container`和`Extension's container`的数据关联并共享

通过以下方式就可以共享数据
```
// Create and share access to an NSUserDefaults object
NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName: @"com.example.domain.MyShareExtension"];
 
// Use the shared user defaults object to update the user's account
[mySharedDefaults setObject:theAccountName forKey:@"lastAccountName"];
```

# 4 输入法App和逆向(个人瞎猜，可能鲁迅人本身根本没这么想)

通过上文`3.1` `3.2` `3.3`我们知道, 主App和Extension之间要想共享数据，必须开启完全访问通过App Groups的方式共享数据,对于一款键盘类App，他肯定是希望App和Extension能实现数据共享，以达到以下需求:

- 实时更新网络高频热词，用于联想输入
- 共享键盘皮肤
- 存储用户高频输入的词汇、通讯录等数据,上传服务端，当用户换设备时，能同步并共享给新设备的Extension

但是由于沙箱的限制，如果用户没有开启完全访问，以上三点需求就达不成了。事实上以上三点需求对我这样的用户来说非常重要，无缝衔接切换设备的快感是无法形容的，比如当我在iPhone上输入`ma`后，我选择了联想词汇表中的`码代码的小马`，然后当我在mac上使用搜狗输入法同样输入`ma`,mac也联想到了`码代码的小马`，这样会将我的输入效率提高很多

此时就用到了逆向技术
苹果有沙箱隔离，逆向里有沙箱逃脱(沙箱逃脱详细解释请参考我之前文章[沙箱逃脱](https://juejin.cn/post/6962098625723760654))

沙箱逃脱简单来说就是跨进程访问数据共享数据,放在这里就是，即使用户不开启完全访问，主App也能访问Extension的数据，以实现如上三点需求。 

只是目前沙箱逃脱技术只能在越狱设备实现，也许未来某一天某个大牛实现了在未越狱设备的沙箱逃脱，那对于逆向开发者来说，简直是这盛世如你所愿，大好河山任你看...

