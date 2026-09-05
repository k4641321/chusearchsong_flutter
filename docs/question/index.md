# 常见问题

## 落雪Token在哪获取
点击这个链接 https://maimai.lxns.net/user/profile?tab=thirdparty  
划到最下面，有一个叫***个人 API 密钥***的东西就是落雪Token了
  
## 苹果自签教程

### 一、准备工作

在开始之前，请确认你手上有这些东西：

- 一台电脑（Windows 7及以上或 macOS 10.12及以上）
- 一台iPhone/iPad（iOS 7及以上均可）
- 一根能用的数据线（能给你的设备充上电就行，当然原装的最好）
- 一个Apple ID（普通免费账号即可）
- 你要安装的IPA文件（请从可信来源获取）

### 二、下载并安装必要软件

#### 0. 怎么看自己电脑是多少位的（Windows）

1. 键盘按下 `Win + Pause/Break` 快捷键，直接打开系统信息页面。
2. 或者右键点击【此电脑】→【属性】。
3. 在弹出的系统窗口中，找到 **系统类型**，即可看到：`64位操作系统` / `32位操作系统`。

> 提示：现在绝大多数新电脑都是64位系统。

#### 1. 下载并安装iTunes（Windows用户必做）

⚠️ 重要提示：Windows用户必须安装苹果官网下载的iTunes版本，不能用Microsoft Store里面下载的版本。如果你已经安装了Microsoft Store版，请先卸载，再按下面的步骤安装官网版。

下载地址：

- 64位Windows：[https://www.apple.com/itunes/download/win64](https://www.apple.com/itunes/download/win64)
- 32位Windows：[https://www.apple.com/itunes/download/win32](https://www.apple.com/itunes/download/win32)

下载完成后双击安装包，一路点击"下一步"完成安装即可。

Mac用户：macOS系统已自带相关组件，不需要额外安装iTunes。

#### 2. 下载并安装Sideloadly

官方下载地址：[https://sideloadly.io/](https://sideloadly.io/)

根据你的操作系统选择对应的版本：

- Windows 64位：[https://sideloadly.io/SideloadlySetup64.exe](https://sideloadly.io/SideloadlySetup64.exe)
- Windows 32位：[https://sideloadly.io/SideloadlySetup32.exe](https://sideloadly.io/SideloadlySetup32.exe)
- macOS：[https://sideloadly.io/SideloadlySetup.dmg](https://sideloadly.io/SideloadlySetup.dmg)

下载完成后：

- Windows：双击安装包，按提示完成安装
- macOS：打开.dmg文件，将Sideloadly拖入Applications文件夹

安装完成后，在桌面或应用程序中找到Sideloadly的图标，右键选择**以管理员身份运行**（Windows）或直接双击打开（macOS）。首次打开时软件可能会提示下载Anisette组件，点击`Yes`确认即可。

### 三、连接手机与电脑

1. 用数据线将iPhone/iPad连接到电脑的USB接口
2. 首次连接时，手机上会弹出"要信任此电脑吗？"的提示，点击**信任**
3. 如果手机有锁屏密码，输入密码确认
4. 打开Sideloadly，在软件界面的`iDevice`区域应该能看到你的设备名称和型号信息——这说明连接成功了

> 如果没显示设备：检查数据线是否插好，或者重新拔插一下。也可以先打开iTunes看看能不能识别到你的手机。

### 四、导入IPA文件

在Sideloadly软件界面中：

- 直接将你的IPA文件拖拽到软件左上角的方框（或带文档图标的区域）里
- 或者点击该区域的图标，在弹窗中选择你的IPA文件

拖入成功后，方框底部会显示该应用的名称。

### 五、输入Apple ID

1. 在Sideloadly界面中找到`Apple Account`或`Apple ID`输入框
2. 输入你的Apple ID账号（邮箱地址）
3. 点击下方的`Start`按钮
4. 软件会弹窗要求输入Apple ID密码，输入后点击`OK`

> 关于双重认证：如果你的Apple ID开启了双重认证，输入密码后手机可能会收到验证码，将验证码输入到Sideloadly的提示框中即可。
>
> 建议：可以专门注册一个新的Apple ID用来做签名，避免主账号的安全风险。

### 六、等待安装完成

点击`Start`后，Sideloadly会开始为IPA签名并安装到你的手机上。这个过程可能需要几十秒到几分钟，请耐心等待。

软件界面下方的日志区域会显示安装进度。看到类似`Installation Complete`或`Done`的提示时，说明安装成功了。

### 七、在手机上信任该应用（关键步骤！）

安装完成后，不要直接点开应用——此时打开会提示"未受信任的开发者"。你需要先在手机设置中信任它。

操作步骤：

1. 打开iPhone的**设置**App
2. 往下滑，找到**通用**并点击进入
3. 再往下滑，找到**VPN与设备管理**并点击进入

> 注意：如果你的手机系统是iOS 15或更早的版本，这个选项叫**描述文件与设备管理**

4. 在**开发者App**区域，找到你刚才输入的那个Apple ID邮箱
5. 点击进入，然后点击**信任**按钮
6. 在弹出的确认框中再次点击**信任**

完成以上操作后，回到手机桌面，就可以正常打开并使用刚才安装的应用了。  
  
## 阿里云accessKeyId与accessKeySecret获取
### 一、前往阿里云机器翻译控制台开通机器翻译
点击直达 https://mt.console.aliyun.com/basic
  
### 二、创建阿里云RAM账号
点击直达 https://ram.console.aliyun.com/overview?activeTab=workflow  
1. 在**创建程序用户AccessKey**里选择***用于程序访问的超级用户***  
2. **登录名称**随便输入一个，划到最下面，点击**执行配置**  
3. 接着点击**身份管理**里的**[用户](https://ram.console.aliyun.com/users)**  
4. 点击**新增授权**，搜索***机器翻译***，勾选**AliyunMTFullAccess**，点击下面**确认新增授权**
5. 请务必牢记你的**AccessKey ID**和**Access Key Secret**，该页面关闭后将无法再次查看。
### 三、在软件里设置
回到软件里，设置 - 翻译设置 - 输入，保存

## 软件初次启动下载很久
在v0.20.0到0.21.0之间，或者v0.19.0也可能有，因为石山代码没测试初次启动，软件已经报错了，但又由于flutter的特性不会崩掉  
还有一种原因是最新最热歌曲下载太慢，新版本已经移除在第一次启动时下载最新最热歌曲
### 解决方法
直接按返回键关闭更新窗口，然后切换到**关于界面**，点击**更新数据**，**更新基础数据**  
