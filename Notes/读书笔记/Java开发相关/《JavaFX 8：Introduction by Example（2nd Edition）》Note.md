# Introduction

What is JavaFX?
什么是JavaFX？

JavaFX is Java's next-generation graphical user interface(GUI) toolkit that allows developers to rapidly build rich cross-platform application. Built from the ground up, JavaFX takes advantage of modern GPUs through hardware-accelerated graphics, animation, and UI controls. The new JavaFX 8 is a pure Java language application programming interface(API). The goal of JavaFX is to be used across many type of devices, such as embedded devices, smartphones, TVs, tablet computers, and desktops.
JavaFX是可以让开发者快速构建跨平台应用的Java新一代GUI工具包。从基础开始构建，JavaFX利用了现代GPU的硬件加速图像、动画和UI控制。新的JavaFX 8 是纯Java 语言API。JavaFX的目标是在各种类型的设备上使用，例如嵌入式设备、智能手机、电视、平板电脑与桌面。

Before the creation of JavaFX, the development of rich client-side applications involved the gathering of many separate libraries and APIs to achieve highly functional applications. These separate libraries include media, UI controls, Web, 3D, and 2D APIs. Because integrating these APIs together can be rather difficult, the talented engineers at Oracle created a new set of JavaFX libraries that roll up all the same capabilities under one roof. JavaFX is the Swiss Army Knife of GUI toolkits. JavaFX 8 is a pure Java (language) API that allows developers to leverage existing Java libraries and tools.  
在JavaFx 出现之前，多客户端应用开发者需要很多不同的库和API来实现高功能的应用。这些不同的库包括视频，UI控制，网络，3D和2D API。因为集成这些API是非常困难的，Oracle的天才工程师创建了一套新的JavaFX 库来将所有相同能力的工具归纳于一个屋檐下。JavaFX是GUI工具包中的瑞士军刀。JavaFX 8 是让开发者可以整合已有Java库和工具的纯Java API。

> leverage 英[ˈliːvərɪdʒ]  美[ˈlevərɪdʒ]
> n.  影响力; 杠杆作用; 杠杆效力;
> v.  举债经营; 借贷收购;

## Some History

In 2005 Sun Microsystems acquired the company SeeBeyond, where a software engineer named Chris Oliver created a graphics-rich scripting language known as F3 (Form Follows Function). F3 was later unveiled by Sun Microsystems at the 2007 JavaOne conference as JavaFX. On April 20, 2009, Oracle Corporation announced the acquisition of Sun Microsystems, making Oracle the new steward of JavaFX.  

At JavaOne 2010, Oracle announced the JavaFX roadmap, which included its plans to phase out the JavaFX scripting language and re-create the JavaFX platform for the Java platform as Java-based APIs. As promised based on the 2010 roadmap, JavaFX 2.0 SDK was released at JavaOne, in October 2011. In addition to the release of JavaFX 2.0, Oracle announced its commitment to take steps to open-source JavaFX, thus allowing the community to help move the platform forward. Open sourcing JavaFX will increase its adoption, enable a quicker turnaround time on bug fixes, and generate new enhancements.  

Between JavaFX 2.1 and 2.2 the number of new features grew rapidly. Please refer to Table FM-1 for the numerous features included between versions 2.1 and 2.2. JavaFX 2.1 was the official release of the Java SDK on a MacOS. JavaFX 2.2 was the official release of the Java SDK on a Linux operating system.  

The new Java 8 release was announced March 18, 2014. Java 8 has many new APIs and language enhancements, which includes lambdas, Stream API, Nashorn JavaScript engine, and JavaFX APIs. Relating to JavaFX 8, the following are such as: 3D graphics, Rich text support, and Printing APIs.  

# Chapter 1: Getting Started

## Creating a JavaFX Hello World Application

### Using the Command-Line Prompt

The second method of developing JavaFX 8 applications is to use a common text editor and the command line prompt (terminal). By learning how to compile and execute applications on the command-line prompt you will learn about the classpath and where the executable files reside. This exposure should sharpen your skills when you are in environments where fancy IDEs and/or editors aren’t easily available.

Working from the command line you will basically use popular text editors such as vi, Emacs, or Notepad to code your JavaFX Hello World application. An example is shown in Listing 1-1.  

~~~java
package helloworldmain;

import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.stage.Stage;

/**
 * A JavaFX Hello World
 * @author carldea
 */
public class HelloWorldMain extends Application {
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
    	Application.launch(args);
    }
    
    @Override
    public void start(Stage primaryStage) {
    	primaryStage.setTitle("Hello World");
    	Group root = new Group();
        Scene scene = new Scene(root, 300, 250);
        Button btn = new Button();
        btn.setLayoutX(100);
        btn.setLayoutY(80);
        btn.setText("Hello World");
        btn.setOnAction(new EventHandler<ActionEvent>() {
            public void handle(ActionEvent event) {
            	System.out.println("Hello World");
            }
		});
		root.getChildren().add(btn);
        primaryStage.setScene(scene);
        primaryStage.show();
    }
}
~~~

Once the Java file is created you will use the command-line prompt or terminal window to compile and run your JavaFX application. Following are the steps to create a JavaFX Hello World application to be compiled and run on the command-line prompt.  

1. Copy and paste the code from Listing 1-1 into a text editor, and save the file as `HelloWorldMain.java`.
2. After saving the file named HelloWorldMain.java, on the command-line prompt you will navigate to the directory location of the file. The examples to follow assume you have saved the file to a directory named `myprojects/helloworld`. Change directory as follows on Mac OS X, Linux, and Unix-based operating systems:
   `cd ~/myprojects/helloworld`
3. Change directory on Windows operating systems using the following command:
   `C:\Users\myusername>cd myprojects\helloworld`
   `C:\Users\myusername\myprojects\helloworld>`
4. Compile the source code file HelloWorldMain.java using the Java compiler javac with the -d switch with the current path. Type the following command:
   `C:\Users\myusername\myprojects\helloworld>javac -d . HelloWorldMain.java  `

Notice the `-d .` before the filename. The dot denotes the current directory. The –d option (destination directory) lets the Java compiler know where to put compiled class files based on their package namespace. In this scenario, the HelloWorldMain package statement (namespace) is helloworldmain, which will create a subdirectory under the current directory assuming we are in the myprojects/helloworld directory.  

When finished compiling, your directory structure should resemble the following:

~~~
|myprojects
    |helloworld
        |HelloWorldMain.java
        |helloworldmain
        	|HelloWorldMain.class
~~~

5. Run and test your JavaFX Hello World application. Assuming you are located in the same directory as the HelloWorldMain.java file, type the following command to run your JavaFX Hello World application from the command-line prompt:
   `C:\Users\myusername\myprojects\helloworld>java helloworldmain.HelloWorldMain  `

## Walking Through the Code

You’ll notice in the source code that JavaFX-based applications extend (inherit) from the javafx.application.Application class. The Application class provides application life cycle functions such as initializing, launching, starting, and stopping during runtime. This provides a mechanism for Java applications to launch JavaFX GUI components separate from the main thread. The code in Listing 1-2 is a skeleton of the JavaFX Hello World application, having a main() method and an overridden start() method.  

~~~java
public class HelloWorldMain extends Application {
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // Main thread
        Application.launch(args);
    }
    @Override
    public void start(Stage primaryStage) {
        // JavaFX application thread
        // JavaFX code here...
    }
}
~~~

Here, in our main() method’s entry point we launch the JavaFX application by simply passing in the command-line arguments to the `Application.launch()` method. To access any arguments passed into the launch() method you can invoke the `getParameters()` method of the Application class. Please see the Javadoc documentation for details on various ways to access named and raw arguments. After the `Application.launch()` method has executed, the application will enter a ready state, and the framework internals will invoke the start() method to begin. At this point, the program execution occurs on the JavaFX application thread and not on the main thread. When the start() method is invoked, a JavaFX `javafx.stage.Stage` object is available for the developer to use and manipulate. Following is the overridden Application start() method:  

~~~java
@Override
public void start(Stage primaryStage) {...}
~~~

When the program begins in the start() method, a separate thread of execution occurs, called the JavaFX application thread. Keep in mind that running on the JavaFX application thread is synonymous with running on Java Swing’s event dispatch thread. Later in this book, you will learn how to create background processes to avoid blocking the JavaFX application thread. When you know how to build applications to avoid blocking the GUI, the user will notice that your application is much more responsive (snappy) under heavy usage. Mastering responsiveness in GUI applications is an important concept in enhancing usability and the overall user experience.  

### JavaFX Scene Graph

You’ll notice that some objects are oddly named, such as Stage and Scene. The designers of the API have modeled things on the idea of a theater or a play in which actors perform in front of an audience. In this analogy, a play consists of one-to-many scenes that actors perform in. And, of course, all scenes are performed on a stage. In JavaFX the Stage is equivalent to an application window similar to Java Swing API JFrame or JDialog on the desktop. Depending on the device, such as a Raspberry Pi (Raspbian), there may be only one stage. You can think of a Scene object as a content pane, similar to Java Swing’s JPanel, capable of holding zero-to-many Node objects (children)  

Proceeding with our example, in the start() method we see that for a JavaFX desktop window (stage) you can set the title bar using the setTitle() method. Next, you create a root node (Group), which is added to the Scene object as the top-level surface for the application window. The following code snippet shows how to set the title and create the scene:  

> snippet	英[ˈsnɪpɪt] 美[ˈsnɪpɪt]
> n.	一小条(消息); 一则(新闻); 一小段(谈话、音乐等);

~~~java
primaryStage.setTitle("Hello World");
Group root = new Group();
Scene scene = new Scene(root, 300, 250);
~~~

### JavaFX Node

A JavaFX Node is a fundamental base class for all scene graph nodes to be rendered. The following graphics capabilities can be applied to Nodes: scaling, transforms, translations, and effects.

Some of the most commonly used nodes are UI controls and Shape objects. Similar to a tree data structure, a scene graph will contain children nodes by using a container class such as the Group or Pane class. We’ll learn more about the Group class later when we look at the ObservableList class, but for now you can think of them as Java List or Collection classes that are capable of holding child Node objects. In the following code a button (Button) node is created to be positioned on the scene and set with an event handler (EventHandler<ActionEvent>) that responds when the user presses the button. The handler code will output the word “Hello World” on the console.  

~~~java
Button btn = new Button();
btn.setLayoutX(100);
btn.setLayoutY(80);
btn.setText("Hello World");
btn.setOnAction(new EventHandler<ActionEvent>() {
    public void handle(ActionEvent event) {
    	System.out.println("Hello World");
    }
});
root.getChildren().add(btn);
~~~

Once the child nodes have been added to our root Group via the getChildren().add() method, we set the primaryStage’s scene and call the show() method on the Stage object to display a JavaFX application window. By default the window will allow a user to minimize, maximize, and close (exit) the application. Following is the code to set the scene and display (show) the JavaFX application window (Stage):  

~~~java
primaryStage.setScene(scene);
primaryStage.show();
~~~

### Packaging a JavaFX Application

At some point you will want to distribute or deploy your JavaFX application. To handle the numerous application packaging and deployment strategies Oracle’s JavaFX team has created a JavaFX Packager tool to assist developers to build, package, and deploy their applications.   

To give you a taste of the JavaFX Packager tool’s capabilities, I will show you how to package the HelloWorldMain classes into a single executable jar file that a user can double-click or launch from a command prompt (terminal).

~~~sh
cd myprojects/helloworld

javac -d . HelloWorldMain.java

javafxpackager -createjar -appclass helloworldmain.HelloWorldMain -srcdir . -outdir out -outfile helloworld.jar -v  
~~~

Table 1-1 describes the common options and switches that are used in building a JavaFX jar executable application.  

| Option/Switch | Example                       | Description                                                  |
| ------------- | ----------------------------- | ------------------------------------------------------------ |
| -createjar    | --                            | Creates a JavaFX JAR executable application                  |
| -appclass     | helloworldmain.HelloWorldMain | Specifies the fully qualified name of the class containing the main() method. |
| -srcdir       | .                             | The top-level location of the parent directory holding the compiled classes (current directory). |
| -outdir       | out                           | The destination where the packaged jar file will be created  |
| -outfile      | helloworld.jar                | Specifies the name of the executable jar file.               |
| -v            | --                            | Allows verbose displays logging information when executing javafxpackager |

> verbose	英[vɜːˈbəʊs] 美[vɜːrˈboʊs]
> adj.	冗长的; 啰唆的; 唠叨的;

To run the jar executable on the command line, you simply type the following and press Enter:

~~~sh
javaw -jar out/helloworld.jar  
~~~

# Chapter 2: JavaFX Fundamentals

There is nothing more frustrating than receiving complicated advice as a solution to a problem. Because of this, I have always made it a point to focus on the fundamentals. In order to render graphics on the JavaFX scene, you will need basic shapes and colors. Expanding upon your knowledge of the JavaFX scene graph, which you visited toward the end of Chapter 1, you will learn in this chapter how to draw and manipulate 2D shapes on the JavaFX scene graph.

Even more fundamental than a shape object is JavaFX’s `javafx.scene.Node` class. The Node class is a fundamental base class for all JavaFX scene graph nodes. The Node class provides the ability to transform, translate, and apply effects to any node. Many examples in this chapter involve the `javafx.scene.shape.Shape` class, which is a descendant of the Node class. Therefore, the Shape class will inherit all of the Node class’ capabilities. In this chapter you will explore many derived classes that inherit from Shape. You will begin this chapter by examining JavaFX’s most basic shape, the Line node.

## JavaFX Lines

Rendering lines in JavaFX is conceptually similar to Euclidean geometry in that two (x, y) coordinate points connect to draw a segment into space. When drawn on the JavaFX scene graph, lines are rendered using the screen coordinate space (system). In geometry, a line is defined as a segment connected by two points in space, although it lacks a width (thickness) and color value. Does this mean that the line is invisible? In the computer world, physical devices plot pixels and shapes that occupy real surfaces. Monitors and printers are examples of such surfaces. Because of this method of production, modern graphics programming has adopted the standard screen coordinate system. In this system, lines that are drawn are visible and have attributes of width and color.

> Euclidean	
> adj. 欧氏; 欧几里得; 欧几里德; 欧几里得的; 欧几里德的;

In a nutshell, the standard screen coordinate system places (0, 0) at the upper-left corner; this differs from the Cartesian coordinate system, where (0, 0) is placed at the center of the graphing area or the point at which the x and y axes converge. In both coordinate systems, the x coordinate has the same effect when moving a point along the x axis. However, when using the screen coordinate system to move along the y axis, the effect is opposite that of the Cartesian system. In other words, the y coordinate’s value increases when moving a point in a downward direction (top to bottom). 

> Cartesian 英[kɑːˈtiːziən] 美[kɑːrˈtiːziən]
> adj.	笛卡尔坐标系; 笛卡尔; 直角; 笛卡尔的; 笛卡儿积;
>
> converge	英[kənˈvɜːdʒ] 美[kənˈvɜːrdʒ]
> v.	汇集; 聚集; 集中; (向某一点)相交，会合; (思想、政策、目标等)十分相似，相同;

As you learn more about JavaFX, you will discover many scene graph objects, such as lines, circles, and rectangles. These objects are derived classes of the Shape class. All shape objects can perform geometric operations between two shaped areas, such as subtract, intersect and union. By mastering the Shape API, you will begin to see endless possibilities. Now let’s discuss how to create lines.

To draw lines in JavaFX, you will use the javafx.scene.shape.Line class. When creating a Line instance you need to specify a start (x, y) coordinate and an end coordinate to draw a line. There are two ways to specify the start and end points when creating Line nodes. The first method is to use a constructor with the parameters startX, startY, endX, and endY. The data types of all the parameters are double values, which provide floating-point decimal precision. The following line has a start point (100, 10) and end point (10, 110) created using a constructor.

~~~java
Line line = new Line(100, 10, 10, 110);
~~~

The second method to create a line node is to instantiate a Line class by using the empty default constructor and subsequently setting each attribute using associated setter methods. The following code snippet shows how to specify a line’s start and end points using setter methods.

~~~java
Line line = new Line();
line.setStartX(100);
line.setStartY(10);
line.setEndX(10);
line.setEndY(110);
~~~

Line nodes drawn on the scene graph default to a stroke width of 1.0 (double) and a stroke color of black (Color.BLACK). According to the Javadoc, all shapes have a stroke color of null (no color) except Line, Polyline, and Path nodes.

> stroke color 英[strəʊk ˈkʌlə(r)] 美[stroʊk ˈkʌlər] 
> n. 笔画颜色; 描边颜色; 笔触颜色; 画笔颜色;

