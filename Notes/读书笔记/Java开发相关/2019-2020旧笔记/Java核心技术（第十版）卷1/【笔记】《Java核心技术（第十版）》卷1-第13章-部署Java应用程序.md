# 第13章 部署Java应用程序



## 13.1 JAR文件



### 13.1.1 创建JAR文件

### 13.1.2 清单文件

### 13.1.3 可执行JAR文件

### 13.1.4 资源

【API】java.iang.Class 1.0：

- `URL getResource(String name)` 1.1
- `InputStream getResourceAsStream(String name)` 1.1
  找到与类位于同一位置的资源， 返回一个可以加载资源的 URL 或者输人流。 如果没有找到资源， 则返回 null , 而且不会抛出异常或者发生 I/O 错误。 

### 13.1.5 密封



## 13.2 应用首选项的存储



### 13.2.1 属性映射

【API】java.util.Properties 1.0：

- `Properties( )` 
  创建一个空属性映射。 

- `Properties ( Properties defaults ) `
  用一组默认值创建一个空属性映射。
  参数：defaults 用于查找的默认值。

- `String getProperty ( String key )`
  获得一个属性。返回与键（key）关联的值，或者如果这个键未在表中出现，则返回默认值表中与这个键关联的值，或者如果键在默认值表中也未出现，则返回null。
  参数：key 要获得相关字符串的键。

- `String getProperty(String key, String defaultValue)`
  如果键未找到，获得有默认值的属性。返回与键关联的字符串，或者如果键在表中未出现，则返回默认字符串。
  参数：key 要获得相关字符串的键
  defaultValue 键未找到时返回的字符串

- `Object setProperty(String key, String value)`

  设置一个属性。返回给定键之前设置的值。
  参数：key 要设置相关字符串的键
  value 与键关联的值

- `void load(InputStream in) throws IOException`
  从一个输入流加载一个属性映射。
  参数： in 输入流

- `void store( OutputStream out , String header )` 1.2
  将一个属性映射保存到一个输出流。
  参数： out 输出流
  header 存储文件第一行的标题 

【API】java.lang.System 1.0：

- `Properties getProperties( )`
  获取所有系统属性。应用必须有权限获取所有属性， 否则会拋出一个安全异常。
- `String getProperty( String key)`
  获取给定键名对应的系统属性。应用必须有权限获取这个属性， 否则会抛出一个安全异常。

*注释： 可以在 Java 运行时目录的 security/java.policy 文件中找到可以自由访问的系统属性名。*

### 13.2.2 首选项API

【API】java.util.prefs.Preferences 1.4：

- `Preferences userRoot( )`
  返回调用程序的用户的首选项根节点。
- `Preferences systemRoot( )`
  返回系统范围的首选项根节点。
- `Preferences node(String path )`
  返回从当前节点由给定路径可以到达的节点。 如果 path 是绝对路径 （也就是说， 以一个 / 开头，) 则从包含这个首选项节点的树的根节点开始查找。 如果给定路径不存在相应的节点， 则创建这样一个节点。
- `Preferences userNodeForPackage(Class cl )`
- `Preferences systemNodeForPackage(Class cl )`
  返回当前用户树或系统树中的一个节点， 其绝对节点路径对应类 cl 的包名。
- `String[] keys( )`
  返冋属于这个节点的所有键。
- `String get( String key, String defval )`
- `int getInt( String key, int defval )`
- `long getLong( String key, long defval )`
- `float getFloat( String key, float defval )`
- `double getDouble(String key, double defval )`
- `boolean getBoolean( String key, boolean defval )`
- `byte[ ] getByteArray( String key, byte[ ] defval )`
  返回与给定键关联的值， 或者如果没有值与这个键关联、 关联的值类型不正确或首选项存储库不可用， 则返回所提供的默认值。
- `void put( String key, String value)`
- `void putlnt( String key, int value)`
- `void putLong( String key, long value)`
- `void putFloat( String key, float value)`
- `void putDouble( String key, double value)`
- `void putBoolean( String key, boolean value)`
- `void putByteArray( String key, byte[ ] value)`
  在这个节点存储一个键 / 值对。
- `void exportSubtree( OutputStream out )`
  将这个节点及其子节点的首选项写至指定的流。
- `void exportNode( OutputStream out )`
  将这个节点 （但不包括其子节点） 的首选项写至指定的流。
- `void importPreferences( InputStream in)`
  导人指定流中包含的首选项。 

## 13.3 服务加载器

【API】java.util.ServiceLoader\<S> 1.6：

- `static <S> ServiceLoader<S> 1oad( C1ass<S> service )`
  创建一个服务加载器来加载实现给定服务接口的类。
- `Iterator<S> iterator()`
  生成一个以“ 懒” 方式加载服务类的迭代器。也就是说，迭代器推进时类才会加载。 

## 13.4 applet

### 13.4.1 一个简单的applet

【API】java.applet.Applet 1.0：

- `void init( )`
  首次加载 applet 时会调用这个方法。 覆盖这个方法， 把所有初始化代码放在这里。
- `void start( )`
  覆盖这个方法，用户每次访问包含这个 applet 的浏览器页面时需要执行的代码都放在这个方法中。典型的动作是重新激活一个线程。
- `void stop( )`
  覆盖这个方法，用户每次离开包含这个 applet 的浏览器页面时需要执行的代码都放在这个方法中。典型的动作是撤销一个线程。
- `void destroy( )`
  覆盖这个方法，用户退出浏览器时需要执行的代码都放在这个方法中。
- `void resize( int width , int height )`
  请求调整 applet 的大小。 如果能用在 Web 页面上这会是一个很不错的方法；遗憾的是，在当前浏览器中并不可用， 因为这与当前浏览器的页面布局机制有冲突。 

### 13.4.2 applet HTML 标记和属性

### 13.4.3 使用参数向applet传递信息

【API】java.applet.Applet 1.0：

- `public String getParameter( String name )`
  得到加载 applet 的 Web 页面中用 param 标记定义的一个参数值。字符串 name 是区分
  大小写的。
- `public String getAppletInfo( )`
  很多 applet 作者都会覆盖这个方法来返回关于当前 applet 作者、 版本和版权信息的字符串。
- `public String[][] getParameterInfo( )`
  可以覆盖这个方法来返回 applet 支持的一个 param 标记选项数组。每一行包含 3 项：参数名、类型和参数的描述。下面给出一个例子：
  "fps", "1-10", "frames per second"
  "repeat", "boolean", "repeat image loop?"
  "images", "url", "directory containing images"

### 13.4.4 访问图像和音频文件

【API】java.applet.Applet 1.0：

- `URL getDocumentBase( )`
  得到包含这个 applet 的 Web 页面的 URL。
- `URL getCodeBase( )`
  得到加载这个 appiet 的代码基目录的 URL。这可以是 codebase 属性引用的目录的绝对 URL , 如果没有指定， 则是 HTML 文件所在目录的 URL。
- `void play( URL url )`
- `void play( URL url , String name)`
  前一种形式会播放 URL 指定的一个音频文件。第二种形式使用字符串来提供相对于第一个参数中 URL 的一个路径。 如果未找到任何音频剪辑，那么什么也不会发生。 
- `AudioClip getAudioClip(URL url)`
- `AudioClip getAudioClip(URL url, String name)`
  第一种形式从给定 URL 得到一个音频剪辑。 第二种形式使用字符串提供相对于第一个参数中 URL 的一个路径。 如果无法找到音频剪辑， 这两个方法会返回 null。
- `Image getImage(URL url)`
- `Image getImage(URL url, String name)`
  返回封装了 URL 所指定图像的一个图像对象。 如果图像不存在， 贝立即返回 null。否
  则， 会启动一个单独的线程来加载这个图像。 

### 13.4.5 applet上下文

### 13.4.6 applet间通信

### 13.4.7 在浏览器中显示信息项

【API】java.applet.Applet 1.2：

- `public AppletContext getAppletContext ( )`
  提供 applet 的浏览器环境的一个句柄。在大多数浏览器中，可以使用这个信息控制运行这个 applet 的浏览器。
- `void showStatus(String msg)`
  在浏览器的状态栏中显示指定字符串。

【API】 java.applet.AppletContext 1.0：

- `Enumeration<Applet> getApplets()`
  返回相同上下文（也就是相同的 Web 页面）中所有 applet 的一个枚举（见第 9 章)。
- `Applet getApplet(String name)`
  返回当前上下文中有指定名的 applet; 如果不存在则返回 null。只会搜索当前 Web 页面。
- `void showDocument(URL url)`
- `void showDocument(URL url , String target)`
  在浏览器的一个框架中显示一个新 Web 页面。第一种形式中，新页面会替换当前页面。第二种形式使用 target 参数标识目标框架（见表 13-2。) 

### 13.4.8 沙箱

### 13.4.9 签名代码

## 13.5 Java Web Start

### 13.5.1 发布Java Web Start应用

### 13.5.2 JNLP API

【API】javax.jnlp.ServiceManager：

- `static String[ ] getServiceNames ( )`
  返回所有可用的服务名称。
- `static Object lookup( String name )`
  返回给定名称的服务。

【API】javax.jnlp.BasicService：

- `URL getCodeBase( )`
  返回应用程序的 codebase。
- `boolean isWebBrowserSupported( )`
  如果 Web Start 环境可以启动浏览器， 返回 true。
- `boolean showDocument( URL url )`
  尝试在浏览器中显示一个给定的 URL。 如果请求成功， 返回 true。

【API】javax.jnlp.FileContents：

- `InputStream getInputStream( )`
  返回一个读取文件内容的输入流。
- `OutputStream getOutputStream(boolean overwrite )`
  返回一个对文件进行写操作的输出流。 如果 overwrite 为 true， 文件中已有的内容将被覆盖。
- `String getName( )`
  返回文件名 （但不是完整的目录路径)。
- `boolean canRead( )boolean canWrite( )`
  如果后台文件可以读写， 返回 true。

【API】javax.jnlp.FileOpenService：

- `FileContents openFileDialog( String pathHint, String[ ] extensions )`
- `FileContents[ ] openMultiFileDialog( String pathHint, String[ ] extensions )`
  显示警告信息并打开文件选择器。返回文件的内容描述符或者用户选择的文件。 如果用户没有选择文件， 返回 null。

【API】javax.jnlp.FileSaveService：

- `FileContents saveFileDialog( String pathHint, String[ ] extensions,InputStream data, String nameHint )`
- `FileContents saveAsFileDialog ( String pathHint , String[ ] extensions , FileContents data )`
  显示警告信息并打开文件选择器。 写人数据， 并返回文件的内容描述符或者用户选择的文件。如果用户没有选择文件， 返回 null。

【API】javax.jnlp.PersistenceService：

- `long create( URL key, long maxsize)`
  对于给定的键创建一个持久性存储条目。返回由持久性存储授予这个条目的最大存储空间。
- `void delete( URL key )`
  删除给定键的条目。
- `String[ ] getNames( URL url )`
  返回由给定的 URL 开始的全部键的相对键名。
- `FileContents get(URL key)
  返回用来修改与给定键相关的数据的内容描述符。 如果没有与键相关的条目， 抛出FileNotFoundException。 