Now that you know how to draw lines on the scene graph, you are probably wondering how to be more creative with lines. Creating different kinds of lines is simple; you basically set properties inherited from the parent class (javafx.scene.shape.Shape). Table 2-1 shows the properties you can set on a line (Shape). To retrieve or modify each property, you will use its appropriate getter and setter methods. The table lists each property name and its data type, with a description. Please refer to the Javadoc documentation for more details.

| Property         | Data Type                         | Description                                                  |
| ---------------- | --------------------------------- | ------------------------------------------------------------ |
| fill             | javafx.scene.paint.Paint          | A color to fill inside a shape.                              |
| smooth           | Boolean                           | True turns on anti-aliasing, otherwise false.                |
| strokeDashOffset | Double                            | The offset (distance) into the dashed pattern.               |
| strokeLineCap    | javafx.scene.shape.StrokeLineCap  | The cap style on the end of a line or path. There are three styles: StrokeLineCap.BUTT, StrokeLineCap.ROUND, and StrokeLineCap.SQUARE. |
| StrokeLineJoin   | javafx.scene.shape.StrokeLineJoin | Decoration when lines meet. There are three types: StrokeLineJoin.MITER, StrokeLineJoin.BEVEL, and StrokeLineJoin.ROUND. |
| StrokeMiterLimit | Double                            | The limit of a miter joint. Used along with the miter join decoration(StrokeLineJoin.MITER) |
| stroke           | javafx.scene.paint.Paint          | A color for the shape's line stroke                          |
| strokeType       | javafx.scene.shape.StrokeType     | Where to draw the stroke around the boundary of a Shape node. There are three types: StrokeType.CENTERED, StrokeType.INSIDE, and StrokeType.OUTSIDE. |
| strokeWidth      | Double                            | A stroke line's width.                                       |

> miter	英[ˈmaɪtə(r)] 美[ˈmaɪtər]
> n.	主教法冠；斜接;
> v.	给主教等加冠；使斜接;
>
> bevel	英[ˈbevl] 美[ˈbevl]
> n.	斜边; 斜面; 斜角规;
> v.	把（物体的方形边）改成斜面边;

## Drawing Lines

To get a better idea of how you would use a shape’s properties based on Table 2-1, let’s look at an example. Figure 2-2 is the output of Listing 2-1, the DrawingLines.java source code, demonstrating the drawing of JavaFX lines. The JavaFX application in the listing draws three lines with various properties modified. Some common properties used in this example are stroke dash offset, stroke line cap, stroke width, and stroke color.

In Figure 2-2 you can see that the first line (top) is a thick red line with a dashed stroke pattern. The second line is a thick white line having rounded end caps (line cap). Last is an ordinary blue line having the same thickness as the others. You will also notice in Figure 2-2 underneath the blue line are a label and slider control; these allow the user to change the red (top) line’s stroke dash offset property dynamically. The label control displays the dash offset value as the slider control moves.

Listing 2-1shows the source code for DrawingLines.java.

~~~java
package jfx8ibe;

import javafx.application.Application;
import javafx.beans.value.ObservableValue;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.control.Slider;
import javafx.scene.paint.Color;
import javafx.scene.shape.Line;
import javafx.scene.shape.StrokeLineCap;
import javafx.scene.text.Text;
import javafx.stage.Stage;

/**
 * Drawing Lines
 * Listing 2-1 DrawingLines.java
 * @author carldea
 */
public class DrawingLines extends Application {
    @Override
    public void start(Stage primaryStage) {
        primaryStage.setTitle("Chapter 2 Drawing Lines");
        
        Group root = new Group();
        Scene scene = new Scene(root, 300, 150, Color.GRAY);
        
        // Red line
        Line redLine = new Line(10, 10, 200, 10);

        // setting common properties
        redLine.setStroke(Color.RED);
        redLine.setStrokeWidth(10);
        redLine.setStrokeLineCap(StrokeLineCap.BUTT);

        // creating a dashed pattern
        redLine.getStrokeDashArray().addAll(10d, 5d, 15d, 5d, 20d);
        redLine.setStrokeDashOffset(0);

        root.getChildren().add(redLine);

        // White line
        Line whiteLine = new Line(10, 30, 200, 30);
        whiteLine.setStroke(Color.WHITE);
        whiteLine.setStrokeWidth(10);
        whiteLine.setStrokeLineCap(StrokeLineCap.ROUND);

        root.getChildren().add(whiteLine);

        // Blue line
        Line blueLine = new Line(10, 50, 200, 50);
        blueLine.setStroke(Color.BLUE);
        blueLine.setStrokeWidth(10);

        root.getChildren().add(blueLine);


        // slider min, max, and current value
        Slider slider = new Slider(0, 100, 0);
        slider.setLayoutX(10);
        slider.setLayoutY(95);

        // bind the stroke dash offset property
        redLine.strokeDashOffsetProperty()
            .bind(slider.valueProperty());
        root.getChildren()
            .add(slider);

        Text offsetText = new Text("Stroke Dash Offset: 0.0");
        offsetText.setX(10);
        offsetText.setY(80);
        offsetText.setStroke(Color.WHITE);

        // display stroke dash offset value
        slider.valueProperty()
            .addListener((ov, curVal, newVal) ->
                         offsetText.setText("Stroke Dash Offset: " + slider.getValue()));
        root.getChildren().add(offsetText);
        primaryStage.setScene(scene);
        primaryStage.show();
    }
    /**
 	 * @param args the command line arguments
 	 */
    public static void main(String[] args) {
        launch(args);
    }
}
~~~

DrawingLines.java begins by setting the title of the Stage window using the setTitle() method. Then it creates a root node (javafx.scene.Group) for the Scene object. All root nodes (those extending javafx.scene.Parent) have a method getChildren().add() to allow any JavaFX node to be added to the scene graph. By default the Scene object will be filled with a white background; however, because one of our lines is white, the code will set the scene to have a color of gray (Color.GRAY). This will allow some contrast in order to see the white line. Next is the code that creates the three lines (red, white and blue).

In the first line, the code sets the common properties of a Line node. The common properties are stroke color, stroke width, and stroke line cap. As noted earlier, lines do not have a shape internally, so a line’s fill color property is set to null (no color) and stroke color defaults to black. To set the stroke color you can use built-in JavaFX colors by using the javafx.scene.paint.Color class. For instance, for the color red you will use Color.RED. There are many ways to specify color, such as using RGB, HSB, or Web hex values. All three methods also have the ability to specify alpha value (transparency). Later, you will see additional methods for coloring shapes. Please refer to the Javadoc to learn more about color (`javafx.scene.paint.Color`). After setting the stroke’s outline color you can set the line’s stroke width (thickness) by using the `setStrokeWidth()` method. Shapes also have a stroke line cap property. This property specifies the style of the ends of the line. For instance, specifying the stroke line cap as butt (`StrokeLineCap.BUTT`) will make a flat square end, while a round (`StrokeLineCap.ROUND`) style will appear with a rounded end. The following code snippet sets a line node’s common shape properties:

~~~java
// setting common properties
redLine.setStroke(Color.RED);
redLine.setStrokeWidth(10);
redLine.setStrokeLineCap(StrokeLineCap.BUTT);
~~~

After setting the common properties on the red Line node, the example code creates a dashed pattern. To form a dashed pattern you would simply add double values to the `getStrokeDashArray().add()` method. Each value represents the number of pixels for a dash segment. To set the dash segment array, the first value (10d) is a visible dash segment 10 pixels wide. Next is a five-pixel empty segment (not visible). Following that is a visible dash segment 15 pixels wide, and so on. Because the array has an odd number of values, you can see that as the pattern repeats itself, the first value (10d) becomes a 10-pixel empty segment (not visible). Following is the code to create a dashed pattern for a Line node:

~~~java
// creating a dashed pattern
redLine.getStrokeDashArray().addAll(10d, 5d, 15d, 5d, 20d);
redLine.setStrokeDashOffset(0);
~~~

By default the dash offset property value is zero. To see what happens when the offset property changes, the user can drag the slider thumb to the right to increase the offset. The stroke dash offset is the distance into the current pattern to begin the line drawing.

Because the other two lines are pretty much the same in the way they modify common properties, I will not explain them any further. I trust you now understand the fundamentals of creating lines. One last thing to mention about this example is the Slider control and the way it is wired up using binding. We will discuss binding further in Chapter 3.

Notice in Listing 2-1 also that after the three lines just discussed, the slider control has handler code that updates a Text node dynamically to display the dash offset value. Also notice the invocation to the `addListener()` method, containing concise code added as a change listener. This may look odd to you; however, it reflects a new Java 8 feature called *lambda expressions*, which you will learn more about in Chapter 3. The following code snippet creates a change listener using lambdas instead of an anonymous inner class (ChangeListener).

~~~java
// display stroke dash offset value
slider.valueProperty()
    .addListener( (ov, oldVal, newVal) ->
                 offsetText.setText("Stroke Dash Offset: " + slider.getValue()));
~~~

Learning about how to draw lines will help you apply the same knowledge to any Shape node in JavaFX. These important concepts will allow you to create any kind of shape styled the way you see fit. Speaking of shapes, that’s what we’ll discuss next.

## Drawing Shapes

Drawing rectangles on the scene graph is quite easy. Just as you learned in a geometry classroom, you specify a width, height, and an (x, y) location (upper-left corner) to position the rectangle on the scene graph. To draw a rectangle in JavaFX you use the `javafx.scene.shape.Rectangle` class. In addition to common attributes, the Rectangle class also implements an *arc width* and *arc height*. This feature will draw rounded corners on a rectangle. Figure 2-3 shows a rounded rectangle, which has both an *arc width* and an *arc height*.

Following is a code snippet that draws a rectangle positioned at (50, 50) with a width of 100, a height of 130, an arc width of 10, and an arc height of 40.

~~~java
Rectangle roundRect = new Rectangle();
roundRect.setX(50);
roundRect.setY(50);
roundRect.setWidth(100);
roundRect.setHeight(130);
roundRect.setArcWidth(10);
roundRect.setArcHeight(40);
~~~

## Drawing Complex Shapes

Learning about simple shapes is great, but to create more complex shapes you need to see what other built-in shapes that the JavaFX API has to offer. Exploring the Java documentation (`javafx.scene.shape.*`), you will discover many derived shape classes to choose from. The following are all the currently supported shapes:

- Arc
- Circle
- CubicCurve
- Ellipse
- Line
- Path
- Polygon
- Polyline
- QuadCurve
- Rectangle
- SVGPath
- Text (which is considered to be a type of shape)

> cubic	英[ˈkjuːbɪk] 美[ˈkjuːbɪk]
> adj.	立方的; 用立方单位度量(或表示)的; 立方形的;

### A Complex Shape Example

The DrawingShape.java code shown in Listing 2-2 demonstrates the drawing of the shapes you see in Figure 2-4. The first complex shape involves a cubic curve (CubicCurve) that is drawn in the shape of a sine wave. The next shape is an ice cream cone; it uses the Path class, which contains path elements (javafx.scene.shape.PathElement). The third shape is a Quadratic Bézier curve (QuadCurve) forming a smile. Our final shape is a delectable donut; to create this donut shape you will create two (Ellipse) shapes (one smaller and one larger) and subtract one. For brevity, Listing 2-2 shows just the start() method, containing the main JavaFX elements. To get the full code listing, download the example code from the book’s web site.

> quadratic	英[kwɒˈdrætɪk] 美[kwɑːˈdrætɪk]
> adj.	平方的; 二次方的;
>
> Bézier curve
> 贝塞尔曲线
>
> delectable	英[dɪˈlektəbl] 美[dɪˈlektəbl]
> adj.	美味可口的; 香甜的; 宜人的; 妩媚动人的; 有迷惑力的; 有吸引力的;

~~~java
@Override
public void start(Stage primaryStage) {
    primaryStage.setTitle("Chapter 2 Drawing Shapes");
    Group root = new Group();
    Scene scene = new Scene(root, 306, 550, Color.WHITE);
    // Sine wave
    CubicCurve cubicCurve = new CubicCurve(
        50, // start x point
        75, // start y point
        80, // control x1 point
        -25, // control y1 point
        110, // control x2 point
        175, // control y2 point
        140, // end x point
        75); // end y point
    cubicCurve.setStrokeType(StrokeType.CENTERED);
    cubicCurve.setStroke(Color.BLACK);
    cubicCurve.setStrokeWidth(3);
    cubicCurve.setFill(Color.WHITE);

    root.getChildren().add(cubicCurve);
    // Ice cream cone
    Path path = new Path();
    path.setStrokeWidth(3);

    // create top part beginning on the left
    MoveTo moveTo = new MoveTo();
    moveTo.setX(50);
    moveTo.setY(150);

    // curve ice cream (dome)
    QuadCurveTo quadCurveTo = new QuadCurveTo();
    quadCurveTo.setX(150);
    quadCurveTo.setY(150);
    quadCurveTo.setControlX(100);
    quadCurveTo.setControlY(50);

    // cone rim
    LineTo lineTo1 = new LineTo();
    lineTo1.setX(50);
    lineTo1.setY(150);
    // left side of cone
    LineTo lineTo2 = new LineTo();
    lineTo2.setX(100);
    lineTo2.setY(275);
    // right side of cone
    LineTo lineTo3 = new LineTo();
    lineTo3.setX(150);
    lineTo3.setY(150);

    path.getElements().addAll(moveTo, quadCurveTo, lineTo1, lineTo2 , lineTo3);

    path.setTranslateY(30);

    root.getChildren().add(path);

    // A smile
    QuadCurve quad = new QuadCurve(
        50, // start x point
        50, // start y point
        125,// control x point
        150,// control y point
        150,// end x point
        50);// end y point
    quad.setTranslateY(path.getBoundsInParent().getMaxY());
    quad.setStrokeWidth(3);
    quad.setStroke(Color.BLACK);
    quad.setFill(Color.WHITE);

    root.getChildren().add(quad);

    // outer donut
    Ellipse bigCircle = new Ellipse(
        100, // center x
        100, // center y
        50, // radius x
        75/2); // radius y
    bigCircle.setStrokeWidth(3);
    bigCircle.setStroke(Color.BLACK);
    bigCircle.setFill(Color.WHITE);

    // donut hole
    Ellipse smallCircle = new Ellipse(
        100, // center x
        100, // center y
        35/2, // radius x
        25/2); // radius y

    // make a donut
    Shape donut = Path.subtract(bigCircle, smallCircle);
    donut.setStrokeWidth(1.8);
    donut.setStroke(Color.BLACK);

    // orange glaze
    donut.setFill(Color.rgb(255, 200, 0));

    // add drop shadow
    DropShadow dropShadow = new DropShadow(
        5, // radius
        2.0f, // offset X
        2.0f, // offset Y
        Color.rgb(50, 50, 50, .588));

    donut.setEffect(dropShadow);

    // move slightly down
    donut.setTranslateY(quad.getBoundsInParent().getMinY() + 30);

    root.getChildren().add(donut);
    primaryStage.setScene(scene);
    primaryStage.show();
}
~~~

Four shapes are drawn in Figure 2-4. Each shape will be detailed further in the following sections, which describe the code and the reasoning behind the creation of each of the four shapes.

### The Cubic Curve

In Listing 2-2 the first shape, drawn as a sine wave, is really a javafx.scene.shape.CubicCurve class. To create a cubic curve, you simply look for the appropriate constructor to be instantiated. A cubic curve’s main parameters to set are startX, startY, controlX1 (control point1 X), controlY1 (control point1 Y), controlX2 (control point2 X), and controlY2 (control point2 Y), endX, endY. Figure 2-5 shows a cubic curve with control points influencing the curve.

The startX, startY, endX, and endY parameters are the starting and ending points of a curved line, and controlX1, controlY1, controlX2, and controlY2 are control points. The control point (controlX1, controlY1) is a point in screen space that will influence the line segment between the start point (startX, startY) and the midpoint of the line. The point (controlX2, controlY2) is another control point that will influence the line segment between the midpoint of the line and its end point (endX, endY). A control point is a point that pulls the curve toward the direction of itself. A definition of a control point is a line perpendicular to a tangent line on the curve. In our example, we simply have a control point 1 above the line to pull the curve upward to form a hill and control point 2 below the line to pull the curve downward to form a valley.

> perpendicular 英[ˌpɜːpənˈdɪkjələ(r)] 美[ˌpɜːrpənˈdɪkjələr]
> adj.	垂直的; 成直角的; 垂直式的(英国14、15世纪盛行的建筑风格，以使用垂直线和大拱为特征);
> n.	垂直线(或位置、方向);
>
> tangent	英[ˈtændʒənt] 美[ˈtændʒənt]
> n.	切线; 正切;



> **Note** All older JavaFX 2.x Builder classes are deprecated in JavaFX 8. Be advised that the previous edition of this book used Builder classes. Shape classes using deprecated builder classes should be converted in favor of constructors and setter methods when specifying properties.



### The Ice Cream Cone

The ice cream cone shape is created using the javafx.scene.shape.Path class. Each path element is created and added to the Path object. Also, each element is not considered a graph node (`javafx.scene.Node`). This means that path elements do not extend from the `javafx.scene.shape.Shape` class and they cannot be child nodes in a scene graph to be displayed. Figure 2-6 shows an ice cream cone shape.

Path elements actually extend from the `javafx.scene.shape.PathElement` class, which is used only in the context of a Path object. So you won’t be able to instantiate a LineTo class to be put in the scene graph. Just remember that the classes with To as a suffix are path elements, not Shape nodes.

For example, the `MoveTo` and `LineTo` object instances are `Path` elements added to a `Path` object, not shapes that can be added to the scene. Following are Path elements added to a Path object to draw an ice cream cone:

~~~java
// Ice cream
Path path = new Path();

MoveTo moveTo = new MoveTo();
moveTo.setX(50);
moveTo.setY(150);

...// Additional Path Elements created.
LineTo lineTo1 = new LineTo();
lineTo1.setX(50);
lineTo1.setY(150);

...// Additional Path Elements created.

path.getElements().addAll(moveTo, quadCurveTo, lineTo1, lineTo2 , lineTo3);
~~~

### The Smile

To render the smile shape, the code uses the javafx.scene.shape.QuadCurve class. This is similar to the cubic curve example described earlier in the first shape. Instead of two control points you only have one control point. Again, a control point influences a line by pulling the midpoint toward it. Shown in Figure 2-7 is a QuadCurve shape with a control point below its starting and ending points to form a smile.

The following code draws a quadratic curve with a stroke thickness of three pixels filled with the color white:

~~~java
// A smile
QuadCurve quad = new QuadCurve(
    50, // start x point
    50, // start y point
    125,// control x point
    150,// control y point
    150,// end x point
    50);// end y point

quad.setStrokeWidth(3);
quad.setStroke(Color.BLACK);
quad.setFill(Color.WHITE);
~~~

### The Donut

Last is our tasty donut shape with an interesting drop shadow effect shown in Figure 2-8. This custom shape was created using geometric operations such as subtract, union, intersection, and so on. With any two shapes you can perform geometric operations to form an entirely new shape object. All of the operations can be found in the javafx.scene.shape.Path class.

To create the donut shape, you begin by creating two circular ellipse (javafx.scene.shape.Ellipse) instances. Subtracting the smaller ellipse (donut hole) from the larger ellipse area creates a newly derived Shape object, which is returned using the static Path.subtract() method. The following code snippet creates the donut shape using the Path.subtract() method:

~~~java
// outer donut
Ellipse bigCircle = ...//Outer shape area
// donut hole
Ellipse smallCircle = ...// Inner shape area
// make a donut
Shape donut = Path.subtract(bigCircle, smallCircle);
~~~

Next is applying a drop shadow effect to the donut shape. A common technique is to draw the shape filled black while the original shape is laid on top slightly offset to appear as a shadow. However, in JavaFX the code will be drawing the donut shape once and use the setEffect() method to apply a DropShadow object instance. To cast the shadow offset, call the setOffsetX() and setOffsetY() methods. Typically if the light source is from the upper left, the shadow is shown from the lower right of the shape.

One last thing to point out is that all shapes in the example are initially drawn to be positioned underneath one another. Looking back at Listing 2-2, you’ll notice that as each shape was created, its translateY property was set to reposition or shift each shape from its original position. For example, if a shape’s upper-left bounding box point is created at (100, 100) and you want it to be moved to (101, 101), the translateX and translateY properties would be set to 1.

As each shape is rendered beneath another in this example, you may invoke the getBoundsInParent() method to return the information about the bounding region of a node, such as its width and height. The getBoundsInParent() calculation for the height and width includes the node’s actual dimensions (width and height) plus any effects, translations, and transformations. For example, a shape that has a drop shadow effect increases its width by including the shadow.

Figure 2-9 is a dashed red rectangle surrounding a Rectangle node inside a parent node better known as the *bounding rectangle in parent* (Bounds in Parent). You will notice that the width and height calculations include *transforms*, *translates*, and *effects* applied to the shape. In the figure, the transform operation is a rotation and the effect is a drop shadow.

## Painting Colors

### An Example of Color

> **Note** The example to follow touches on basic techniques for creating solid colors, gradient colors, and translucent colors. There are also advanced strategies, such as the ImagePattern API and Blend API. You can read about those, if you are interested, in the API documentation viewable through Javadoc.

> translucent	英[trænzˈluːsnt] 美[trænzˈluːsnt]
> adj.	半透明的;

In JavaFX, all shapes can be filled with simple colors and gradient colors. As a reminder, according to the Javadoc all shape nodes are filled with the color black by default except for Line, Polyline, and Path class (descendents of java.scene.shape.Shape). Listing 2-3 uses the following main classes that will be used to fill the shape nodes shown in Figure 2-10:

- javafx.scene.paint.Color
- javafx.scene.paint.Stop
- javafx.scene.paint.RadialGradient
- javafx.scene.paint.LinearGradient

~~~java
@Override
public void start(Stage primaryStage) {
    primaryStage.setTitle("Chapter 2 Painting Colors");
    Group root = new Group();
    Scene scene = new Scene(root, 350, 300, Color.WHITE);
    
    // Red ellipse with radial gradient color
    Ellipse ellipse = new Ellipse(100, // center X
                                  50 + 70/2, // center Y
                                  50, // radius X
                                  70/2); // radius Y
    RadialGradient gradient1 = new RadialGradient(
        0, // focusAngle
        .1, // focusDistance
        80, // centerX
        45, // centerY
        120, // radius
        false, // proportional
        CycleMethod.NO_CYCLE, // cycleMethod
        new Stop(0, Color.RED), // stops
        new Stop(1, Color.BLACK)
    );
    
    ellipse.setFill(gradient1);
    root.getChildren().add(ellipse);
    double ellipseHeight = ellipse.getBoundsInParent()
        .getHeight();
    
    // thick black line behind second shape
    Line blackLine = new Line();
    blackLine.setStartX(170);
    blackLine.setStartY(30);
    blackLine.setEndX(20);
    blackLine.setEndY(140);
    blackLine.setFill(Color.BLACK);
    blackLine.setStrokeWidth(10.0f);
    blackLine.setTranslateY(ellipseHeight + 10);
    
    root.getChildren().add(blackLine);
    
    // A rectangle filled with a linear gradient with a translucent color.
    Rectangle rectangle = new Rectangle();
    rectangle.setX(50);
    rectangle.setY(50);
    rectangle.setWidth(100);
    rectangle.setHeight(70);
    rectangle.setTranslateY(ellipseHeight + 10);
    
    LinearGradient linearGrad = new LinearGradient(
        0, // start X
        0, // start Y
        0, // end X
        1, // end Y
        true, // proportional
        CycleMethod.NO_CYCLE, // cycle colors
        // stops
        new Stop(0.1f, Color.rgb(255, 200, 0, .784)),
        new Stop(1.0f, Color.rgb(0, 0, 0, .784)));
    
    rectangle.setFill(linearGrad);
    root.getChildren().add(rectangle);
    
    // A rectangle filled with a linear gradient with a reflective cycle.
    Rectangle roundRect = new Rectangle();
    roundRect.setX(50);
    roundRect.setY(50);
    roundRect.setWidth(100);
    roundRect.setHeight(70);
    roundRect.setArcWidth(20);
    roundRect.setArcHeight(20);
    roundRect.setTranslateY(ellipseHeight + 10 +
                            rectangle.getHeight() + 10);
    
    LinearGradient cycleGrad = new LinearGradient(
        50, // start X
        50, // start Y
        70, // end X
        70, // end Y
        false, // proportional
        CycleMethod.REFLECT, // cycleMethod
        new Stop(0f, Color.rgb(0, 255, 0, .784)),
        new Stop(1.0f, Color.rgb(0, 0, 0, .784))
    );
    
    roundRect.setFill(cycleGrad);
    root.getChildren().add(roundRect);
    
    primaryStage.setScene(scene);
    primaryStage.show();
}
~~~

When specifying color values, the PaintingColors.java code uses the colors in the default RGB color space. To create a color, the code uses the Color.rgb() method. This method takes three integer values, representing red, green, and blue components. Another overloaded method takes three integer values and a fourth parameter with a data type of double. This fourth parameter is the alpha channel, which sets the opacity of the color. This value is between zero (0) and one (1).

> **Note** Keep in mind that there are other ways to create color, such as by specifying hue, saturation, and brightness (HSB). To create a color using HSB, you would invoke the Color.hsb() method. Another way to specify color values that is common to web development in HTML and CSS is the use of RGB hexadecimal values. Developers who are familiar with this convention can use the Color.web() method.

After drawing the ellipse shape, the code invokes the setFill() method using a radial gradient to give the appearance of a 3D spherical object. Next, it creates a rectangle filled with a yellow semitransparent linear gradient. Added behind the yellow rectangle is a thick black line to demonstrate the semitransparent color. Finally, the code implements a rounded rectangle filled with a green-and-black reflective linear gradient resembling 3D tubes in a diagonal direction. Each shape and its associated color fill will be discussed in more detail in the following sections.

### Gradient Color

Creating a gradient color in JavaFX involves five things:

1. A starting point to begin the first stop color.
2. The end point, representing the end stop color.
3. The proportional property to specify whether to use standard screen coordinates or unit square coordinates.
4. The Cycle method to specify one of the three enums: NO_CYCLE, REFLECT, or REPEAT.
5. An array of stop (Stop) colors. Each stop containing a color will begin by painting the first stop color, then interpolating to the second stop color, and so on.

> interpolating 英[ɪnˈtɜːpəleɪtɪŋ] 美[ɪnˈtɜːrpəleɪtɪŋ]
> v.	插话; 插嘴; (在文章中)插入，添加内容; 插值; 内插;

When dealing with either linear or radial gradient color, pay special attention to the proportional attribute. By setting this attribute to false, you can draw a line (the gradient axis) having a beginning point (start X, start Y) and an end point (end X, end Y) based on standard screen (x, y) coordinates.

However, if the proportional attribute is set to a value of true, the gradient axis line beginning and ending points will be represented as unit square coordinates. This means that x, y coordinates for begin and end points must be between 0.0 and 1.0 (double). This strategy is more compact and easier to define than screen coordinates on the scene graph.

### Radial Gradient

The amazing thing about colors with gradients is that they can often make shapes appear three-dimensional. Gradient paint allows you to interpolate between two or more colors, which gives depth to the shape. JavaFX provides two types of gradients: a radial (RadialGradient) and a linear (LinearGradient) gradient. For our ellipse shape you will be using a radial gradient (RadialGradient).

Table 2-2 presents the JavaFX 8 Javadoc definitions found for the RadialGradient class. 

| Property      | Data Type    | Description                                                  |
| ------------- | ------------ | ------------------------------------------------------------ |
| focusAngle    | Double       | Angle in degrees from the center of the gradient to the focus point to which the first color is mapped. |
| focusDistance | Double       | Distance from the center of the gradient to the focus point to which the first color is mapped. |
| centerX       | Double       | X coordinate of the center point of the gradient’s circle.   |
| centerY       | Double       | Y coordinate of the center point of the gradient’s circle.   |
| radius        | Double       | Radius of the circle defining the extents of the color gradient. |
| proportional  | boolean      | Coordinates and sizes are proportional to the shape this gradient fills. |
| cycleMethod   | CycleMethod  | Cycle method applied to the gradient.                        |
| Stops         | `List<Stop>` | Gradient’s color specification.                              |

In our example the focus angle is set to zero, the distance is set to .1, center X and Y are set to (80, 45), the radius is set to 120 pixels, proportional is set to false, the cycle method is set to the no cycle (CycleMethod.NO_CYCLE), and two color stop values set to red (Color.RED) and black (Color.BLACK). These settings give a radial gradient to our ellipse by starting with the color red with a center position of (80, 45) (upper left of the ellipse) that interpolates to the color black with a distance of 120 pixels (radius).

### Semitransparent Gradient

Next, you will see how to create the rectangle, which has a yellow semitransparent linear gradient. For our yellow rectangle you will use a linear gradient (LinearGradient) paint.

Table 2-3 presents the JavaFX 8 Javadoc definitions found for the LinearGradient class. 

| Property     | Data Type    | Description                                                  |
| ------------ | ------------ | ------------------------------------------------------------ |
| startX       | Double       | X coordinate of the gradient axis start point.               |
| startY       | Double       | Y coordinate of the gradient axis start point.               |
| endX         | Double       | X coordinate of the gradient axis end point.                 |
| endY         | Double       | Y coordinate of the gradient axis end point.                 |
| proportional | Boolean      | Whether the coordinates are proportional to the shape which this gradient fills. When set to true use unit square coordinates, otherwise use scene/screen coordinate system. |
| cycleMethod  | CycleMethod  | Cycle method applied to the gradient.                        |
| stops        | `List<Stop>` | Gradient’s color specification.                              |

To create a linear gradient paint, you specify startX, startY, endX, and endY for the start and end points. The start and end point coordinates denote where the gradient pattern begins and stops.

To create the second shape in Figure 2-10, the yellow rectangle, you set the start X and Y to (0.0, 0.0), end X and Y to (0.0, 1.0), proportional to true, the cycle method to no cycle (CycleMethod.NO_CYCLE), and two color stop values to yellow (Color.YELLOW) and black (Color.BLACK) with an alpha transparency of .784.These settings give a linear gradient to our rectangle from top to bottom with a starting point of (0.0, 0.0) (the top left of a unit square) that interpolates to the color black to an end point of (0.0, 1.0) (the bottom left of a unit square).

### Reflective Cycle Gradients

Finally, at the bottom of Figure 2-10 you’ll notice a rounded rectangle with a repeating pattern of a gradient using green and black in a diagonal direction. This is a simple linear gradient paint that is the same as the linear gradient paint (LinearGradient) except that the start X, Y and end X, Y values are set in a diagonal position, and the cycle method is set to reflect (CycleMethod.REFLECT). When specifying the cycle method to reflect (CycleMethod.REFLECT), the gradient pattern will repeat or cycle between the stop colors. The following code snippet implements the rounded rectangle having a cycle method of reflect (CycleMethod.REFLECT):

~~~java
LinearGradient cycleGrad = new LinearGradient(
    50, // start X
    50, // start Y
    70, // end X
    70, // end Y
    false, // proportional
    CycleMethod.REFLECT, // cycleMethod
    new Stop(0f, Color.rgb(0, 255, 0, .784)),
    new Stop(1.0f, Color.rgb(0, 0, 0, .784))
);
~~~

## Drawing Text

Another basic JavaFX node is the Text node. Text nodes allow you to display a string of characters onto the scene graph. To create Text nodes on the JavaFX scene graph you will use the `javafx.scene.text.Text` class. Because all JavaFX scene nodes extend from `javafx.scene.Node` they will inherit many capabilities such as the ability to be scaled, translated, or rotated.

Based on the Java inheritance hierarchy, the Text node’s direct parent is a `javafx.scene.shape.Shape` class which provides even more capabilities than the Node class. Because a Text node is both a Node and a Shape object it is able to perform geometric operation between two shape areas such as subtract, intersect, or union. You can also clip viewport areas with a shape similar to stenciled letters.

> stencil	英[ˈstensl] 美[ˈstensl]
> n.	(印文字或图案用的)模板; (用模板印的)文字或图案;
> v.	用模板印(文字或图案);

To demonstrate drawing text, in this section you will look at a basic example of how to draw text nodes on the scene graph. This example will touch on the following three capabilities:

- Positioning Text nodes using (x, y) coordinates
- Setting a Text node’s stroke color
- Rotating a Text node about its pivot point

The DrawingText.java code shown in Listing 2-4 creates 100 Text nodes with randomly generated values for the following attributes:

- x, y coordinates
- RGB fill color
- Angle of rotation (degrees).

The code first creates a loop to generate random (x, y) coordinates to position Text nodes. In the loop, it creates random RGB color components between 0 and 255 to be applied to the Text nodes. Setting all components to zero produces black. Setting all three RGB values to 255 produces the color white.

~~~java
@Override
public void start(Stage primaryStage) {
    primaryStage.setTitle("Chapter 2 Drawing Text");
    Group root = new Group();
    Scene scene = new Scene(root, 300, 250, Color.WHITE);
    Random rand = new Random(System.currentTimeMillis());
    for (int i = 0; i < 100; i++) {
        int x = rand.nextInt((int) scene.getWidth());
        int y = rand.nextInt((int) scene.getHeight());
        int red = rand.nextInt(255);
        int green = rand.nextInt(255);
        int blue = rand.nextInt(255);
        
        Text text = new Text(x, y, "JavaFX 8");
        
        int rot = rand.nextInt(360);
        text.setFill(Color.rgb(red, green, blue, .99));
        text.setRotate(rot);
        root.getChildren().add(text);
    }
    primaryStage.setScene(scene);
    primaryStage.show();
}
~~~

The rotation angle (in degrees) is a randomly generated value from 0–360 degrees, which causes the baseline of the text to be tilted. According to the API documentation the setRotate() method will rotate about the pivot point, which is the center of the untransformed layout bounds (layoutBounds) property. Basically, the pivot point is the center of a node that has no transforms (scaling, translating, shearing, rotating, and so on) applied.

> **Note** If you need to use a combination of transforms, such as rotate, scale, and translate, take a look at the `getTransforms().add(...)` method. For more details on the difference between bounds in local, bounds in parent, and layout bounds, please see the Javadoc documentation.

The following code is used in DrawingText.java to create random values for a Text node’s x and y position (baseline), color, and rotation:

~~~java
int x = rand.nextInt((int) scene.getWidth());
int y = rand.nextInt((int) scene.getHeight());
int red = rand.nextInt(255);
int green = rand.nextInt(255);
int blue = rand.nextInt(255);
int rot = rand.nextInt(360);
~~~

Once the random values are generated, they are applied to the Text nodes, which will be drawn onto the scene graph. Each Text node maintains a text origin property that contains the starting point of its baseline. In Latin-based alphabets, the baseline is an imaginary line underneath letters, similar to books on a bookshelf. However, some letters, such as the lowercase *j*, extend below the baseline. When specifying the x and y coordinate of the Text node you will be positioning the start of the baseline. In Figure 2-12, the x and y coordinate is located left of the lowercase j on the baseline in the text node “javafx 8.”

The following code snippet applies (x, y) coordinates, color (RGB) with an opacity .99 and a rotation (angle in degrees) to the Text node:

~~~java
Text text = new Text(x, y, "JavaFX 8");
text.setFill(Color.rgb(red, green, blue, .99));
text.setRotate(rot);

root.getChildren().add(text);
~~~

### Changing Text Fonts

JavaFX’s Font API enables you to change font styles and font sizes in the same way as word processing applications. To demonstrate it, I created a JavaFX application that displays four text nodes with the string value of “JavaFX 8 Intro by Example,” each having a different font style. In addition to the font styles I also added effects such as a drop shadow (DropShadow) and reflection (Reflection).

Figure 2-13 shows the example’s output, and Listing 2-5 shows the ChangingTextFonts.java source code.

~~~java
@Override
public void start(Stage primaryStage) {
    primaryStage.setTitle("Chapter 2 Changing Text Fonts");
    
    System.out.println("Font families: ");
    Font.getFamilies()
        .stream()
        .forEach( i -> System.out.println(i));
    System.out.println("Font names: ");
    Font.getFontNames()
        .stream()
        .forEach( i -> System.out.println(i));
    Group root = new Group();
    Scene scene = new Scene(root, 580, 250, Color.WHITE);
    
    // Serif with drop shadow
    Text text2 = new Text(50, 50, "JavaFX 8: Intro. by Example");
    Font serif = Font.font("Serif", 30);
    text2.setFont(serif);
    text2.setFill(Color.RED);
    DropShadow dropShadow = new DropShadow();
    dropShadow.setOffsetX(2.0f);
    dropShadow.setOffsetY(2.0f);
    dropShadow.setColor(Color.rgb(50, 50, 50, .588));
    text2.setEffect(dropShadow);
    root.getChildren().add(text2);
    
    // SanSerif
    Text text3 = new Text(50, 100, "JavaFX 8: Intro. by Example");
    Font sanSerif = Font.font("SanSerif", 30);
    text3.setFont(sanSerif);
    text3.setFill(Color.BLUE);
    root.getChildren().add(text3);
    
    // Dialog
    Text text4 = new Text(50, 150, "JavaFX 8: Intro. by Example");
    Font dialogFont = Font.font("Dialog", 30);
    text4.setFont(dialogFont);
    text4.setFill(Color.rgb(0, 255, 0));
    root.getChildren().add(text4);
    
    // Monospaced
    Text text5 = new Text(50, 200, "JavaFX 8: Intro. by Example");
    Font monoFont = Font.font("Monospaced", 30);
    text5.setFont(monoFont);
    text5.setFill(Color.BLACK);
    root.getChildren().add(text5);
    
    // Reflection
    Reflection refl = new Reflection();
    refl.setFraction(0.8f);
    refl.setTopOffset(5);
    text5.setEffect(refl);
    
    primaryStage.setScene(scene);
    primaryStage.show();
}
~~~

With Text nodes JavaFX takes a retained-mode approach, in which nodes are using vector-based graphics rendering instead of an immediate mode rendering. The immediate mode uses bitmap graphic rendering strategies. By using vector-based graphics you will have nifty advantages over bitmap graphics. The major advantage is that it allows you to scale shapes and apply different effects without pixilation (the jaggies). For example, in an immediate mode rendering the image becomes grainy when scaled larger; however, in retained mode you will have smooth (anti-aliased) shapes. It’s nice to be able to see beautiful type fonts (typography) that are smooth at all sizes.

> nifty	英[ˈnɪfti] 美[ˈnɪfti]
> adj.	有技巧的; 精确的; 实用的; 灵便的;
> n.	俏皮话; 漂亮话;
>
> jaggy	
> 网络	锯齿; 边缘部分锯齿; 向行驶的线路很少锯齿; 无锯齿;
>
> grainy	英[ˈɡreɪni] 美[ˈɡreɪni]
> adj.	有颗粒的; 粒状的; 有纹的; 表面粗糙的; 粒面的;
>
> typography 英[taɪˈpɒɡrəfi] 美[taɪˈpɑːɡrəfi]
> n.	印刷术; 排印; 版面设计;

ChangingTextFonts.java focuses on the following JavaFX classes to be applied to the Text node. The code uses the Serif, SanSerif, Dialog, and Monospaced fonts along with the drop shadow and reflection effects.

- javafx.scene.text.Font
- javafx.scene.effect.DropShadow
- javafx.scene.effect.Reflection

The code begins by setting the title on the stage. Next, you will notice the new Java 8 language lambdas feature at work, where the code lists the current system’s available font families and font names. If you are new to lambdas, in Chapter 3 you will take a closer look at the concept, but for right now you can think of it as an elegant way to iterate over collections. The font family and font name list will be printed on the console output. This is very convenient for you to later experiment with different font styles. The following lines list the available fonts on the current system using Java 8’s lambda syntax (as we’ll discuss in Chapter 3):

~~~java
System.out.println("Font families: ");
Font.getFamilies()
    .stream()
    .forEach( i -> System.out.println(i));
System.out.println("Font names: ");
Font.getFontNames()
    .stream()
    .forEach( i -> System.out.println(i));
~~~

A fter listing the available fonts, the code creates a root node with a background color for its scene. Before drawing the first Text node, let’s quickly discuss how to obtain a font. To obtain a font the code invokes the static method font() from the Font class. When calling the font() method, you can specify the font name and the point size to return a suitable font to the caller. A font name is a string value that represents a system’s supported font types. Secondly, is the point size or standard sizing value for fonts. Please refer to the Javadoc documentation to see the other ways to obtain system fonts. The following lines show the creation of a Text node instance and obtaining a 30 point Serif font. Once the font is obtained the Text node setFont() method is used to apply the font.

~~~java
Text text = new Text(50, 50, "JavaFX 8: Intro. by Example");
Font serif = Font.font("Serif", 30);
text.setFont(serif);
~~~

> **Note** Although, the example listing 2-5 uses absolute positioning of text nodes at some point you may want to display text nodes with the ability to wrap several text nodes while keeping their own font formatting in the same layout. To achieve this behavior refer to JavaFX 8’s new TextFlow API. 

### Applying Text Effects

In the first Text node in the ChangingTextFonts.java example, the code adds a drop shadow effect. In JavaFX a drop shadow is an actual effect (DropShadow) object and is applied to a single Text node instance without the need of multiple images layered. The DropShadow object is set to be positioned based on an x, y offset in relation to the Text node. You also have the ability to set the color of the shadow; here the code will set the shadow color to gray with 0.588 opacity. Opacity is a range between 0 and 1 (double) where 0 is transparent and 1 is fully opaque. The following is an example of setting a Text node’s effect property with a drop shadow effect (DropShadow):

~~~java
DropShadow dropShadow = new DropShadow();
dropShadow.setOffsetX(2.0f);
dropShadow.setOffsetY(2.0f);
dropShadow.setColor(Color.rgb(50, 50, 50, .588));
text2.setEffect(dropShadow);
~~~

Although this example is about setting text fonts, it also demonstrates applying a drop shadow effect to Text nodes. The ChangingTextFonts.java example includes yet another effect. While creating the last Text node using the monospaced font, I’ve applied the popular reflection effect. Calling the setFraction() method with 0.8f is essentially specifying that you want 80 percent of the reflection to be shown. The reflection values range from zero (0%) to one (100%). In addition to the fraction to be shown, the reflection’s gap or top offset can be set. In other words the space between the opaque node portion and the reflection portion is adjusted by the setTopOffset() method. The top offset defaults to zero. The following code snippet implements a reflection of 80% with a float value of 0.8f and a top offset of five pixels:

~~~java
Reflection refl = new Reflection();
refl.setFraction(0.8f);
refl.setTopOffset(5);
text5.setEffect(refl);
~~~

# Chapter 3: Lambdas and Properties

## Properties and Binding

Properties are basically wrapper objects for JavaFX-based object attributes such as String or Integer. Properties allow developers to add listener code to respond when the wrapped value of an object has changed or is flagged as invalid. Also, property objects can be bound to one another. Binding behavior allows properties to update or synchronize their values based on a changed value from another property.

### UI Patterns（UI模式）

Before discussing JavaFX’s properties and bindings APIs, I would like to share with you a little bit about UI patterns. When developing GUI applications you will inevitably encounter UI architectural framework concepts such as model view controller (MVC), model view presenter (MVP), or model view view-model (MVVM).

Depending on who you talk to, you might get different explanations; however, these concepts all address the issue of how best to handle synchronization between the model and view. What this means is that when a user interacts (input) with the UI (view) the underlying backend data store (the model) is automatically updated, and vice-versa.

Without trying to oversimplify the concepts, I will refer you to the actual UI patterns that are involved. The main UI patterns involved are the *Supervising Controller*, *Presentation Model,* and *Mediator*. If you are interested in understanding more about UI patterns, please read “GUI Architectures” by Martin Fowler 

Because these patterns have been heavily discussed over the years, the JavaFX team has designed and implemented APIs to overcome problems that arose with these UI scenarios. In this section you will be learning how to use JavaFX properties and bindings to synchronize between your GUI and your data objects. Of course, I can’t possibly cover all of the use-case scenarios involving the UI patterns just mentioned, but hopefully I can give you the basics to get you on the right path.

### Properties

Before the JavaFX properties API, Java Swing developers adhered to the JavaBean convention (specification), which specifies that objects will contain privately scoped instance variables which have associated getter (accessor) and setter (mutator) methods. For instance, a User class might have a private instance variable password of type String. The associated getter and setter would be the getPassword() and setPassword() methods, respectively. Listing 3-22 shows a User class that follows the older JavaBean convention.

~~~java
public class User {
    private String password;
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
}
~~~

As a developer who follows the JavaBean convention, you will quickly see the naming convention for the property, which is based on the getter and setter method names and not the private variable name. In other words, if the getter method were named getPwd(), the property would be named pwd and would have nothing to do with the attribute named password.

The JavaBeans specification also provided an API that has the concept of property change support (java.beans.PropertyChangeSupport), which allowed the developer to add handler (listener) code when the property changed. At the time, this solved only part of the issue of property change support. The JavaBeans API started showing its age when it came to binding variables and working with the Collections API. Although the JavaBeans API became a standard way to build domain objects, it still lacked robust ways to synchronize the domain models and views within a GUI application as described earlier.

Through the years the JavaBean specification and API gave rise to many third-party tools and frameworks to ease the developer experience. However, wiring up GUI components to JavaBeans using unidirectional or bidirectional binding still got pretty complicated. At times, developers would have resources that were not properly released, which led to object leaks. Developers quickly realized they needed a better way to bind and unbind GUI controls to be wired up to properties.

### Types of JavaFX Properties

Let’s fast forward to JavaFX’s Properties API to see how it handles the common issues. We’ll first discuss the different types of JavaFX-based properties. There are two types to be concerned about:

- Read/Writable
- Read-Only

In short, JavaFX’s properties are wrapper objects holding actual values while providing change support, invalidation support, and binding capabilities. I will address binding later, but for now let’s examine commonly used property classes.

Properties are wrapper objects that have the ability to make values accessible as read/writable or read-only. All wrapper property classes are located in the javafx.beans.property.* package namespace. Listed here are commonly used property classes. To see all of the property classes, please refer to the documentation in Javadoc.

-	javafx.beans.property.SimpleBooleanProperty
-	javafx.beans.property.ReadOnlyBooleanWrapper
-	javafx.beans.property.SimpleIntegerProperty
-	javafx.beans.property.ReadOnlyIntegerWrapper
-	javafx.beans.property.SimpleDoubleProperty
-	javafx.beans.property.ReadOnlyDoubleWrapper
-	javafx.beans.property.SimpleStringProperty
-	javafx.beans.property.ReadOnlyStringWrapper

The properties that have a prefix of Simple and a suffix of Property are the read/writable property classes, and the classes with a prefix of ReadOnly and a suffix of Wrapper are the read-only properties. Later, you will see how to create a JavaFX bean using these commonly used properties, but for now let’s examine read/writable properties.

#### Read/Writable Properties

Read/writable properties are, as the name suggests, property values that can be both read and modified. As an example, let’s look at JavaFX string properties. To create a string property that is capable of both readable and writable access to the wrapped value, you will use the `javafx.beans.property.SimpleStringProperty` class. Listing 3-23 is a code snippet that demonstrates an instance of a SimpleStringProperty class and modifies the property via the set() method.

~~~java
StringProperty password = new SimpleStringProperty("password1");
password.set("1234");
System.out.println("Modified StringProperty " + password.get() ); // 1234
~~~

Here a declared variable password of type StringProperty is assigned to an instance of a SimpleStringProperty class. It’s always a good idea when declaring variables to be more abstract in object-oriented languages. Thus, referencing a StringProperty exposes fewer methods of the implementation class (SimpleStringProperty). Also notice that the actual value is the string “password1”, which is passed into the constructor of the SimpleStringProperty class. You will later discover other convenient constructor methods when working with JavaBeans and Property objects.

In the case of reading the value back, you would invoke the get() method (or getValue()), which returns the actual wrapped value(String) to the caller. To modify the value you simply call the set() method (or setValue()) by passing in a string. 

#### Read-Only Properties

To make a property read-only you would use the wrapper classes that are prefixed with ReadOnly from the javafx.beans.property.* package. To create a property to be read-only you will need to take two steps. First is to instantiate a read-only wrapper class and invoke the method getReadOnlyProperty() to return a true read-only property object. Listing 3-24 creates a read-only string property.

~~~java
ReadOnlyStringWrapper userName = new ReadOnlyStringWrapper("jamestkirk");
ReadOnlyStringProperty readOnlyUserName = userName.getReadOnlyProperty();
~~~

This code snippet actually takes two steps to obtain a read-only string property. You will notice the call to getReadOnlyProperty(), which returns a read-only copy (synchronized) of the property. According to the Javadoc API, the ReadOnlyStringWrapper class “creates two properties that are synchronized. One property is read-only and can be passed to external users. The other property is read- and writable and should be used internally only.” Knowing that the other property can be read and written could allow a malicious developer to cast the object to type StringProperty, which then could be modified at will. From a security perspective you should be aware of the proper steps to create a true read-only property.

### JavaFX JavaBean

Now that you’ve seen the JavaBean specification’s approach to creating domain objects, I will rewrite the earlier JavaBean User class to use JavaFX properties instead. In the process of rewriting the bean I also wanted to add an additional read-only property called userName to demonstrate the read-only property behavior. Listing 3-25 shows the User class rewritten to use JavaFX properties.

~~~java
import javafx.beans.property.*;
public class User {
    private final static String USERNAME_PROP_NAME = "userName";
    private final ReadOnlyStringWrapper userName;
    private final static String PASSWORD_PROP_NAME = "password";
    private StringProperty password;
    public User() {
        userName = new ReadOnlyStringWrapper(this, USERNAME_PROP_NAME, System.getProperty("user.name"));
        password = new SimpleStringProperty(this, PASSWORD_PROP_NAME, "");
    }

    public final String getUserName() {
        return userName.get();
    }
    public ReadOnlyStringProperty userNameProperty() {
        return userName.getReadOnlyProperty();
    }

    public final String getPassword() {
        return password.get();
    }
    public final void setPassword(String password) {
        this.password.set(password);
    }
    public StringProperty passwordProperty() {
        return password;
    }
}
~~~

You may notice some obvious differences in the way I instantiated the ReadOnlyStringWrapper and SimpleStringProperty classes. Similar to the JavaBean property change support, JavaFX properties have constructors that will allow you to specify the bean itself, its property name, and its value. As a simple example, Listing 3-26 shows the instantiations of a read-only and a read-writable property using the JavaFX property change support-based constructors. The userName variable is assigned a read-only property, and the password variable is assigned a read/writable property.

~~~java
userName = new ReadOnlyStringWrapper(this, USERNAME_PROP_NAME, System.getProperty("user.name"));
password = new SimpleStringProperty(this, PASSWORD_PROP_NAME, "");
~~~

It is good practice to use the property change support-based constructors for many reasons, such as third-party tooling and testing. But most of all, when dealing with property change support, you will need access to the bean and its other properties.

One last thing to mention is that in Listing 3-25 you’ll also notice the getter and setter methods are final. Making the getter and setter final prevents any derived classes from overriding and possibly changing the underlying property

### Property Change Support

*Property change support* is the ability to add handler code that will respond when a property changes. JavaFX property objects contain an addListener() method. This method will accept two types of functional interfaces, ChangeListener and InvalidationListener. Recall that functional interfaces are single abstract methods which are expressed using the Java lambda syntax. All JavaFX properties are descendants of the ObservableValue and Observable interfaces (method overloading), which provide the addListener() methods for ChangeListener and InvalidationListener, respectively. One last thing to point out is that it is important to clean up listeners by removing them. To remove them you will invoke the removeListener() method by passing into it a referenced (named) listener as opposed to an anonymous inner class or anonymous lambda expression.

Listing 3-27 shows how to create a ChangeListener to be registered with a property. As the property’s value changes, the change() method will be invoked. I’ve provided the implementations for both the anonymous inner class and lambda expression-style syntax for you to compare.

~~~java
SimpleIntegerProperty xProperty = new SimpleIntegerProperty(0);

// Adding a change listener (anonymous inner class)
xProperty.addListener(new ChangeListener<Number>(){
    @Override
    public void changed(ObservableValue<? extends Number> ov, Number oldVal, Number newVal) {
        // code goes here
    }
});

// Adding a change listener (lambda expression)
xProperty.addListener((ObservableValue<? extends Number> ov, Number oldVal, Number newVal) -> {
    // code goes here
});
~~~

Listing 3-28 shows how to create an InvalidationListener to be registered with a property. As the property’s value changes, the invalidated () method will be invoked. I’ve provided the implementations for both the anonymous inner class and lambda expression-style syntax for you to compare.

~~~java
// Adding a invalidation listener (anonymous inner class)
xProperty.addListener(new InvalidationListener() {
    @Override
    public void invalidated(Observable o) {
        // code goes here
    }
});

// Adding a invalidation listener (lambda expression)
xProperty.addListener((Observable o) -> {
    // code goes here
});
~~~

Often developers become confused about the difference between a ChangeListener and an InvalidationListener. In Listing 3-28 you’ll notice that using a ChangeListener you will get the Observable (ObservableValue), the old value, and the new value, while using the InvalidationListener only gets the Observable object (property).

In the Javadoc documentation, the difference between a ChangeListener and InvalidationListener is described as follows:

“A change event indicates that the value has changed. An invalidation event is generated, if the current value is not valid anymore. This distinction becomes important, if the *ObservableValue* supports lazy evaluation, because for a lazily evaluated value one does not know if an invalid value really has changed until it is recomputed. For this reason, generating change events requires eager evaluation while invalidation events can be generated for eager and lazy implementations.”

The InvalidationListener provides a way to mark values as invalid but does not recompute the value until it is needed. This is often used in UI layouts or custom controls, where you can avoid unnecessary computations when nodes don’t need to be redrawn/repositioned during a layout request or draw cycle. When using the ChangeListener, you normally want eager evaluation such as the validation of properties on a form-type application. That doesn’t mean you can’t use InvalidationListeners for validation of properties; it just depends on your performance requirements and exactly when you need the new value to be recomputed (evaluated). When you access the observable value, it causes the InvalidationListener to be eager.

## Binding

Simply put, binding has the idea of at least two values (properties) being synchronized. This means that when a dependent variable changes, the other variable changes. JavaFX provides many binding options that enable the developer to synchronize between properties in domain objects and GUI controls. In this section you will learn about three binding strategies when binding property objects.

In this section you will be focusing on the following JavaFX API packages:

- javafx.beans.binding.*
- javafx.beans.property.*

Binding of properties is quite easy to do. The only requirement is that the property invoking the bind must be a read/writeable property. To bind a property to another property, you will invoke the bind() method. This method will bind in one direction (unidirectional). For instance, when property A binds to property B the change in property B will update property A, but not the other way. If A is bound to B you can’t update A, as you’ll get a RuntimeException: A bound value cannot be set.

The following are three additional binding strategies to consider using in JavaFX’s Properties API:

- Bidirectional binding on a Java Bean
- High-level binding using the Fluent API
- Low-level binding using javafx.beans.binding.* binding objects

### Bidirectional Binding

Bidirectional binding allows you to bind properties with the same type allowing changes on either end while keeping a value synchronized. When binding bi-directionally, it’s required that both properties must be read/writable. It’s pretty easy to bind two properties bidirectionally through the use of the bindBidirectional() method. To demonstrate, I’ve created a simple example. 

Listing 3-29 is a Contact bean having a property firstName that is bound bidirectionally to a local variable fname of type StringProperty.

~~~java
Contact contact = new Contact("John", "Doe");
StringProperty fname = new SimpleStringProperty();
fname.bindBidirectional(contact.firstNameProperty());

contact.firstNameProperty().set("Play");
fname.set("Jane");

System.out.println("contact.firstNameProperty = " + contact.firstNameProperty().get() );
System.out.println("fname = " + fname.get() );
~~~

The output of this code snippet is as follows:

~~~
contact.firstNameProperty = Jane
fname = Jane
~~~

### High-level Binding

Introduced in JavaFX 2.0 is a fluent interface API to bind properties. The fluent APIs are methods that allow you to perform operations on properties using English-like method names. For example, if you have a numeric property, there would be methods like multiply(), divide(), subtract(), and so on. Another example would be a string property having methods like isEqualTo(), isNotEqualTo(), concat(), and similar. As an example, Listing 3-30 shows how to create a property that represents the formula for the area of a rectangle.

~~~java
// Area = width * height
IntegerProperty width = new SimpleIntegerProperty(10);
IntegerProperty height = new SimpleIntegerProperty(10);
 
NumberBinding area = width.multiply(height);
~~~

This code demonstrates high-level binding by using the fluent API from the javafx.beans.binding.IntegerExpression parent interface. This example binds by using the multiply() method, which returns a NumberBinding containing the computed value. What’s nice is that the binding is lazy-evaluated, which means the computation (multiplying) doesn’t occur unless you invoke the property’s (area) value via the get() (or getValue())method. For all available fluent interfaces, please see the Javadoc for javafx.beans.binding.* packages.

### Low-level Binding

When using low-level binding, you would use a derived NumberBinding class, such as a DoubleBinding class for values of type Double. With a DoubleBinding class you will override its computeValue() method so that you can use the familiar operators such as * and – to formulate complex math equations. The difference between high-and low-level binding is that high-level uses methods such as multiply(), subtract() instead of the operators * and –. Listing 3-31 shows how to create a low-level binding for the formula for the volume of a sphere.

~~~java
DoubleProperty radius = new SimpleDoubleProperty(2);
DoubleBinding volumeOfSphere = new DoubleBinding() {
    {
        super.bind(radius); // initial bind
    }
    @Override
    protected double computeValue() {
        // Math.pow() (power) cubes the radius
        return (4 / 3 * Math.PI * Math.pow(radius.get(), 3));
    }
};
~~~

If you’ve gotten this far, you are definitely ready to begin building GUIs. So far you’ve had a chance to learn about lambda expressions, properties, and bindings. Next, I want to close out this chapter with an example showing how to build a snazzy-looking logon dialog window that makes use of shapes, lambda expressions, properties, and bindings (with a hint of UI controls).

## A Logon Dialog Example

### Login Dialog Source Code

Listing 3-32 is the source code for the JavaFX example logon dialog application

~~~java
package jfx8ibe;
import javafx.application.*;
import javafx.beans.property.*;
import javafx.geometry.Pos;
import javafx.scene.*;
import javafx.scene.control.PasswordField;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.scene.shape.*;
import javafx.scene.text.*;
import javafx.stage.*;
/**
 * A login form to demonstrate lambdas, properties, and bindings.
 * @author cdea
 */
public class FormValidation extends Application {

    private final static String MY_PASS = "password1";
    private final static BooleanProperty GRANTED_ACCESS = new SimpleBooleanProperty(false);
    private final static int MAX_ATTEMPTS = 3;
    private final IntegerProperty ATTEMPTS = new SimpleIntegerProperty(0);

    @Override
    public void start(Stage primaryStage) {
        // create a model representing a user
        User user = new User();

        // create a transparent stage
        primaryStage.initStyle(StageStyle.TRANSPARENT);

        Group root = new Group();
        Scene scene = new Scene(root, 320, 112, Color.rgb(0, 0, 0, 0));
        primaryStage.setScene(scene);
        
        // all text, borders, svg paths will use white
        Color foregroundColor = Color.rgb(255, 255, 255, .9);

        // rounded rectangular background
        Rectangle background = new Rectangle(320, 112);
        background.setX(0);
        background.setY(0);
        background.setArcHeight(15);
        background.setArcWidth(15);
        background.setFill(Color.rgb(0, 0, 0, .55));
        background.setStrokeWidth(1.5);
        background.setStroke(foregroundColor);

        // a read only field holding the user name.
        Text userName = new Text();
        userName.setFont(Font.font("SanSerif", FontWeight.BOLD, 30));
        userName.setFill(foregroundColor);
        userName.setSmooth(true);
        userName.textProperty()
            .bind(user.userNameProperty());

        // wrap text node
        HBox userNameCell = new HBox();
        userNameCell.prefWidthProperty()
            .bind(primaryStage.widthProperty()
                  .subtract(45));
        userNameCell.getChildren().add(userName);

        // pad lock
        SVGPath padLock = new SVGPath();
        padLock.setFill(foregroundColor);
        padLock.setContent("M24.875,15.334v-4.876c0-4.894-3.981-8.875-8.875-8.875s-8.875,3.981-8.875,8.875v4.876H5.042v15.083h21.916V15.334H24.875zM10.625,10.458c0-2.964,2.411-5.375,5.375-5.375s5.375,2.411,5.375,5.375v4.876h-10.75V10.458zM18.272,26.956h-4.545l1.222-3.667c-0.782-0.389-1.324-1.188-1.324-2.119c0-1.312,1.063-2.375,2.375-2.375s2.375,1.062,2.375,2.375c0,0.932-0.542,1.73-1.324,2.119L18.272,26.956z");

        // first row
        HBox row1 = new HBox();
        row1.getChildren()
            .addAll(userNameCell, padLock);

        // password text field
        PasswordField passwordField = new PasswordField();
        passwordField.setFont(Font.font("SanSerif", 20));
        passwordField.setPromptText("Password");
        passwordField.setStyle("-fx-text-fill:black; "
                               + "-fx-prompt-text-fill:gray; "
                               + "-fx-highlight-text-fill:black; "
                               + "-fx-highlight-fill: gray; "
                               + "-fx-background-color: rgba(255, 255, 255, .80); ");
        passwordField.prefWidthProperty()
            .bind(primaryStage.widthProperty()
                  .subtract(55));
        user.passwordProperty()
            .bind(passwordField.textProperty());

        // error icon
        SVGPath deniedIcon = new SVGPath();
        deniedIcon.setFill(Color.rgb(255, 0, 0, .9));
        deniedIcon.setStroke(Color.WHITE);//
        deniedIcon.setContent("M24.778,21.419 19.276,15.917 24.777,10.415 21.949,7.585 16.447,13.087 10.945,7.585 8.117,10.415 13.618,15.917 8.116,21.419 10.946,24.248 16.447,18.746 21.948,24.248z");
        deniedIcon.setVisible(false);

        SVGPath grantedIcon = new SVGPath();
        grantedIcon.setFill(Color.rgb(0, 255, 0, .9));
        grantedIcon.setStroke(Color.WHITE);//
        grantedIcon.setContent("M2.379,14.729 5.208,11.899 12.958,19.648 25.877,6.733 28.707,9.561 12.958,25.308z");
        grantedIcon.setVisible(false);

        StackPane accessIndicator = new StackPane();
        accessIndicator.getChildren()
            .addAll(deniedIcon, grantedIcon);
        accessIndicator.setAlignment(Pos.CENTER_RIGHT);

        grantedIcon.visibleProperty().bind(GRANTED_ACCESS);

        // second row
        HBox row2 = new HBox(3);
        row2.getChildren()
            .addAll(passwordField, accessIndicator);
        HBox.setHgrow(accessIndicator, Priority.ALWAYS);

        // user hits the enter key
        passwordField.setOnAction(actionEvent -> {
            if (GRANTED_ACCESS.get()) {
                System.out.printf("User %s is granted access.\n",
                                  user.getUserName());
                System.out.printf("User %s entered the password: %s\n",
                                  user.getUserName(), user.getPassword());
                Platform.exit();
            } else {
                deniedIcon.setVisible(true);
            }
            ATTEMPTS.set(ATTEMPTS.add(1).get());
            System.out.println("Attempts: " + ATTEMPTS.get());
        });
        // listener when the user types into the password field
        passwordField.textProperty().addListener((obs, ov, nv) -> {
            boolean granted = passwordField.getText()
                .equals(MY_PASS);
            GRANTED_ACCESS.set(granted);
            if (granted) {
                deniedIcon.setVisible(false);
            }
        });

        // listener on number of attempts
        ATTEMPTS.addListener((obs, ov, nv) -> {
            if (MAX_ATTEMPTS == nv.intValue()) {
                // failed attemps
                System.out.printf("User %s is denied access.\n",
                                  user.getUserName());
                Platform.exit();
            }
        });

        VBox formLayout = new VBox(4);
        formLayout.getChildren().addAll(row1, row2);
        formLayout.setLayoutX(12);
        formLayout.setLayoutY(12);
        root.getChildren().addAll(background, formLayout);
        primaryStage.show();
    }
    public static void main(String[] args) {
        launch(args);
    }
}
~~~

### Explanation of the Code

The JavaFX application in Listing 3-32 simulates a logon dialog window. The code mainly demonstrates binding JavaFX JavaBeans properties with UI controls by reusing the User class that was shown earlier, in Listing 3-25.

# Chapter 4: Layouts and UI Controls

## Layouts

One of the greatest challenges in building user interfaces is the laying out of UI controls onto the display area. In GUI applications it is ideal to allow the user to resize a viewable area while UI controls also resize in order to provide a pleasant user experience. Similar to Java’s Swing API, the JavaFX API has stock layouts that provide the most common ways to display UI controls onto the scene graph. Following are the JavaFX layouts discussed in this section:

- javafx.scene.layout.HBox
- javafx.scene.layout.VBox 
- javafx.scene.layout.FlowPane
- javafx.scene.layout.BorderPane
- javafx.scene.layout.GridPane

### HBox

The HBox layout’s job is to place JavaFX child nodes in a horizontal row. As child nodes are added consecutively, each is appended to the end (right side). By default, the HBox layout honors the child’s preferred width and height. When the parent node is not resizable (a Group node, for example), the row height of the HBox takes on the height of the child node with the greatest preferred height. Also, by default each child node aligns to the top-left (Pos.TOP_LEFT) position.

The HBox can be configured to have resizing ranges to allow the parent to manage and calculate space available upon layout requests. There are many ways you can programmatically alter the HBox’s layout constraints, such as border, padding, margin, spacing, and alignment. Although in this chapter you will learn how to set constraints using a programmatic approach, there are also alternative strategies. One well known and preferred strategy is to style or set constraints using JavaFX CSS attributes; you will catch a glimpse of that approach later in this chapter, and more details in Chapter 6, on custom UIs.

> glimpse	英[ɡlɪmps] 美[ɡlɪmps]
> n.	一瞥; 一看; 短暂的感受(或体验、领会);
> v.	瞥见; 看一眼; 开始领悟; 开始认识到;

When dealing with nonresizable child nodes such as Shape nodes, the parent takes into account the Shape’s rectangular bounds (ParentInBounds), its width and height. In contrast, when using resizable nodes such as a TextField control, the parent has the ability to manage and compute the available space for the TextField to grow horizontally. To grow UI controls horizontally within an HBox, use the static HBox.setHgrow() method. The following code snippet sets a TextField control to grow horizontally when the parent HBox’s width is resized:

~~~java
TextField myTextField = new TextField()
HBox.setHgrow(myTextField, Priority.ALWAYS);
~~~

As an example of an HBox layout in action, the code shown in Listing 4-1 uses four rectangles as child nodes with varying HBox constraints. Nonresizable nodes such as rectangle shapes are used in the example to demonstrate the many spacing attributes for the HBox layout control. For brevity, only the relevant code is listed here. 

~~~java
HBox hbox = new HBox(5); // space between child nodes only
hbox.setPadding(new Insets(1)); // padding between hbox border and row.

Rectangle r1 = new Rectangle(10, 10); // Square
Rectangle r2 = new Rectangle(20, 20); // Big Square
Rectangle r3 = new Rectangle(5, 20); // Vertical rectangle
Rectangle r4 = new Rectangle(20, 5); // Horizontal rectangle

HBox.setMargin(r1, new Insets(2,2,2,2)); // space between border & child node
hbox.getChildren().addAll(r1, r2, r3, r4);
~~~

In Listing 4-1 the code begins by instantiating an HBox using the single-argument constructor. This constructor takes a value of type double, which specifies the horizontal space (in pixels) between child nodes. This is also the equivalent of invoking the setSpacing() method. Because spacing, padding, margin, and border can often be confusing I’ve illustrated an HBox in Figure 4-2. The figure displays three gray rectangular areas, each five pixels wide, that represent the spacing between child nodes (r1 to r4). Setting the spacing uses an Insets object that allows you to create space between the HBox’s child nodes. Notice that the inner part of the HBox border has yellow padding one pixel wide surrounding the row.

After creating all four rectangles, the code sets the margin on rectangle r1. To set the margin you’ll notice the static method HBox.setMargin(Node, Insets). The code creates an Insets object with a margin of two pixels for the top, right, bottom, and left. As shown in Figure 4-2, this is the surrounding space around rectangle r1 (blue). To calculate the size of the HBox’s dimensions, you basically add up the spacing, margin, padding, and the child nodes’ bounds (ParentInBounds). When the parent of the HBox is a Group node (not resizable), the HBox width will total 76 pixels and the height 22 pixels.

### VBox

The VBox layout is similar to an HBox, except that it places child nodes stacked in a vertical column. As children are added, each is placed beneath the previous child node. By default the VBox honors the children’s preferred width and height. When the parent node is not resizable (for example, a Group node), the maximum vertical column’s width is based on the node with the greatest preferred width. Also, by default each child node aligns to the top-left (Pos.TOP_LEFT) position. VBox layouts can also be configured to have resizing ranges to allow the parent node to manage and calculate space available upon layout requests. To demonstrate the use of a VBox, the example in Listing 4-2 contains the same four rectangles from the previous example, with the same layout constraints.

~~~java
VBox vbox = new VBox(5); // spacing between child nodes
vbox.setPadding(new Insets(1)); // padding between border and child nodes

Rectangle r1 = new Rectangle(10, 10); // little square
Rectangle r2 = new Rectangle(20, 20); // big square
Rectangle r3 = new Rectangle(5, 20); // vertical rectangle
Rectangle r4 = new Rectangle(20, 5); // horizontal rectangle
VBox.setMargin(r1, new Insets(2,2,2,2)); // margin around r1
vbox.getChildren().addAll(r1, r2, r3, r4);
~~~

In Listing 4-2, the code begins by instantiating a VBox with a five-pixel space between child nodes. Figure 4-4 depicts horizontal gray bars that represent the spacing between child nodes (r1 to r4). After constructing the VBox, you set the padding via setPadding() method. Setting the padding by using an Insets object allows you to create padding between the border and the row. Notice in Figure 4-4 the VBox padding of one pixel surrounding the VBox shown surrounded by a yellow line.

Once the four rectangles are created, the code sets the margin on the rectangle r1. To set the margin we use the static method VBox.setMargin(Node, Insets). The code then creates an Insets object with a margin of two pixels for the top, right, bottom, and left. Surrounding rectangle r1 is a two-pixel margin shown in blue. To find the total size of a VBox instance, you simply add up the spacing, margin, padding, and child nodes’ dimensions (bounds). Having a Group as a parent, the VBox node’s calculated width would total 22 pixels, and the height would total 76 pixels.

### FlowPane

The FlowPane layout node allows child nodes in a row to flow based on the available horizontal spacing and wraps nodes to the next line when horizontal space is less than the total of all the nodes’ widths. Depicted in Figure 4-5 are four child nodes flowing from left to right and then wrapping.

By default a FlowPane layout flows child nodes from left to right (Pos.TOP_LEFT). To change the flow alignment, you can simply invoke the setAlignment() method by passing in an enumerated value of type Pos. Listing 4-3 creates a FlowPane layout to flow child nodes from right to left (Pos.TOP_RIGHT).

~~~java
FlowPane flowPane = new FlowPane();
flowPane.setAlignment(Pos.TOP_RIGHT);
flowPane.getChildren().addAll(...); // child nodes to add.
~~~

### BorderPane

The BorderPane layout node allows child nodes to be placed in a top, bottom, left, right, or center region. Because each region can only have one node, developers typically nest layouts. An example would be to create an HBox with children to then be set as the top region via the setTop() method. Figure 4-6 shows the BorderPane’s regions.

This layout is similar to many websites we see every day, where navigational links are placed in either the top, bottom, left, or right regions of a page, while the main content is in the center area. A BorderPane’s region of top and bottom borders allows a resizable node to take up all of the available width. The left and right border regions take up the available vertical space between the top and bottom borders. All of the bordering regions honor the children’s sizes (preferred width and height) by default. According to the Javadocs, the default alignment of nodes when placed in the top, bottom, left, right, and center regions is as follows:

- Top: Pos.TOP_LEFT
- Bottom: Pos.BOTTOM_LEFT
- Left: Pos.TOP_LEFT
- Right: Pos.TOP_RIGHT
- Center: Pos.CENTER

### GridPane

So far you have learned about simple layouts; now let’s take a look at a more advanced layout: the GridPane, commonly used in business applications. For instance, business applications typically have data entry form screens. Forms usually have read-only labels on the first column and input fields on the second column, resembling a grid pattern.

When using the GridPane you can specify constraints at the row, column, or cell level. For example, if the second column contains input text fields, you may want them to resize as the window is being resized. To lay out components in a grid-like manner, the example in Listing 4-4 uses JavaFX’s GridPane layout. The most interesting part of the example is the use of column constraints on the GridPane. Column constraints apply a minimum and maximum horizontal width for the child nodes to grow or shrink as the window is resized.

~~~java
@Override
public void start(Stage primaryStage) {
    primaryStage.setTitle("GridPaneForm ");
    BorderPane root = new BorderPane();
    Scene scene = new Scene(root, 380, 150, Color.WHITE);
    
    GridPane gridpane = new GridPane();
    gridpane.setPadding(new Insets(5));
    gridpane.setHgap(5);
    gridpane.setVgap(5);
    ColumnConstraints column1 = new ColumnConstraints(100);
    ColumnConstraints column2 = new ColumnConstraints(50, 150, 300);
    column2.setHgrow(Priority.ALWAYS);
    gridpane.getColumnConstraints().addAll(column1, column2);
    
    Label fNameLbl = new Label("First Name");
    TextField fNameFld = new TextField();
    Label lNameLbl = new Label("Last Name");
    TextField lNameFld = new TextField();

    Button saveButton = new Button("Save");

    // First name label
    GridPane.setHalignment(fNameLbl, HPos.RIGHT);
    gridpane.add(fNameLbl, 0, 0);

    // Last name label
    GridPane.setHalignment(lNameLbl, HPos.RIGHT);
    gridpane.add(lNameLbl, 0, 1);

    // First name field
    GridPane.setHalignment(fNameFld, HPos.LEFT);
    gridpane.add(fNameFld, 1, 0);

    // Last name field
    GridPane.setHalignment(lNameFld, HPos.LEFT);
    gridpane.add(lNameFld, 1, 1);
    // Save button
    GridPane.setHalignment(saveButton, HPos.RIGHT);
    gridpane.add(saveButton, 1, 2);

    FlowPane topBanner = new FlowPane();
    topBanner.setPrefHeight(40);
    String backgroundStyle =
        "-fx-background-color: lightblue;"
        + "-fx-background-radius: 30%;"
        + "-fx-background-inset: 5px;";
    topBanner.setStyle(backgroundStyle);
    SVGPath svgIcon = new SVGPath();
    // icon from http://raphaeljs.com/icons/#people
    svgIcon.setContent(/* svg path code as a string */);
    svgIcon.setStroke(Color.LIGHTGRAY);
    svgIcon.setFill(Color.WHITE);

    Text contactText = new Text("Contacts");
    contactText.setFill(Color.WHITE);

    Font serif = Font.font("Dialog", 30);
    contactText.setFont(serif);
    topBanner.getChildren().addAll(svgIcon, contactText);

    root.setTop(topBanner);
    root.setCenter(gridpane);

    primaryStage.setScene(scene);
    primaryStage.show();
}
~~~

After executing Listing 4-4 you will see the output in Figure 4-7, which displays a simple form application allowing the user to enter a first and last name as contact information. When resizing the window, notice that the input text field controls grow or shrink based on the column constraints. Also notice that the Save button is horizontally aligned to the right (HPos.RIGHT), just beneath the Last Name text field.

Listing 4-4 begins by creating an instance of a BorderPane object as the root node for our scene. By using a BorderPane as the root node and then placing the GridPane node object into the center region, we enable the parent (BorderPane) to resize the GridPane by giving it all the available horizontal and vertical space. After creating a BorderPane instance as our root node, the code instantiates a GridPane layout with padding along with horizontal and vertical gaps. The code in Listing 4-5 then creates a GridPane layout with padding, horizontal, and vertical gaps set to 5 (pixels).

~~~java
GridPane gridpane = new GridPane();
gridpane.setPadding(new Insets(5));
gridpane.setHgap(5); gridpane.setVgap(5);
~~~

Back in Listing 4-4, the code implements column constraints for the first and second columns. To set a column’s constraint, use the ColumnConstraints constructor, which allows the developer to specify minimum, preferred, and maximum widths for a column on the GridPane node. This is very nice; it means that when the parent container node (BorderPane) is being resized, the GridPane will cause its child nodes to grow or shrink horizontally based on its row or column constraints. Listing 4-6 demonstrates the ability to constrain the first column to 100 pixels wide for the read-only labels and the second column with a minimum width of 50, a preferred width of 150 and a maximum width of 300.

~~~java
ColumnConstraints column1 = new ColumnConstraints(100); // fixed for labels
ColumnConstraints column2 = new ColumnConstraints(50, 150, 300); // min,pref,max
column2.setHgrow(Priority.ALWAYS);
gridpane.getColumnConstraints().addAll(column1, column2);
~~~

After creating the column constraint for column 2, the code invokes the setHgrow() method by passing in the enum value Priority.ALWAYS, which lets the UI controls take up the available horizontal space within cells when the window is widened. I set the maximum width to 300 for the second column so you can see that the child TextField does not grow beyond the maximum width (300). In other words, when the window is resized wider than 300 pixels, the text fields within the grid pane column stop stretching.

The next step is simply putting each UI control into its respective cell location. All cells are relative to zero; to place a node in the cell in the first column and first row you would specify the cell as (0, 0). Thus, the following code snippet adds the Save button into the second column, third row of the GridPane layout at cell (1, 2):

~~~java
gridpane.add(saveButton, 1, 2);
~~~

The layout also allows you to align controls horizontally or vertically within the cell. The following statement right-aligns the Save button:

~~~java
GridPane.setHalignment(saveButton, HPos.RIGHT);
~~~

After completing the GridPane setup, the code implements the top banner area of the input form shown in Figure 4-7. To create a title banner, we use a flow layout with a background color of light blue, an SVG node icon (people) and a text node (contacts). The important code that relates to the FlowPane layout displaying the banner contains the settings for the preferred height and JavaFX CSS styles. Because the banner (FlowPane) is placed in the top region of the BorderPane layout, the preferred height of 40 pixels will be honored and the width will take up the available horizontal space.

With this knowledge that the FlowPane takes up the available horizontal space, notice the area being filled with the light blue background color. By using JavaFX CSS styling, the code sets a background color of light blue along with corner radii and insets specified using a string. Listing 4-7 is the code section that styles the banner (FlowPane) to be placed in the top region of the BorderPane layout. Don’t worry if JavaFX CSS styling doesn’t make sense yet; a more detailed discussion of it will follow in Chapter 6.

> radii	英[ˈreɪdiaɪ] 美[ˈreɪdiaɪ]
> [词典]	radius 的复数;

~~~java
FlowPane topBanner = new FlowPane();
topBanner.setPrefHeight(40);
String backgroundStyle = "-fx-background-color: lightblue;"
 + "-fx-background-radius: 30%;"
 + "-fx-background-inset: 5px;";
topBanner.setStyle(backgroundStyle);
~~~

We’ve only scratched the surface of the GridPane layout. There are other ways to provide constraints and alignment of child nodes, so I trust you will delve deeper into the GridPane layout. Please see the Javadocs documentation for more details. Now that you’ve learned how to use the most common layouts, you will be able to create well-behaved user interfaces. Next, you will explore common JavaFX UI controls.

> delve	英[delv] 美[delv]
> v.	(在手提包、容器等中)翻找;

## UI Controls

UI controls are essentially advanced JavaFX nodes that typically allow user input such as text fields, sliders, list views, and table views. Unlike HTML5, JavaFX allows UI control nodes and shape nodes to coexist on the scene graph. This means you can treat any UI control like any other JavaFX node; for example you can scale, rotate, style, and add effects. 

### Menus

Menus are a standard way for windowed desktop applications to allow users to select options. For example, applications typically have a File menu offering options (menu items) to save or open a file. In a windowed environment the user will use their mouse to navigate and select menu items. Menus and menu items typically also have the functionality of key combinations to select options, also known as keyboard shortcuts. In other words, key combinations allow quick menu selections without the need of a mouse.

### Creating Menus and Menu Items

Before exploring how to invoke code triggered by selecting menu options, let’s look at how to create menus. For starters, you must create a menu bar (javafx.scene.control.MenuBar) object to hold many javafx.scene.control.Menu objects. Each Menu object is similar to a tree hierarchal structure where Menu objects can contain Menu and javafx.scene.control.MenuItem objects. Thus, a menu may contain other menus as submenus or menus within menus. MenuItems are child options within a Menu object. You can think of MenuItems as leaf nodes (containing no children) in a tree structure. Listing 4-8 shows the creation of a menu bar with a File menu that has a Save option as a menu item.

~~~java
MenuBar menuBar = new MenuBar();
Menu fileMenu = new Menu("File");
fileMenu.getItems().add(new MenuItem("Save"));
menuBar.getMenus().add(fileMenu);
~~~

Although you can create simple menu items, you may want more advanced options such as checked options or radio buttons. Based on the inheritance hierarchy, the following are subclasses of the MenuItem class. The following listing shows the available MenuItem subclasses to use as menu options. A brief description of each subclass will follow.

- javafx.scene.control.CheckMenuItem
- javafx.scene.control.RadioMenuItem
- javafx.scene.control.CustomMenuItem
- javafx.scene.control.SeparatorMenuItem
- javafx.scene.control.Menu

A CheckMenuItem menu item is similar to a check box UI control, allowing the user to select items optionally. 

The RadioMenuItem menu item is similar to the radio button UI control, allowing the user to select only one item from an item group. 

When you want to create a custom menu item you can use the CustomMenuItem class. For instance, you may want to have a menu option that behaves like a toggle button. 

Next is a SeparatorMenuItem, which is really a derived class of type CustomMenuItem. A SeparatorMenuItem is a menu item that displays as a visual line to separate menu items. 

Last in the list is the Menu class. Because a Menu class is a subclass of MenuItem, it has a getItems().add() method that’s capable of adding children such as other Menu and MenuItem instances.

### Invoking a Selected MenuItem

Now, that you know how to construct a menus and menu items, let’s see how to invoke code that is attached to a menu item. You’ll be happy to know that you wire-up handler code to a menu item in exactly the same way that you would wire-up JavaFX buttons, which means that menu items also have a setOnAction() method. The setOnAction() method receives a functional interface of type `EventHandler<ActionEvent>`, which is the handler code that is invoked when the menu item is selected. Listing 4-9 shows two equivalent implementations of action code to be invoked when the Exit menu item is triggered. The first implementation uses an anonymous inner class, and the second uses Java 8’s lambda expressions.

~~~java
// Implementation that uses an anonymous inner class
exitMenuItem.setOnAction(new EventHandler<ActionEvent>() {
    @Override
    public void handle(ActionEvent t) {
        Platform.exit();
    }
});
// Implementation that uses lambda expressions
exitMenuItem.setOnAction(ae -> Platform.exit());
~~~

### Example: Working with Menus

To demonstrate various menu selection scenarios, the next example mimics a security alarm application. Listing 4-10 is from the file MenuExample.java and shows the relevant code that demonstrates menu selections. Before executing the code you may want to know how to use this fictitious security alarm application. As illustrated in Figure 4-9, the menu bar displays three main menus: File, Cameras, and Alarm. When the File menu is selected, it displays three options—New, Save, and Exit—as child menu items. Selecting the Cameras menu displays two CheckMenuItem menu items, for the optional selection of Show Camera 1 or Show Camera 2. Lastly, the Alarm menu displays two RadioMenuItem options and a submenu Contingent Plans. The submenu displays three child CheckMenuItem options.

> fictitious	英[fɪkˈtɪʃəs] 美[fɪkˈtɪʃəs]
> adj.	虚构的; 虚假的;
>
> contingent 英[kənˈtɪndʒənt] 美[kənˈtɪndʒənt]
> n.	(志趣相投、尤指来自同一地方的)一组与会者，代表团; (军队的)分遣队，小分队;
> adj.	依情况而定的;
>
> contingent plan 英[kənˈtɪndʒənt plæn] 美[kənˈtɪndʒənt plæn]
> 网络	应变计划;

~~~java
@Override
public void start(Stage primaryStage) {
    primaryStage.setTitle("Menus Example");
    BorderPane root = new BorderPane();
    Scene scene = new Scene(root, 300, 250, Color.WHITE);

    MenuBar menuBar = new MenuBar();
    root.setTop(menuBar);

    // File menu - new, save, exit
    Menu fileMenu = new Menu("File");
    MenuItem newMenuItem = new MenuItem("New");
    MenuItem saveMenuItem = new MenuItem("Save");
    MenuItem exitMenuItem = new MenuItem("Exit");
    exitMenuItem.setOnAction(actionEvent -> Platform.exit() );

    fileMenu.getItems().addAll(newMenuItem,
                               saveMenuItem,
                               new SeparatorMenuItem(),
                               exitMenuItem
                              );
    menuBar.getMenus().add(fileMenu);

    // Cameras menu - camera 1, camera 2
    Menu cameraMenu = new Menu("Cameras");
    CheckMenuItem cam1MenuItem = new CheckMenuItem("Show Camera 1");
    cam1MenuItem.setSelected(true);
    cameraMenu.getItems().add(cam1MenuItem);

    CheckMenuItem cam2MenuItem = new CheckMenuItem("Show Camera 2");
    cam2MenuItem.setSelected(true);
    cameraMenu.getItems().add(cam2MenuItem);

    // Alarm menu
    Menu alarmMenu = new Menu("Alarm");

    // sound or turn alarm off
    ToggleGroup tGroup = new ToggleGroup();
    RadioMenuItem soundAlarmItem = new RadioMenuItem("Sound Alarm");
    soundAlarmItem.setToggleGroup(tGroup);

    RadioMenuItem stopAlarmItem = new RadioMenuItem("Alarm Off");
    stopAlarmItem.setToggleGroup(tGroup);
    stopAlarmItem.setSelected(true);

    alarmMenu.getItems().addAll(soundAlarmItem,
                                stopAlarmItem,
                                new SeparatorMenuItem());

    Menu contingencyPlans = new Menu("Contingent Plans");
    contingencyPlans.getItems().addAll(
        new CheckMenuItem("Self Destruct in T minus 50"),
        new CheckMenuItem("Turn off the coffee machine "),
        new CheckMenuItem("Run for your lives! "));

    alarmMenu.getItems().add(contingencyPlans);

    menuBar.getMenus().addAll(fileMenu, cameraMenu, alarmMenu);

    primaryStage.setScene(scene);
    primaryStage.show();
}
~~~

The code begins by creating a MenuBar control, which may contain one to many menu (MenuItem) objects. After the MenuBar is created, it is set as the top region on the BorderPane layout. Since the top region allows a resizable node to take up the available horizontal space, the MenuBar control will stretch to the width of the BorderPane (the root scene). Listing 4-11 sets the top region of the BorderPane to a menu bar.

~~~java
MenuBar menuBar = new MenuBar();
root.setTop(menuBar);
~~~

Next, the code instantiates Menu objects that contain one or more menu item (MenuItem) objects and other Menu objects, making submenus.

After creating the File, menu the code creates the Cameras menu. This menu will contain CheckMenuItem objects. These menu items allow the user to optionally select or unselect Show Camera 1 and Show Camera 2 as menu items.

Last is the implementation of our Alarm menu, which contains two radio menu items (RadioMenuItem), a separator (SeparatorMenuItem), and a submenu (Menu). To create the radio menu items for the Alarm menu, the code creates an instance of a ToggleGroup class. The ToggleGroup class is also used on regular radio buttons (RadioButtons) to allow one selected option only. Listing 4-12 creates radio menu items (RadioMenuItems) to be added to the alarmMenu Menu object.

~~~java
// Alarm menu
Menu alarmMenu = new Menu("Alarm");

// sound or turn alarm off
ToggleGroup tGroup = new ToggleGroup();
RadioMenuItem soundAlarmItem = new RadioMenuItem("Sound Alarm");
soundAlarmItem.setToggleGroup(tGroup);

RadioMenuItem stopAlarmItem = new RadioMenuItem("Alarm Off");
stopAlarmItem.setToggleGroup(tGroup);
stopAlarmItem.setSelected(true);

alarmMenu.getItems().addAll(soundAlarmItem,
 stopAlarmItem,
 new SeparatorMenuItem());
~~~

The code also adds a visual separator, by instantiating a SeparatorMenuItem class that is added to a menu via the getItems().addAll() method. The method getItems() returns an observable list of MenuItem objects (ObservableList<*MenuItem*>). You’ll learn about ObservableList collections later, but briefly, they are collections that have the ability to notify and update UI controls as items are added or removed. For a full description please see the section “The ObservableList Collection Class” later in this chapter.

The last child menu item added to the Alarm menu is a submenu, Contingent Plans. To add some levity I’ve created some humorous menu options for contingency plans when an emergency occurs.

### Additional Ways to Select Menus and Menu Items

 In this section you will learn three additional ways to invoke menu items: by constructing key mnemonics, key combinations, and context menus.

> mnemonics	英[ni(ː)ˈmɒnɪks] 美[nɪˈmɑnɪks]
> n.	帮助记忆的词句(或诗歌等); 助记符号;

#### Key Mnemonics

Standard menus generally have keyboard mnemonics to select menu items without using a mouse. Typically, applications that use a menu allow the user to hit the Alt key, which puts an underscore (_) beneath a letter of the menu text label. After the user hits the letter, the menu will drop down to display its child menu items and the user will be allowed to navigate with arrow keys.

To perform this behavior in code, you instantiate a Menu by invoking the constructor that receives a String value as before, but this time you place an underscore character preceding the chosen letter in the menu or menu item’s text. Also, to let the system recognize the mnemonic you will simply pass true to the setMnemonicParsing(true) method. Listing 4-13 creates a File menu that uses the letter “F” as the mnemonic.

~~~java
Menu fileMenu = new Menu("_File");
fileMenu.setMnemonicParsing(true);
~~~

#### Key Combinations

A key combination is a combination of keystrokes to select a menu option. For instance, most applications on the Windows platform have the key combination of Ctrl + S to save a file. On the Mac OS platform, the key combination would be Command + S. Keys such as Ctrl, Command, Alt, Shift, and Meta are called modifier keys. Usually the modifiers are pressed in combination with a single letter. Sometimes key combinations are referred as keyboard shortcuts. To create a key combination, you need an instance of the KeyCodeCombination object that will contain the keystroke and the modifiers. Listing 4-14 provides a key code combination of (Ctrl or Meta) + S. You will notice that the code uses the KeyCombination.SHORTCUT_DOWN value as the key modifier instead of CONTROL_DOWN or META_DOWN. The reason is simple; the value of SHORTCUT_DOWN will enable the application to be cross-platform. The values CONTROL_DOWN and META_DOWN are system dependent on the Windows and MacOS platforms respectively, but SHORTCUT_DOWN works on all platforms.

~~~java
MenuItem saveItem = new MenuItem("_Save");
saveItem.setMnemonicParsing(true);
saveItem.setAccelerator(new KeyCodeCombination(KeyCode.S, KeyCombination.SHORTCUT_DOWN));
~~~

#### Context Menus

Context menus are popup menus displayed when a user right-clicks the mouse button on a JavaFX UI control or a stage surface. To create a context menu, you instantiate a ContextMenu class. Exactly like a regular menu, the ContextMenu menu has a getItems().add() method to add menu items. The following code snippet shows a context menu instantiated with a menu item (exitItem):

~~~java
ContextMenu contextFileMenu = new ContextMenu(exitItem);
~~~

To respond to a right-click of the mouse on the scene in an application, you can basically add an event handler to listen for a right-click event. Once that is detected, the context menu’s show() method is invoked. The code in Listing 4-15 sets up an event handler to show and hide a context menu based on a right or left mouse click, respectively. Notice the hide() method invoked by the primary mouse click (left-click) to remove the context menu.

~~~java
primaryStage.addEventHandler(MouseEvent.MOUSE_CLICKED, (MouseEvent me) -> {
    if (me.getButton() == MouseButton.SECONDARY || me.isControlDown()) {
        contextFileMenu.show(root, me.getScreenX(), me.getScreenY());
    } else {
        contextFileMenu.hide();
    }
});
~~~

## The ObservableList Collection Class

When using the Java Collections API you’ll notice the many useful container classes that represent data structures such as sets, maps, and lists. One of the commonly used concrete list classes is java.util.ArrayList, which implements the List interface. For a long time Java Swing developers built applications using an ArrayList to represent a list of objects that will be displayed in a list-like UI control. The issues that caused a lot of grief were the ability to synchronize list models and view components. To solve this problem, you can use JavaFX’s ObservableList class. The ObservableList is a collection that is capable of notifying UI controls when objects are added, updated, and removed. JavaFX ObservableLists are typically used in list UI controls such as ListView and TableView. Let’s look at two examples that will use the ObservableList collection class.

### Working with ListViews

The Hero Picker example application was created to demonstrate the ObservableList’s capabilities; it displays two JavaFX ListView UI controls and allows the user to transfer items between the two ListView controls. One list contains candidates for hero status and the other contains those who have already achieved it. As shown in Listing 4-16, this application allows you to choose a candidate to be transferred to the other ListView control, which contains the chosen heroes.

~~~java
@Override
public void start(Stage primaryStage) {
    primaryStage.setTitle("Hero Picker: Chapter 4 Creating and Working with ObservableLists");
    BorderPane root = new BorderPane();
    Scene scene = new Scene(root, 400, 250, Color.WHITE);
    
    // create a grid pane
    GridPane gridpane = new GridPane();
    gridpane.setPadding(new Insets(5));
    gridpane.setHgap(10);
    gridpane.setVgap(10);
    ColumnConstraints column1 = new ColumnConstraints(150, 150, Double.MAX_VALUE);
    ColumnConstraints column2 = new ColumnConstraints(50);
    ColumnConstraints column3 = new ColumnConstraints(150, 150, Double.MAX_VALUE);
    column1.setHgrow(Priority.ALWAYS);
    column3.setHgrow(Priority.ALWAYS);
    gridpane.getColumnConstraints().addAll(column1, column2, column3);

    // Candidates label
    Label candidatesLbl = new Label("Candidates");
    GridPane.setHalignment(candidatesLbl, HPos.CENTER);
    gridpane.add(candidatesLbl, 0, 0);
    
    // Heroes label
    Label heroesLbl = new Label("Heroes");
    gridpane.add(heroesLbl, 2, 0);
    GridPane.setHalignment(heroesLbl, HPos.CENTER);
    
    // Candidates
    final ObservableList<String> candidates = FXCollections.observableArrayList("Superman",
                                                                                "Spiderman",
                                                                                "Wolverine",
                                                                                "Police",
                                                                                "Fire Rescue",
                                                                                "Soldiers",
                                                                                "Dad & Mom",
                                                                                "Doctor",
                                                                                "Politician",
                                                                                "Pastor",
                                                                                "Teacher");
    final ListView<String> candidatesListView = new ListView<>(candidates);
    gridpane.add(candidatesListView, 0, 1);
    
    // heroes
    final ObservableList<String> heroes = FXCollections.observableArrayList();
    final ListView<String> heroListView = new ListView<>(heroes);
    
    gridpane.add(heroListView, 2, 1);
    
    // select heroes
    Button sendRightButton = new Button(" > ");
    sendRightButton.setOnAction((ActionEvent event) -> {
        String potential = candidatesListView.getSelectionModel().getSelectedItem();
        if (potential != null) {
            candidatesListView.getSelectionModel().clearSelection();
            candidates.remove(potential);
            heroes.add(potential);
        }
    });
    
    // deselect heroes
    Button sendLeftButton = new Button(" < ");
    sendLeftButton.setOnAction((ActionEvent event) -> {
        String notHero = heroListView.getSelectionModel().getSelectedItem();
        if (notHero != null) {
            heroListView.getSelectionModel().clearSelection();
            heroes.remove(notHero);
            candidates.add(notHero);
        }
    });
    
    VBox vbox = new VBox(5);
    vbox.getChildren().addAll(sendRightButton,sendLeftButton);
    
    gridpane.add(vbox, 1, 1);
    root.setCenter(gridpane);
    
    GridPane.setVgrow(root, Priority.ALWAYS);
    primaryStage.setScene(scene);
    primaryStage.show();
}
~~~

Created in this example is a GUI application that allows a user to choose their favorite heroes. This is quite similar to application screens that manage user roles by adding or removing items from list box components. In JavaFX the code example uses two ListView controls to hold String objects. For the sake of brevity we will not discuss the use of the layouts, but jump right into the code relating to the button actions and ListView controls.

Before creating an instance of a ListView, the code creates an ObservableList containing our candidates. Here you’ll notice the use of a factory class called FXCollections, into which you can pass common collection types to be wrapped and returned to the caller as an ObservableList. In the example an array of Strings is passed into the FXCollections.observableArrayList() method instead of an ArrayList. Using the ObservableList allows us to update the list of items in the array and in the display on the screen concurrently with a single method call.

Hopefully you get the idea about how to use the FXCollections class. I trust you will use it wisely; as Peter Parker’s Uncle Ben says,“With great power, there must also come great responsibility.” The following code line calls the FXCollections.observableArrayList() method class to return an observable list (ObservableList):

~~~java
ObservableList<String> candidates = FXCollections.observableArrayList(...);
~~~

After the code creates an ObservableList, a ListView class is instantiated using a constructor that receives the observable list. The following code creates and populates a ListView object:

~~~java
ListView<String> candidatesListView = new ListView<String>(candidates);
~~~

The last item of business is where the code manipulates ObservableLists as if they were java.util.ArrayLists. As they are manipulated, the ListView is notified and automatically updated to reflect the changes to the ObservableList. Listing 4-17 implements the action event code when the user presses the Send (>) button.

~~~java
// select heroes
Button sendRightButton = new Button(">");
sendRightButton.setOnAction( actionEvent -> {
    String potential = candidatesListView.getSelectionModel().getSelectedItem();
    if (potential != null) {
        candidatesListView.getSelectionModel().clearSelection();
        candidates.remove(potential);
        heroes.add(potential);
    }
});
~~~

To set action code for the button, the code uses a lambda expression with an actionEvent (ActionEvent) as a parameter, which is invoked when the button is clicked. When a button-press event arrives, the code determines which item in the ListView was selected via the getSelectionModel().getSelectedItem() on the ListView. Once the item is determined, the code clears the selection (clearSelection()), removes the item, and adds the item to the Heroes ObserverableList. What’s great is that there is no need to refresh the ListView UI control when the collection changes.

## Working with TableViews

We can also use ObservableLists in another list-like UI control, the TableView. JavaFX’s `javafx.scene.control.TableView` control is analogous to Swing’s JTable component, which contains rows, columns, and cells very similar to spreadsheet applications.

As an example of the TableView control I’ve created an application called Bosses and Employees that demonstrates how to populate a TableView to contain a collection of employees (the Person JavaFX bean) based on the selection of a boss from a ListView control.

Before delving into the GUI code, we will examine the use of a domain object to represent a person (Person). Listing 4-18 shows a JavaFX bean of a Person class that represents a boss or an employee that will be displayed in a ListView and/or TableView control. The GUI code to handle list view selection and populating the table view appears in Listing 4-19.

~~~java
public class Person {
    private StringProperty aliasName;
    private StringProperty firstName;
    private StringProperty lastName;
    private ObservableList<Person> employees = FXCollections.observableArrayList();

    public final void setAliasName(String value) {
        aliasNameProperty().set(value);
    }
    public final String getAliasName() {
        return aliasNameProperty().get();
    }
    public StringProperty aliasNameProperty() {
        if (aliasName == null) {
            aliasName = new SimpleStringProperty();
        }
        return aliasName;
    }
    public final void setFirstName(String value) {
        firstNameProperty().set(value);
    }
    public final String getFirstName() {
        return firstNameProperty().get();
    }
    public StringProperty firstNameProperty() {
        if (firstName == null) {
            firstName = new SimpleStringProperty();
        }
        return firstName;
    }
    public final void setLastName(String value) {
        lastNameProperty().set(value);
    }
    public final String getLastName() {
        return lastNameProperty().get();
    }
    public StringProperty lastNameProperty() {
        if (lastName == null) {
            lastName = new SimpleStringProperty();
        }
        return lastName;
    }
    public ObservableList<Person> employeesProperty() {
        return employees;
    }
    public Person(String alias, String firstName, String lastName) {
        setAliasName(alias);
        setFirstName(firstName);
        setLastName(lastName);
    }
}
~~~

~~~java
@Override
public void start(Stage primaryStage) {
    primaryStage.setTitle("Bosses and Employees: Chapter 4 Working with Tables");
    BorderPane root = new BorderPane();
    Scene scene = new Scene(root, 500, 250, Color.WHITE);

    // create a grid pane
    GridPane gridpane = new GridPane();
    gridpane.setPadding(new Insets(5));
    gridpane.setHgap(10);
    gridpane.setVgap(10);
    root.setCenter(gridpane);

    // candidates label
    Label candidatesLbl = new Label("Boss");
    GridPane.setHalignment(candidatesLbl, HPos.CENTER);
    gridpane.add(candidatesLbl, 0, 0);

    // List of leaders
    ObservableList<Person> leaders = getPeople();
    final ListView<Person> leaderListView = new ListView<>(leaders);
    leaderListView.setPrefWidth(150);
    leaderListView.setMaxWidth(Double.MAX_VALUE);
    leaderListView.setPrefHeight(150);

    // display first and last name with tooltip using alias
    leaderListView.setCellFactory(new Callback<ListView<Person>, ListCell<Person>>() {
        @Override
        public ListCell<Person> call(ListView<Person> param) {
            Label leadLbl = new Label();
            Tooltip tooltip = new Tooltip();
            ListCell<Person> cell = new ListCell<Person>() {
                @Override
                public void updateItem(Person item, boolean empty) {
                    super.updateItem(item, empty);
                    if (item != null) {
                        leadLbl.setText(item.getAliasName());
                        setText(item.getFirstName() + " " + item.getLastName());
                        tooltip.setText(item.getAliasName());
                        setTooltip(tooltip);
                    }
                }
            }; // ListCell
            return cell;
        }
    }); // setCellFactory

    gridpane.add(leaderListView, 0, 1);
    Label emplLbl = new Label("Employees");
    gridpane.add(emplLbl, 2, 0);
    GridPane.setHalignment(emplLbl, HPos.CENTER);

    final TableView<Person> employeeTableView = new TableView<>();
    employeeTableView.setPrefWidth(300);

    final ObservableList<Person> teamMembers = FXCollections.observableArrayList();
    employeeTableView.setItems(teamMembers);

    TableColumn<Person, String> aliasNameCol = new TableColumn<>("Alias");
    aliasNameCol.setEditable(true);
    aliasNameCol.setCellValueFactory(new PropertyValueFactory("aliasName"));

    aliasNameCol.setPrefWidth(employeeTableView.getPrefWidth() / 3);

    TableColumn<Person, String> firstNameCol = new TableColumn<>("First Name");
    firstNameCol.setCellValueFactory(new PropertyValueFactory("firstName"));
    firstNameCol.setPrefWidth(employeeTableView.getPrefWidth() / 3);

    TableColumn<Person, String> lastNameCol = new TableColumn<>("Last Name");
    lastNameCol.setCellValueFactory(new PropertyValueFactory("lastName"));
    lastNameCol.setPrefWidth(employeeTableView.getPrefWidth() / 3);

    employeeTableView.getColumns().setAll(aliasNameCol, firstNameCol, lastNameCol);
    gridpane.add(employeeTableView, 2, 1);

    // selection listening
    leaderListView.getSelectionModel().selectedItemProperty().addListener((ObservableValue<? extends 
                                                                           Person> observable, Person oldValue, Person newValue) -> {
        if (observable != null && observable.getValue() != null) {
            teamMembers.clear();
            teamMembers.addAll(observable.getValue().employeesProperty());
        }
    });
    
    primaryStage.setScene(scene);
    primaryStage.show();
}
~~~

Listing 4-20 shows the getPeople() method contained in the BossesAndEmployees main application class to help populate the TableView control.

~~~java
private ObservableList<Person> getPeople() {
    ObservableList<Person> people = FXCollections.<Person>observableArrayList();
    Person docX = new Person("Professor X", "Charles", "Xavier");
    docX.employeesProperty().add(new Person("Wolverine", "James", "Howlett"));
    docX.employeesProperty().add(new Person("Cyclops", "Scott", "Summers"));
    docX.employeesProperty().add(new Person("Storm", "Ororo", "Munroe"));
    Person magneto = new Person("Magneto", "Max", "Eisenhardt");
    // ...code to add employees
    Person biker = new Person("Mountain Biker", "Jonathan", "Gennick");
    // ...code to add employees

    people.addAll(docX, magneto, biker);
    return people;
}
~~~

For the fun of it, I’ve created a simple GUI application that displays bosses and their employees. Notice on the left side of Figure 4-11 a list of important people (bosses). When you click to select a boss, their employees will be shown in the TableView control to the right. You’ll also notice the tooltip popup when the mouse cursor is hovered over the selected boss.

Before we discuss the TableView control, let’s detail the ListView control’s responsibility of updating the TableView. In model view fashion, the code in Listing 4-20 first creates an ObservableList containing all the bosses via the private getPeople() method to be passed to the ListView control’s constructor. Listing 4-21 populates the ListView control with the list of bosses

~~~java
// List of leaders
ObservableList<Person> leaders = getPeople();
ListView<Person> leaderListView = new ListView<>(leaders);
~~~

Next, the code instantiates a cell factory via the setCellFactory() method in Listing 4-19 to properly display the person’s name in the ListView control. Because each item isn’t a string but a Person object, the ListView does not know how to render each row (cell) in the ListView control. To inform the ListView which properties to use from the Person object, the code simply creates a javafx.util.Callback generic object by specifying the `ListView<Person>` and a `ListCell<Person>` data type. With your trusty NetBeans IDE, it can pregenerate or stub code for an empty implementation of the method call().

You just need to type:

~~~java
leaderListView.setCellFactory(new );
~~~

As the cursor is positioned after the *new* keyword hit Ctrl + Space and when you see the Callback interface at the top of the popup hit Enter or select it using your mouse pointer. The following code block will be generated.

~~~java
leaderListView.setCellFactory(new Callback<ListView<Person>, ListCell<Person>>() {
    @Override
    public ListCell<Person> call(ListView<Person> p) {
        throw new UnsupportedOperationException("Not supported yet.");
    }
});
~~~

After generating the code above using the NetBeans code completion feature the throws UnsupportedOperationException statement will need to be replaced with a code implementation to respond when a row item (ListCell) is selected. Next, are the details on the implementation of the call() method.

Within the call() method shown in Listing 4-22 is the variable *cell* of type `ListCell<Person>`, in which the code creates an anonymous inner class. The inner class must implement the updateItem() method. The job of the updateItem() method is to obtain each person’s information, which then updates a Label control (leadLbl). The label is what is displayed for each cell row in the ListView control. The last thing the updateItem() method does is to add a tooltip popup (Tooltip) to each cell row. The tooltip will pop up when the cursor hovers over the cell (boss) within the ListView. After updating the cell the cell variable is returned.

~~~java
@Override
public ListCell<Person> call(ListView<Person> param) {
    Label leadLbl = new Label();
    Tooltip tooltip = new Tooltip();
    ListCell<Person> cell = new ListCell<Person>() {
        @Override
        public void updateItem(Person item, boolean empty) {
            super.updateItem(item, empty);
            if (item != null) {
                leadLbl.setText(item.getAliasName());
                setText(item.getFirstName() + " " + item.getLastName());
                tooltip.setText(item.getAliasName());
                setTooltip(tooltip);
            }
        }
    }; // ListCell
    return cell;
}
~~~

Finally, the code creates a TableView control to display the employees based on the selected boss from the ListView control. When creating a TableView control the code first creates the column headers as shown in Listing 4-23.

~~~java
TableColumn<String> firstNameCol = new TableColumn<String>("First Name");
firstNameCol.setCellValueFactory(new PropertyValueFactory("firstName"));
~~~

Once you have created a column, you’ll notice the setCellValueFactory() method, which is responsible for calling the Person bean’s property. So when the list of employees is put into the TableView, it will know how to pull the properties to be placed in each cell column in the table. Based on the JavaBean convention a new PropertyValueFactory instance is created with the name of the bean attribute (firstName).

Last is the implementation of the selection listener on the ListView. In the code you’ll notice the getSelectionModel().selectedItemProperty() method (shown at the end of Listing 4-19) that allows a listener to be added. The code simply creates and adds a ChangeListener for selection events. When a user selects a boss, the TableView is cleared and populated with the employees of the selected boss. Actually, it is the magic of the ObservableList that notifies the TableView of changes. Listing 4-24 clears and populates the TableView via the teamMembers (ObservableList) variable.

~~~java
teamMembers.clear();
teamMembers.addAll(observable.getValue().employeesProperty());
~~~

## Generating a Background Process

Typically in desktop applications that have long running processes, visual feedback should indicate that something is happening or suggest that the user be patient. One of the main pitfalls of GUI development is the difficulty of knowing when and how to delegate work to worker threads. Trying to avoid these pitfalls, GUI developers are constantly reminded of thread safety, especially when it comes to blocking the UI thread during heavy load. JavaFX provides UI controls that help solve this issue by off-loading work to a different thread (Task) while providing feedback or progress indicators of the work that is being done.

To demonstrate a GUI application generating a background process while also providing feedback to the user, I’ve created an example application that simulates a dialog window visualizing the progress of many files being copied. Listing 4-25 is a code example of using JavaFX’s progress bar and indicator UI controls to provide feedback to the user as files are being copied.

The following are the main classes used in this example:

- javafx.scene.control.ProgressBar
- javafx.scene.control.ProgressIndicator
- javafx.concurrent.Task

~~~java
@Override
public void start(Stage primaryStage) {
    primaryStage.setTitle("BackgroundProcesses: Chapter 4 Background Processes");
    
    // ... Layout and UI controls code here
    final Label label = new Label("Files Transfer:");
    final ProgressBar progressBar = new ProgressBar(0);
    final ProgressIndicator progressIndicator = new ProgressIndicator(0);
    
    // ... Layout and UI controls code here
    final Button startButton = new Button("Start");
    final Button cancelButton = new Button("Cancel");
    final TextArea textArea = new TextArea();
    // ... Layout and UI controls code here

    // wire up Start button
    startButton.setOnAction((ActionEvent event) -> {
        startButton.setDisable(true);
        progressBar.setProgress(0);
        progressIndicator.setProgress(0);
        textArea.setText("");
        cancelButton.setDisable(false);
        copyWorker = createWorker(numFiles);
        
        // wire up progress bar
        progressBar.progressProperty().unbind();
        progressBar.progressProperty()
            .bind(copyWorker.progressProperty());
        progressIndicator.progressProperty().unbind();
        progressIndicator.progressProperty()
            .bind(copyWorker.progressProperty());
        
        // append to text area box
        copyWorker.messageProperty().addListener(
            (ObservableValue<? extends String> observable,
             String oldValue, String newValue) -> {
                textArea.appendText(newValue + "\n");
            });
        
        new Thread(copyWorker).start();
    });
    
    // Cancel button will kill worker and reset.
    cancelButton.setOnAction((ActionEvent event) -> {
        startButton.setDisable(false);
        cancelButton.setDisable(true);
        copyWorker.cancel(true);
        
        // reset
        progressBar.progressProperty().unbind();
        progressBar.setProgress(0);
        progressIndicator.progressProperty().unbind();
        progressIndicator.setProgress(0);
        textArea.appendText("File transfer was cancelled.");
    });
    primaryStage.setScene(scene);
    primaryStage.show();
}

private Task createWorker(final int numFiles) {
    return new Task() {
        @Override
        protected Object call() throws Exception {
            for (int i = 0; i < numFiles; i++) {
                long elapsedTime = System.currentTimeMillis();
                copyFile("some file", "some dest file");
                elapsedTime = System.currentTimeMillis() - elapsedTime;
                String status = elapsedTime + " milliseconds";
                
                // queue up status
                updateMessage(status);
                updateProgress(i + 1, numFiles);
            }
            return true;
        }
    };
}

private void copyFile(String src, String dest) throws InterruptedException {
    // simulate a long time
    Random rnd = new Random(System.currentTimeMillis());
    long millis = rnd.nextInt(1000);
    Thread.sleep(millis);
}
~~~

The code begins by creating not one but two progress controls to show the user the work being done. The first control is a progress bar, and the second is a progress indicator. Figure 4-12 depicts from left to right a progress bar and a progress indicator (pie chart). The progress indicator shows a percentage below the indicator icon.

Listing 4-26 is the creation of a progress bar and a progress indicator using the constructor that initializes the progress value to zero.

~~~java
ProgressBar progressBar = new ProgressBar(0);
ProgressIndicator progressIndicator = new ProgressIndicator(0);
~~~

Next, the code creates a worker thread via the private createWorker() method. The createWorker() convenience method instantiates and returns a javafx.concurrent.Task object, which is similar to the Java Swing’s SwingWorker class. Unlike the SwingWorker class, the Task object is greatly simplified and easier to use, thanks to its event-driven design. An example is a Task object’s ability to update progress asynchronously.

When creating an instance of a Task object, the code implements the call() method to do work in the background. As the work is being done, you will often want to queue up intermediate results such as progress or text information to provide feedback to the user. To queue information, the API allows you to call the updateProgress() or updateMessage() method. These methods update information in a thread-safe way so that the observer of the progress properties can update the GUI safely without blocking the GUI thread. Listing 4-27 is code that queues up messages and progress.

~~~java
// queue up status
updateMessage(status);
updateProgress(i + 1, numFiles); // (progress, max progress)
~~~

After creating a worker Task, the code unbinds any old tasks bound to the progress controls. Once the progress controls are unbound, the code then binds the progress controls to a newly created Task object named copyWorker. Listing 4-28 rebinds a new Task object to the progress UI controls.

~~~java
// wire up progress bar
progressBar.progressProperty().unbind();
progressBar.progressProperty().bind(copyWorker.progressProperty());
progressIndicator.progressProperty().unbind();
progressIndicator.progressProperty().bind(copyWorker.progressProperty());
~~~

Moving on, notice the code implementing a ChangeListener to append the queued results into the TextArea control. Another remarkable thing about JavaFX Properties is that you can attach many listeners similar to Java Swing components. Finally, our worker and controls are all wired up to spawn a thread to go off in the background. The following code line shows the launching of a Task worker.

~~~java
new Thread(copyWorker).start();
~~~

We finish off our code by wiring up the Cancel button. This button simply calls the Task object’s cancel() method to kill the process. Once the task is cancelled the progress controls are reset. Once a worker Task is cancelled it cannot be reused. That is why the Start button re-creates a new Task. If you want a more robust reusable solution, look at the javafx.concurrent.Service class.

# Chapter 5: Graphics with JavaFX

Have you ever heard someone say, “When two worlds collide”? This expression is used when a person from a different background or culture is put in a situation where they are at odds and must face very hard decisions. When building GUI applications needing graphics or animations, we are often on a collision course between business and gaming worlds.