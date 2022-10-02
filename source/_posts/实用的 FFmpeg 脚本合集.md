---
title: 实用的 FFmpeg 脚本合集
date: 2022-05-05 13:55:16
tags:
---

分享一些使用的FFmpeg脚本

<!-- more -->

# FFMPEG实例

[(50条消息) FFmpeg命令实例合集_张雨zy的博客-CSDN博客_ffmpeg gblur](https://blog.csdn.net/yu540135101/article/details/103025957)

## 淡入淡出效果（fade）

### 参数

```
•type, t
指定类型是in代表淡入，out代表淡出，默认为in

•start_frame, s
指定应用效果的开始时间，默认为0.

•nb_frames, n
应用效果的最后一帧序数。
对于淡入，在此帧后将以本身的视频输出，对于淡出此帧后将以设定的颜色输出，默认25.

•alpha
如果设置为1，则只在透明通道实施效果（如果只存在一个输入），默认为0

•start_time, st
指定按秒的开始时间戳来应用效果。
如果start_frame和start_time都被设置，则效果会在更后的时间开始，默认为0

•duration, d
按秒的效果持续时间。
对于淡入，在此时后将以本身的视频输出，对于淡出此时后将以设定的颜色输出。
如果duration和nb_frames同时被设置，将采用duration值。默认为0（此时采用nb_frames作为默认）

•color, c
设置淡化后（淡入前）的颜色，默认为"black".
```

### 例

```
•30帧开始淡入
fade=in:0:30

•等效上面
fade=t=in:s=0:n=30

•在200帧视频中从最后45帧淡出
fade=out:155:45 fade=type=out:start_frame=155:nb_frames=45

•对1000帧的视频25帧淡入，最后25帧淡出:
fade=in:0:25, fade=out:975:25

•让前5帧为黄色，然后在5-24淡入:
fade=in:5:20:color=yellow

•仅在透明通道的第25开始淡入
fade=in:0:25:alpha=1

•设置5.5秒的黑场，然后开始0.5秒的淡入:
fade=t=in:st=5.5:d=0.5
```

### 实例

```
ffmpeg -i 1.mp4 -vf fade=in:0:50 out3.mp4
```

## 使用高斯模糊为视频生成一个模糊背景（gblur）

### 参数

```
Apply Gaussian blur filter.

The filter accepts the following options:

sigma
Set horizontal sigma, standard deviation of Gaussian blur. Default is 0.5.

steps
Set number of steps for Gaussian approximation. Default is 1.

planes
Set which planes to filter. By default all planes are filtered.

sigmaV
Set vertical sigma, if negative it will be same as sigma. Default is -1.
```

### 命令

```
ffmpeg -i 纸短情长.mp4 -filter_complex [0:v]crop=(ih/16*9):ih,scale=iw/10:-2,gblur=sigma=5,scale=720:1280[vbg];[vbg][0:v]overlay=0:(H-h)/2 -y out.mp4	
```

### 命令解析

输入的原视频是一个1280x720的横屏视频
命令核心在于滤镜filter_complex可以拆解成两部分。

1. 背景的生成
2. 原视频与背景的叠加

#### 生成背景

```
[0:v]crop=(ih/16*9):ih,scale=iw/10:-2,gblur=sigma=5,scale=720:1280[vbg];
```

- crop=(ih/16*9)，从原视频中裁剪出一个竖屏区域作为背景
- scale=iw/10:-2，对裁剪后的视频缩小未原来的1/10以便高斯模糊（速度快）
- gblur=sigma=5，对缩小后的视频背景进行高斯模糊
- scale=720:1280[vbg]，对高斯模糊后的视频进行放大，并保存到vbg变量中

#### 背景与原视频的叠加

```
[vbg][0:v]overlay=0:(H-h)/2
```

- overlay的参数x,y。
- 0为x的坐标
- (H-h)/2是y的坐标，也就是高度居中叠加

## alphamerge实现溶图效果

### 合成命令

```
ffmpeg -i ceshi2.png -i mask.png -filter_complex [1:v]alphaextract[mask];[0:v][mask]alphamerge -y out.png
```

>  注意的是：两个输入源（这里是两个图片）的尺寸要一致，如果不一致的话，可以在滤镜中先用scale命令缩放到一致的大小。

### alphaextract

可以提取一个透明图中的透明通道。黑色代表透明，白色代表不透明。

```
ffmpeg -i mask.png -vf alphaextract -y extract.png
```

### alphamerge

可以将透明通道图，和另一个素材图合并。实现最终的效果。

## colorkey，chromakey抠图的使用

```
color
The color which will be replaced with transparency.
用于抠图的背景色。这个色值将会被替换成透明色

similarity
Similarity percentage with the key color.
0.01 matches only the exact key color, while 1.0 matches everything.
相似度，范围[0.01-1]，1的话匹配所有色值


blend
Blend percentage.
0.0 makes pixels either fully transparent, or not transparent at all.
Higher values result in semi-transparent pixels, with a higher transparency the more similar the pixels color is to the key color.
透明度[0-1]，默认0，完全透明，例如0.5则是50%的透明度
```

### colorkey抠图

```
ffmpeg -i pic1.png -vf colorkey=0xc9c8c8:0.3 -y colorkey_test_1.png
```

## edgedetect边缘检测

```
Detect and draw edges. The filter uses the Canny Edge Detection algorithm.
边缘检测，使用canny边缘算法

The filter accepts the following options:
滤镜接收一下参数

low
high
Set low and high threshold values used by the Canny thresholding algorithm.
设置Canny阈值算法使用的低阈值和高阈值。

The high threshold selects the "strong" edge pixels, which are then connected through 8-connectivity with the "weak" edge pixels selected by the low threshold.
高阈值选择“强”边缘像素，然后通过8-连通性与低阈值选择的“弱”边缘像素连接
四连通区域是11011其中0代表中心点，4个1代表上下左右四个方向。
八连通区域是111101111也就是除了上下左右四个方向外，还有左上、右上、左下、右下。

low and high threshold values must be chosen in the range [0,1], and low should be lesser or equal to high.
必须在[0,1]范围内选择低阈值和高阈值，低阈值应小于或等于高阈值。

Default value for low is 20/255, and default value for high is 50/255.
“低”的默认值为20/255，“高”的默认值为50/255

mode
Define the drawing mode.
定义绘图模式

‘wires’
Draw white/gray wires on black background.
如上图，黑白

‘colormix’
Mix the colors to create a paint/cartoon effect.
最后生成图，类似油画效果，卡通效果

‘canny’
Apply Canny edge detector on all selected planes.

Default value is wires.

planes
Select planes for filtering. By default all available planes are filtered.
```

[ffmpeg edgedetect](http://ffmpeg.org/ffmpeg-filters.html#edgedetect)

[Canny边缘检测算法](https://baike.baidu.com/item/canny算法/8439208?fr=aladdin)

## overlay动画，右移动画，左侧入场

### 命令

```
ffmpeg -i 11.jpg -vf color=c=green:s=720x1280[vbg];[vbg][0:v]overlay=x='if(lte(t,5),-w+(W+w)/2/5*t,(W-w)/2)':y=(H-h)/2 -t 5 -y move.mp4
```

### 解析

```
//输入文件
-i 11.jpg

//创建一个绿色的底板
color=c=green:s=720x1280[vbg]

//两个层叠加
[vbg][0:v]overlay=x='if(lte(t,5),-w+(W+w)/2/5*t,(W-w)/2)':y=(H-h)/2
//x的坐标
x='if(lte(t,5),-w+(W+w)/2/5*t,(W-w)/2)'
//y的坐标
y=(H-h)/2

//总时长5秒
-t 5

//生成并覆盖文件
-y move.mp4
```

### 核心

```
核心是x的坐标计算
x='if(lte(t,5),-w+(W+w)/2/5*t,(W-w)/2)'

lte(t,5)当t小于等于5的时候，执行-w+(W+w)/2/5*t

其中最核心的是-w+(W+w)/2/5*t
1.移动距离(W+w)/2
2.移动速度(W+w)/2/5
3.当前时刻的移动距离(W+w)/2/5*t
4.当前位置-w+(W+w)/2/5*t
```

## 比特率码率（-b）、帧率（-r）和文件大小（-fs）相关操作

### 帧率

> 帧率（Frame rate）也叫帧频率，帧率是视频文件中每一秒的帧数，肉眼想看到连续移动图像至少需要15帧。

帧率

```
ffmpeg –i input –r 25 output # 用 -r 参数设置帧率
ffmpeg -i 1.mp4 -vf fps=fps=25 11.mp4  # 用fps的filter设置帧率
```

例如设置帧率为29.97fps，下面三种方式具有相同的结果：

```
ffmpeg -i input.avi -r 29.97 output.mp4
ffmpeg -i input.avi -r 30000/1001 output.mp4
ffmpeg -i input.avi -r netsc output.mp4
```

### 码率

> 码率也叫比特率（Bit rate）(也叫数据率)是一个确定整体视频/音频质量的参数，秒为单位处理的字节数，码率和视频质量成正比，在视频文件中中比特率用bps来表达。

```
ffmpeg -i 1.mp4 -b 1.5M 2.mp4  # 设置参数-b
ffmpeg -i input.avi -b:v 1500k output.mp4 # 音频：-b:a ,视频： -b:v  设置视频码率为1500kbps
```

### 文件大小

```
控制输出文件大小
-fs (file size首字母缩写) 
	ffmpeg -i input.avi -fs 1024K output.mp4

计算输出文件大小
	(视频码率+音频码率) * 时长 /8 = 文件大小
```

## crop裁剪相关

### 参数

```
crop的参数格式为w:h:x:y，
w、h为输出视频的宽和高，
x、y标记输入视频中的某点，将该点作为基准点，向右下进行裁剪得到输出视频。
	如果x y不写的话，默认居中剪切
```

### 例如

```
ffmpeg -i 3.mp4 -vf crop=400:400 33.mp4 -y
ffmpeg -i 3.mp4 -vf crop=400:400:0:0 333.mp4 -y
```

## vflip，hflip实现视频对称效果，镜面水面效果，上下对称，左右对称

上下对称，水面效果

```
ffmpeg -i 1.mp4 -filter_complex "[0:v]pad=h=2*ih[a];[0:v]vflip[b];[a][b]overlay=y=h" duichen3.mp4 -y
```

左右对称，镜面效果

    ffmpeg -i 1.mp4 -filter_complex "[0:v]pad=w=2*iw[a];[0:v]hflip[b];[a][b]overlay=x=w" duichen2.mp4 -y

将视频的上半部分翻转，并覆盖在下半部分的区域

```
ffmpeg -i 4.mp4 -vf "split [main][tmp];[tmp] crop=iw:ih/2:0:0, vflip [flip];[main][flip] overlay=0:H/2" 44.mp4 -y
```

## split，pad，crop，scale，hflip，overlay

```
1.mp4
原视频

2.mp4
将视频宽度放大一倍，高不变，视频被横向拉伸
ffmpeg -i 1.mp4 -vf scale=iw*2:ih 2.mp4

3.mp4
宽高各放大一倍
ffmpeg -i 1.mp4 -vf scale=iw*2:ih*2 3.mp4

4.mp4
将宽度扩展一倍，不是缩放，不是拉伸，而是加长，用黑色填充。
ffmpeg -i 1.mp4 -vf pad=2*iw 4.mp4

5.mp4
视频水平翻转hflip 如果是竖直翻转vflip
ffmpeg -i 1.mp4 -vf hflip 5.mp4

6.mp4
将视频4和5结合，5放在4的空白区域内
ffmpeg -i 4.mp4 -i 5.mp4 -filter_complex overlay=w:0 6.mp4

7.mp4
使用过滤器链，一句命令搞定4，5，6步
ffmpeg -i 1.mp4 -vf split[a][b];[a]pad=2*iw[1];[b]hflip[2];[1][2]overlay=w:0 7.mp4
	F1: split过滤器创建两个输入文件的拷贝并标记为[a],[b]
	F2: [a]作为pad过滤器的输入，pad过滤器产生2倍宽度并输出到[1].
	F3: [b]作为hflip过滤器的输入，vflip过滤器水平翻转视频并输出到[2].
	F4: 用overlay过滤器把 [2]覆盖到[1]的旁边.
```

## 分辨率相关的操作（-s 和 -scale filter）

### 调整视频分辨率-s

```
1、用-s参数设置视频分辨率，参数值wxh，w宽度单位是像素，h高度单位是像素
ffmpeg -i input_file -s 320x240 output_file

2、预定义的视频尺寸
	下面两条命令有相同效果
	ffmpeg -i input.avi -s 640x480 output.avi
	ffmpeg -i input.avi -s vga output.avi
```

### Scale filter调整分辨率

```
Scale filter的优点是可以使用一些额外的参数
	Scale=width:height[:interl={1|-1}]
	
下面两条命令有相同效果
	ffmpeg -i input.mpg -s 320x240 output.mp4 
	ffmpeg -i input.mpg -vf scale=320:240 output.mp4

对输入视频成比例缩放
改变为源视频一半大小
	ffmpeg -i input.mpg -vf scale=iw/2:ih/2 output.mp4
改变为原视频的90%大小：
	ffmpeg -i input.mpg -vf scale=iw*0.9:ih*0.9 output.mp4
```

### 在未知视频的分辨率时，保证调整的分辨率与源视频有相同的横纵比。

> 可能会有错误，不推荐使用，最好传入明确的缩放值。另外，scale只能接受偶数，否则height not divisible by 2

```
宽度固定400，高度成比例：
	ffmpeg -i input.avi -vf scale=400:-2

相反地，高度固定300，宽度成比例：
	ffmpeg -i input.avi -vf scale=-2:300
```

## crop（宽高xy） scale（宽高） overlay（xy） 参数区别

### crop视频裁剪区域，宽高xy

```
w, out_w
The width of the output video. It defaults to iw. This expression is evaluated only once during the filter configuration, or when the ‘w’ or ‘out_w’ command is sent.

h, out_h
The height of the output video. It defaults to ih. This expression is evaluated only once during the filter configuration, or when the ‘h’ or ‘out_h’ command is sent.

x
The horizontal position, in the input video, of the left edge of the output video. It defaults to (in_w-out_w)/2. This expression is evaluated per-frame.

y
The vertical position, in the input video, of the top edge of the output video. It defaults to (in_h-out_h)/2. This expression is evaluated per-frame.
```

```
crop=w=100:h=100:x=12:y=34
```

### scale缩放，宽高

```
width, w
height, h
Set the output video dimension expression. Default value is the input dimension.

If the width or w value is 0, the input width is used for the output. If the height or h value is 0, the input height is used for the output.

If one and only one of the values is -n with n >= 1, the scale filter will use a value that maintains the aspect ratio of the input image, calculated from the other specified dimension. After that it will, however, make sure that the calculated dimension is divisible by n and adjust the value if necessary.

If both values are -n with n >= 1, the behavior will be identical to both values being set to 0 as previously detailed.

See below for the list of accepted constants for use in the dimension expression.
```

```
scale=w=200:h=100
scale=w=iw/2:h=ih/2
```

### overlay视频叠加，xy

```
x
y
Set the expression for the x and y coordinates of the overlaid video on the main video.
Default value is "0" for both expressions. 
In case the expression is invalid, it is set to a huge value 
(meaning that the overlay will not be displayed within the output visible area)
```

```
overlay=0:0
```

## scale宽高只能接受偶数，否则出错 height not divisible by 2

例如想要把视频缩放到1111x1111，则会报错 height not divisible by 2

```
ffmpeg -i 10.mp4 -vf scale=1111:1111 101010.mp4
```

FFmpeg中的scale命令后面的宽高，只能接受偶数

```
ffmpeg -i 10.mp4 -vf scale=1110:1110 101010.mp4
```

可行的方案是：在scale中加入处理trunc类似于int取整，对1111/2取整，最后在*2，结果一定是偶数

```
ffmpeg -i 10.mp4 -vf scale=trunc(1111/2)*2:trunc(1111/2)*2 101010.mp4
```

另一个简单的方案：高度使用-2，负数代表自动按比例缩放，2代表结果取2的倍数

```
ffmpeg -i in.mp4 -vf scale=iw:-2 out.mp4
```

> 另外：crop命令裁剪的时候，会自动裁剪成偶数

## -map命令的使用

### 介绍

标题理解-map参数的最好办法就是想像一下怎么去告诉ffmpeg你要从源文件中选择/拷贝哪个流到输出文件。输出文件的stream顺序取决于在命令行中-map的参数顺序。

### 默认

默认操作（没有指定map参数），比如：

```
ffmpeg -i INPUT OUTPUT
```

本质上，是从所有输入中发现“最高质量”（单个）视频输入流和“最高质量”（单个）音频输入流，并“发送”到OUTPUT。所有其他输入流实质上都被丢弃了。

如果我们想用map命令“显示”与上面命令相同的操作，它会是这样的：

```
ffmpeg -i INPUT -map single_highest_quality_video_stream_from_all_inputs -map single_highest_quality_audio_stream_from_all_inputs OUTPUT
```

此处输出将有两个流，一个音频，一个视频。

当你想要控制哪些流被包含，或者在输出中包含不止一个流时，你需要/想要手动指定“-map”命令，并修改这些参数。

输入文件
在下面的所有示例中，我们将使用一个类似下面的示例输入文件：

```
# fmpeg -i input.mkv

ffmpeg version ... Copyright (c) 2000-2012 the FFmpeg developers
...
Input #0, matroska,webm, from 'input.mkv':
  Duration: 01:39:44.02, start: 0.000000, bitrate: 5793 kb/s
    Stream #0:0(eng): Video: h264 (High), yuv420p, 1920x800, 23.98 fps, 23.98 tbr, 1k tbn, 47.95 tbc (default)
    Stream #0:1(ger): Audio: dts (DTS), 48000 Hz, 5.1(side), s16, 1536 kb/s (default)
    Stream #0:2(eng): Audio: dts (DTS), 48000 Hz, 5.1(side), s16, 1536 kb/s
    Stream #0:3(ger): Subtitle: text (default)
At least one output file must be specified
```

例子1
那么现在，我们说我们想要：

将视频流复制
将德语音频流编码为MP3（128kbps）和AAC（96kbps）（在输出中创建两个音频流）
将英语音频流删除
将字幕流复制
这可以用以下的ffmpeg命令来完成：

```
ffmpeg -i input.mkv \
    -map 0:0 -map 0:1 -map 0:1 -map 0:3 \
    -c:v copy \
    -c:a:0 libmp3lame -b:a:0 128k \
    -c:a:1 libfaac -b:a:1 96k \
    -c:s copy \
    output.mkv
```

注意一下参数里没有“-map 0:2”，并且“-map 0:1”被写了两次。

使用“-map 0:0 -map 0:1 -map 0:1 -map 0:3”，我们告诉ffmpeg选择/映射指定的输入流按相应顺序输出。

因此，我们的输出将具有以下流：

```
Output #0, matroska, to 'output.mkv':
    Stream #0:0(eng): Video ...
    Stream #0:1(ger): Audio ...
    Stream #0:2(ger): Audio ...
    Stream #0:3(ger): Subtitle ...
```

在我们选择好在输出中包含哪些流之后，使用“-map”选项，我们为输出中的每个流指定相应的编解码器。

视频和字幕流已经被复制，德语的音频流被编码成了两个新的音频流，MP3和AAC。

我们使用“-c?️0”来指定输出的第一路音频流编解码器（codec），且用“-c?️1”来指定输出的第二路音频流编解码器（codec）。

注意，“a:0”指的是输出的第一路音频流（本例中为0:1）,“a:1”指的是输出的第二路音频流（也映射到输入流0:1），等。

结果将会是：

```
Output #0, matroska, to 'output.mkv':
    Stream #0:0(eng): Video ...
    Stream #0:1(ger): Audio ...
    Stream #0:2(ger): Audio ...
    Stream #0:3(ger): Subtitle ...
Stream mapping:
  Stream #0:0 -> #0:0 (copy)
  Stream #0:1 -> #0:1 (dca -> libmp3lame)
  Stream #0:2 -> #0:2 (dca -> libfaac)
  Stream #0:3 -> #0:3 (copy)
```

例子2
如果说我们想要倒序排列输入流，比如类似这样的输出：

```
Stream #0:0(ger): Subtitle: text (default)
Stream #0:1(eng): Audio: dts (DTS), 48000 Hz, 5.1(side), s16, 1536 kb/s
Stream #0:2(ger): Audio: dts (DTS), 48000 Hz, 5.1(side), s16, 1536 kb/s (default)
Stream #0:3(eng): Video: h264 (High), yuv420p, 1920x800, 23.98 fps, 23.98 tbr, 1k tbn, 47.95 tbc (default)
```

这可以简单地使用下面的命令行来完成：

```
ffmpeg -i input.mkv -map 0:3 -map 0:2 -map 0:1 -map 0:0 -c copy output.mkv
```

注意，我们指定了所有的输入流，输出中的流顺序也会按照输入流的顺序生成。

选项“-c copy”告诉ffmpeg在所有流上使用“复制”操作。

例子3
如果我们想从同一个输入文件中仅提取音频流，那么我们可以这样做：

```
ffmpeg -i input.mkv -map 0:1 -map 0:2 -c copy output.mkv
```

例子4
如果我们想重新编码视频流，但复制所有其他流（如音频、字幕、附件等），我们可能会使用这样的东西：

```
ffmpeg -i input.mkv -map 0 -c copy -c:v mpeg2video output.mkv
```

这将会告诉ffmpeg：

读取输入文件“‘input.mkv’”
选择要处理的所有输入流（第一个input＝0）（使用“-map 0”）
标记所有流被复制到输出（使用“-c copy”）
标记要重新编码的视频流（使用“-c:v mpeg2video”）
写入输出文件到“output.mkv”

例子5
你可以使用"-map"命令来创建多路文件输出，比如：

```
ffmpeg -i input.mkv -map 0:1 -map 0:2 audios_only.mkv -map 0:0 video_only.mkv
```

默认是将“最高质量视频”和“最高质量音频”映射到每个输出文件（基本上为每个输出重复使用），更多请参考创建多个输出。

例子6
你可以使用一个滤镜（filtergraph）做为map参数来控制输出：

```
ffmpeg -i INPUT -filter_complex "[0] scale=100x100[smaller_sized]"  -map "[smaller_sized]" out.mp4
```

这（在我们的示例中）与更精确地指定流是相同的，并且完全一样。

```
ffmpeg -i INPUT -filter_complex “[0:0] scale=100x100[smaller_sized]” -map “[smaller_sized]” out.mp4
```

例子7
还有一些流选择快捷方式，比如你也可以使用“0:v”：

```
ffmpeg -i input -map 0:v -map 0:a output.mkv # chooses video and audio from input 0
```

具体请参见流指示器

例子8
MPEG流的选择：

最棘手的部分是从MPEG TS流选择时它可能会有多个流/通道，如果你正在接收“实时数据”（live data）,仅仅指定索引可能是不行的，因为索引可以在运行时有所变化，所以：

```
ffmpeg -i INPUT -map 0:6 OUTPUT # 每次运行产生的结果可能都不一样，请不要这样使用!
```

假设您的文件是MPEG，您可以运行“ffmpeg -i INPUT”（不指定输出）来查看它包含的程序ID和流ID，比如这个示例（对其进行分析，以帮助“确保”它接收到其中的所有流，可能并不总是需要的）。

```
$ ffmpeg -probesize 50M -analyzeduration 50M -i INPUT
...
Input #0, mpegts, from 'INPUT':
  Duration: N/A, start: 22159.226833, bitrate: N/A
  Program 1344
    Metadata:
      service_name    : 7 Digital
      service_provider: Seven Network
    Stream #0:0[0x401]: Video: mpeg2video (Main) ([2][0][0][0] / 0x0002), yuv420p(tv), 720x576 [SAR 64:45 DAR 16:9], max. 14950 kb/s, 25 fps, 25 tbr, 90k tbn, 50 tbc
    Stream #0:1[0x402](eng): Audio: mp2 ([3][0][0][0] / 0x0003), 48000 Hz, stereo, s16p, 256 kb/s
  Program 1346
    Metadata:
      service_name    : 7TWO
      service_provider: Seven Network
    Stream #0:3[0x406]: Unknown: none ([5][0][0][0] / 0x0005)
    Stream #0:6[0x421]: Video: mpeg2video (Main) ([2][0][0][0] / 0x0002), yuv420p(tv), 720x576 [SAR 64:45 DAR 16:9], max. 14950 kb/s, 25 fps, 25 tbr, 90k tbn, 50 tbc
    Stream #0:7[0x422](eng): Audio: mp2 ([3][0][0][0] / 0x0003), 48000 Hz, stereo, s16p, 192 kb/s
    Stream #0:8[0x424](eng): Subtitle: dvb_teletext ([6][0][0][0] / 0x0006), 492x250
    Stream #0:4[0x499]: Unknown: none ([11][0][0][0] / 0x000B)
```

你可以通过程序ID指定所需的流：

```
ffmpeg -i INPUT -map 0:p:1344 OUTPUT # 从程序1344中输入两个输入，在本例子中是通道“7 digital”
```

或指定子流：

```
ffmpeg -i INPUT -map i:0x401 OUTPUT # 从找到的任何地方用PID（MPEG Packet ID [stream identifier]）`0x401拉入单个输入流，在本例中，它是“7 digital”中的视频流
```

其他类似的，请参阅其说明符示例。注意，如果你有“未知”的流在那里，你可能需要添加-ignore_unknown标志。

还请注意，如果输入流包含多个程序ID，则可以使用相同的ffmpeg实例和这里描述的map命令同时来记录它们。

例子9
包括“全部”输入到输出。默认行为是只复制一个音频和一个视频通道。如果你想复制“所有”频道，请使用“-map”：

```
ffmpeg -i input -map 0 output.mp4 # 从一个输入重新编码所有视频和音频通道 
ffmpeg -i input -map 0 -c copy output.mp4 # 将所有视频和音频通道从一个输入复制到输出，而不是仅一个视频
```

英文原文地址：http://trac.ffmpeg.org/wiki/Map

## 视频的倒放

```
Reverse a video clip.

Warning: This filter requires memory to buffer the entire clip, so trimming is suggested.

Examples
Take the first 5 seconds of a clip, and reverse it.
trim=end=5,reverse
```

```
ffmpeg -i G:\1\c6cfb2d13929eb4967417e0bd81c314c.mp4 -vf reverse -y reverse.mp4
```

## 生成YUV、PCM原始数据

### YUV

提取YUV数据

```
ffmpeg -i input.mp4 -an -c:v rawvideo -pixel_format yuv420p out.yuv
-c:v rawvideo 指定将视频转成原始数据
-pixel_format yuv420p 指定转换格式为yuv420p

播放这个
ffplay -s wxh out.yuv

YUV转H264
ffmpeg -f rawvideo -pix_fmt yuv420p -s 320x240 -r 30 -i out.yuv -c:v libx264 -f rawvideo out.h264
```

### PCM

```
提取PCM数据
ffmpeg -i out.mp4 -vn -ar 44100 -ac 2 -f s16le out.pcm

播放PCM
ffplay -ar 44100 -ac 2 -f s16le -i out.pcm

PCM转WAV
ffmpeg -f s16be -ar 8000 -ac 2 -acodec pcm_s16be -i input.raw output.wav
```

举例：

```
//特效边框+底板视频，生成yuv视频
ffmpeg -i a3.mp4 -stream_loop -1 -i partPlay_color_video_12.mp4 -stream_loop -1 -i partPlay_gray_video_12.mp4 -filter_complex [1:v][2:v]alphamerge[vTheme];[0:v][vTheme]overlay=(W-w)/2:(H-h)/2 -an -c:v rawvideo -pixel_format yuv420p -t 100 -y outTest.yuv

//播放这个视频
ffplay -s 1280x720 outTest.yuv
```

## 音频设置采样率，和声道数

原始音频信息，采样率44100 Hz，双声道stereo

```
Duration: 00:11:23.60, start: 0.025057, bitrate: 128 kb/s
Stream #0:0: Audio: mp3, 44100 Hz, stereo, fltp, 128 kb/s
```

```
ffmpeg -i C:\Users\Administrator\Desktop\materials\蕊希.mp3 -ac 1 -ar 48000 -y test.mp3

其中：
-ac 1 设置声道数为1
-ar 48000 设置采样率为48000Hz
```

转码后的音频，采样率48000 Hz，单声道mono

```
Duration: 00:11:23.59, start: 0.023021, bitrate: 64 kb/s
Stream #0:0: Audio: mp3, 48000 Hz, mono, fltp, 64 kb/s
```

## volume 和 -vol 调大调小音视频的音量

### volume

```
//音量翻倍，写在滤镜里，例如
ffmpeg -i 1.wav -af volume=2 -y 2.wav
```

### vol

```
//音量翻倍，不写在滤镜中，例如
ffmpeg -i 1.wav -vol 2000 -y 2.wav
```

## 为视频添加关键帧，可以解决播放器无法SeekTo到关键帧的问题

```
//每隔10帧设置一个关键帧，如果是30帧的视频，则代表每秒3个关键帧
ffmpeg -i 2.mp4 -c:v libx264 -x264opts keyint=10 -y keyint10.mp4

//每帧都是关键帧
ffmpeg -i 2.mp4 -c:v libx264 -x264opts keyint=1 -y keyint11.mp4

//每秒一个关键帧
ffmpeg -i 2.mp4 -c:v libx264 -x264opts keyint=30 -y keyint12.mp4



-i 2.mp4
输入文件

-c:v libx264
编码器使用libx264

-x264opts keyint=10
视频文件每隔 10帧设置一个关键帧

-y keyint10.mp4
输出文件
```

## 视频的旋转rotate

```
Rotate video by an arbitrary angle expressed in radians.

The filter accepts the following options:

A description of the optional parameters follows.

angle, a
Set an expression for the angle by which to rotate the input video clockwise, expressed as a number of radians. A negative value will result in a counter-clockwise rotation. By default it is set to "0".

This expression is evaluated for each frame.

out_w, ow
Set the output width expression, default value is "iw". This expression is evaluated just once during configuration.

out_h, oh
Set the output height expression, default value is "ih". This expression is evaluated just once during configuration.

bilinear
Enable bilinear interpolation if set to 1, a value of 0 disables it. Default value is 1.

fillcolor, c
Set the color used to fill the output area not covered by the rotated image. For the general syntax of this option, check the (ffmpeg-utils)"Color" section in the ffmpeg-utils manual. If the special value "none" is selected then no background is printed (useful for example if the background is never shown).

Default value is "black".

The expressions for the angle and the output size can contain the following constants and functions:

n
sequential number of the input frame, starting from 0. It is always NAN before the first frame is filtered.

t
time in seconds of the input frame, it is set to 0 when the filter is configured. It is always NAN before the first frame is filtered.

hsub
vsub
horizontal and vertical chroma subsample values. For example for the pixel format "yuv422p" hsub is 2 and vsub is 1.

in_w, iw
in_h, ih
the input video width and height

out_w, ow
out_h, oh
the output width and height, that is the size of the padded area as specified by the width and height expressions

rotw(a)
roth(a)
the minimal width/height required for completely containing the input video rotated by a radians.

These are only available when computing the out_w and out_h expressions.
```

```
//T为旋转一周的时长，如果为视频的时长，则旋转一圈，正好可以播放完
ffmpeg -i a3.mp4 -vf rotate=PI*2/T*t rotate8.mp4
```

rotate的第一个参数angle的单位是弧度
1°=π/180
360°=2π

### 例如将视频旋转90°，注意此种方式，并没有改变水平尺寸

```
ffmpeg -i a3.mp4 -vf rotate=PI/2 rotate9.mp4
```

## 视频的翻转vflip、hflip，旋转rotate、转置transpose

### 翻转hflip

```
//水平翻转
ffmpeg -i fan.jpg -vf hflip -y hflip.png
```

### 旋转rotate

```
//旋转60°，是带有黑底的。图片的原始宽高并没有改变
ffmpeg -i fan.jpg -vf rotate=PI/3 -y rotate60.png
```

### 转置transpose

![](https://img-blog.csdnimg.cn/20190702211143610.png)

```
//逆时针旋转90°
ffmpeg -i fan.jpg -vf transpose=2 -y transpose2.png
//逆时针旋转90°，然后垂直翻转
ffmpeg -i fan.jpg -vf transpose=0 -y transpose0.png
```

## 视频的旋转rotate升级版，rotate，alphamerge

### 给视频加上mask后，旋转，并叠加在另一个视频上

```
//方案1 （有黑底）

ffmpeg -loop 1 -i 圆形.png -i maskBase.mp4 -i a3.mp4 -filter_complex [0:v]alphaextract[vMaskAlpha];[1:v][vMaskAlpha]alphamerge[vTop];[vTop]rotate=PI*2/10*t[vRotate];[2:v][vRotate]overlay=(W-w)/2:(H-h)/2 -y maskRotateOverlay.mp4

// 方案二：分成两步
// 1.视频加上Mask以后，并且旋转
// mask和底部视频尺寸要一致，时长也要一致，所以加上了-loop 1
ffmpeg -loop 1 -i 圆形.png -i maskBase.mp4  -filter_complex [0:v]alphaextract[vMaskAlpha];[1:v][vMaskAlpha]alphamerge[vTop];[vTop]rotate=PI*2/10*t[vRotate];color=c=black:s=648x648[vBg];[vBg][vRotate]overlay -t 10 -y maskRotate.mp4
// 2.去掉黑底，并且overlay
ffmpeg -i a3.mp4 -i maskRotate.mp4 -filter_complex [1]split[m][a];[a]geq='if(gt(lum(X,Y),50),255,0)',hue=s=0[al];[m][al]alphamerge[ovr];[0][ovr]overlay=(W-w)/2:(H-h)/2 -y maskRotateOverlay2.mp4
// 不够完美，黑色去掉的有点多了，有好的方案在改吧

// 方案三：最终方案
// 在方案一的基础上给rotate加一个参数c=none
ffmpeg -loop 1 -i 圆形.png -i maskBase.mp4 -i a3.mp4 -filter_complex [0:v]alphaextract[vMaskAlpha];[1:v][vMaskAlpha]alphamerge[vTop];[vTop]rotate=PI*2/10*t:c=none[vRotate];[2:v][vRotate]overlay=(W-w)/2:(H-h)/2 -y maskRotateOverlay33.mp4

// 方案四：如果顶部是一个方形的视频
// 可以看到就像扑克牌一样，一帧帧的铺开，所以要用圆形来旋转，即使加上eof_action=pass，也只是最后播放完成后，顶层视频帧一起消失
ffmpeg -i maskBase.mp4 -i a3.mp4 -filter_complex [0:v]format=bgra,rotate='PI*2/10*t:ow=hypot(iw,ih):oh=ow:c=none'[vRotate];[1:v][vRotate]overlay=(W-w)/2:(H-h)/2 -t 3 -y maskRotateOverlay55.mp4


// 最终方案，核心，c=0x00000000 给一个透明色即可
ffmpeg -loop 1 -i 1567495070237.bmp -i a3.mp4 -filter_complex [0:v]format=bgra,rotate='PI*2/10*t:ow=hypot(iw,ih):oh=ow:c=0x00000000'[vRotate];[1:v][vRotate]overlay=(W-w)/2:(H-h)/2 -t 3 -y noBlackPad.mp4
```

## 为视频设置透明度的几种方案

### 方案一：

```
ffmpeg -i a2.mp4 -i a3.mp4 -filter_complex [0:v]format=yuva444p,colorchannelmixer=aa=0.5[valpha];[1:v][valpha]overlay=(W-w)/2:(H-h)/2 -ss 0 -t 5  -y overlay4.mp4
```

### 方案二： 对图片有效，经过测试

```
ffmpeg -i in4.png -i a3.mp4 -filter_complex [0:v]geq=a='122':lum='lum(X,Y)':cb='cb(X,Y)':cr='cr(X,Y)'[topV];[1:v][topV]overlay=(W-w)/2:(H-h)/2 -ss 0 -t 5 -y overlay3.mp4
```

### 方案三：同方案二，只是先将视频转换成一张张帧序列然后再使用方案二

此处经过测试，同样在ffmpeg 4.13下。Windows，Android，iOS 只有IOS下可以对视频进行geq，所以其他平台只能先转换成图片序列，然后再做geq

```
//此处经过测试，同样在ffmpeg 4.13下。Windows，Android，iOS 只有IOS下可以对视频进行geq
ffmpeg -i a2.mp4 -i a3.mp4 -filter_complex [0:v]geq=a='122':lum='lum(X,Y)':cb='cb(X,Y)':cr='cr(X,Y)'[topV];[1:v][topV]overlay=(W-w)/2:(H-h)/2 -ss 0 -t 5 -y overlay2.mp4
```

## 视频添加个黑色的遮罩

### 数值越大越不透明

color命令可以新建一个颜色图层，然后使用overlay叠加在视频上

```
ffmpeg -i out3.mp4 -filter_complex color=s=1000x1000:c=black@.3[vc];[0:v][vc]overlay[out] -ss 0 -to 10 -map [out] -y ou4.mp4
```

```
ffmpeg -i 123.mov -filter_complex color=s=1000x1000:c=black@.9[vc];[0:v][vc]overlay[out] -ss 0 -to 10 -map [out] -y ou4.mp4
```

## 视频与图片互转，视频转gif，单张图片合成视频，提取封面，单帧

### 视频转gif

```
视频转gif
ffmpeg -i out.mp4 -ss 00:00:00 -t 10 out.gif
	t的格式
	-t  1.1
	-t 00:00:01
	-r 帧率每秒的帧数，数值越大越流畅
```

### 视频中提取任意一帧图片

```
ffmpeg -i test.asf -y -f  image2  -ss 00:01:00 -vframes 1  test1.jpg
or
ffmpeg -i test.asf -y -f  image2  -ss 60 -vframes 1  test1.jpg
//png格式不会压缩
ffmpeg -i 1.avi -f image2 -ss 2 -vframes 1 test1.png
```

### 视频转图片

视频转图片，-r 帧率每秒钟转化1张，image2为image协议的第二版

```
ffmpeg -i 2.mp4 -r 1 -f image2 image-%d.jpg
```

图片转视频
注意：png需要特殊处理，如下
图片转视频，jpg例子
从一个文件序列 img-1.jpeg, img-2.jpeg, ...,创建视频，帧率为10:

```
ffmpeg -framerate 10 -i img-%d.jpeg out.mkv
ffmpeg -framerate 30 -i image-%d.jpg -y out.mp4

//png图片的合成，如果没有特殊加背景，则背景是黑色的。
ffmpeg -framerate 30 -i image-%d.png -c:v libx264 -pix_fmt yuv420p -y out3.mp4

类似上例，但开始的数字是100，即索引是从100开始计数:
ffmpeg -framerate 10 -start_number 100 -i 'img-%d.jpeg' out.mkv

读取"*.png" 以通配符模式处理，这将包含所有".png"结尾的文件:
ffmpeg -framerate 10 -pattern_type glob -i "*.png" out.mkv
```

单张图片合成视频

```
//单张图片合成视频，这里需要用到-loop 1 开启循环，和-t 10 设置为10秒
ffmpeg -r 1 -f image2 -loop 1 -i 1.png  -t 10 out.mp4 -y
```


单张图片生成视频，通过滤镜完成

```
ffmpeg -i 1.png -filter_complex color=s=500x500:c=black,trim=0:5[vbg];[0:v]scale=500x500[sv];[vbg][sv]overlay[vout] -map [vout] -y 1.mp4
```

```
ffmpeg -i 1.jpg -filter_complex color=s=720x1280:c=black[vbg];[0:v]scale=720x1280[sv];[vbg][sv]overlay[vout] -map [vout] -ss 0 -to 10 -y 1.mp4
```

```
ffmpeg 
-i 
1.png 
-filter_complex 
color=s=500x500:c=black,trim=0:5[vbg];
[0:v]scale=500x500[sv];
[vbg][sv]overlay[vout] 
-map 
[vout] 
-y 
1.mp4
```

## 为视频添加一个循环播放的背景音乐（混声）

### 方案1（不推荐）（混声）

```
ffmpeg -i E:\1\subtitle\out3.mp4 -i E:\1\subtitle\music3D.wav -filter_complex [1:a]aloop=loop=-1:size=2e+09[out];[out][0:a]amix -ss 0 -t 60 -y out.mp4
```

- -i E:\1\subtitle\out3.mp4 //输入视频，最好选一个大于一分钟的尝试
- -i E:\1\subtitle\music3D.wav //输入背景音，最好短一点，方便测试是否循环
- -filter_complex //滤镜
- [1:a]aloop=loop=-1:size=2e+09[out]; //将背景音无限循环
- [out][0:a]amix //将背景音和视频中的音频混合
- -ss 0 -t 60 //裁剪总时长，裁剪到60秒
- -y out.mp4 //输出

### 方案2（推荐）（混声）

```
ffmpeg -i video.mp4 -stream_loop -1 -i audio.wav -filter_complex [0:a][1:a]amix -t 60 -y out.mp4
```

其中

- -stream_loop -1 -i audio.wav
- -stream_loop -1 参数-1代表循环输入源
- [0:a][1:a]amix 将0和1号的音频流进行混合
- -t 60 裁剪60秒

### 方案3（推荐）（音频替换）

```
ffmpeg -an -i video.mp4 -stream_loop -1 -i audio.wav -t 60 -y out2.mp4
```

其中

```
-an -i video.mp4 代表消除视频中的音频
```

### 方案4（推荐）（音频替换，优化加快合成速度）

```
ffmpeg -an -i video.mp4 -stream_loop -1 -i audio.wav -c:v copy -t 60 -y out.mp4
```

- -c:v copy 对视频流进行复制，不需要重新编解码（前提是输入流和输出流一致），速度极快

这里音频必须编码的原因在于，输入源是一个wav的音频，而最后输出MP4文件中需要一个aac的音频，所以必须重新编码，否则会报错。

### 方案5（原视频无音轨的情况）

为无音轨的视频添加一个循环的背景音乐
原视频无音轨的情况下不需要混声，直接导入两个源文件（源视频，背景音）

```
ffmpeg -i video_no_audio.mp4 -stream_loop -1 -i 世界这么大.wav -ss 0 -t 30 -y out.mp4
```

## drawtext在视频上添加文字

[官方文档drawtext](http://ffmpeg.org/ffmpeg-filters.html#drawtext-1)

默认值

```
默认字体 Sans
默认颜色 black
默认字体大小 16
```

最简单的demo，全部使用默认
字符中间有空格，最外层需要双引号引用

```
ffmpeg -i a3.mp4 -vf drawtext="text=test test" -y out1.mp4
```

绘制位置，字体大小100，背景色blue

```
ffmpeg -i a3.mp4 -vf drawtext="text=test test:x=100:y=100:fontsize=100:fontcolor=white:box=1:boxcolor=blue" -y out2.mp4
```

### 中心区域绘制文字

```
ffmpeg -i a3.mp4 -vf drawtext="fontsize=100:fontcolor=white:text='hello world':x=(w-text_w)/2:y=(h-text_h)/2" -y out3.mp4
```

## setpts，atempo视频音频加减速

```
视频加速
ffmpeg -i 1.mp4 -vf "setpts=0.5*PTS" 1jiasu.mp4
视频减速
ffmpeg -i 2.mp4 -vf "setpts=2.0*PTS" 2jiansu.mp4

音频加速
"atempo"滤镜对音频速度调整限制在0.5 到 2.0 之间，（即半速或倍速）
2倍速
ffmpeg -i 1jiasu.mp4 -af "atempo=2.0" 1quanbujiasu.mp4
4倍速
ffmpeg -i 1jiasu.mp4 -af "atempo=2.0,atempo=2.0" 1quanbujiasu.mp4

使用更复杂的滤镜，可以同时加速视频和音频：
ffmpeg -i 1.mp4 -filter_complex "[0:v]setpts=0.5*PTS[v];[0:a]atempo=2.0[a]" -map "[v]" -map "[a]" 11quanbu.mp4
```

## 混音（混声）命令

```
inputs
The number of inputs. If unspecified, it defaults to 2.//输入的数量，如果没有指明，默认为2.
 
duration
How to determine the end-of-stream.//决定了流的结束
 
			longest
			The duration of the longest input. (default)//最长输入的持续时间
			shortest
			The duration of the shortest input.//最短输入的持续时间
			first
			The duration of the first input.//第一个输入的持续时间
 
dropout_transition
The transition time, in seconds, for volume renormalization when an input stream ends. The default value is 2 seconds.
//指一个输入流结束时音量从正常到无声渐止效果，默认为2秒
```

```
ffmpeg -i INPUT1 -i INPUT2 -i INPUT3 -filter_complex amix=inputs=3:duration=first:dropout_transition=3 OUTPUT
```

## 快速将视频转换为小而清晰的 GIF

```
$ ffmpeg -an -skip_frame nokey -i 输入文件 -vf scale=导出分辨率:flags=fast_bilinear,palettegen=max_colors=色彩数量:stats_mode=diff 色板文件
$ ffmpeg -an -i 输入文件 -i 色板文件 -r 输出文件帧率 -lavfi "framestep=原视频帧率/输出文件帧率*变速速率,setpts=PTS/变速速率,scale=导出分辨率:flags=lanczos [x]; [x][1:v] paletteuse=dither=bayer" 输出文件
```

此脚本比较复杂，需要将汉字部分按下表进行填写替换：

| 参数名       | 填写示例      | 说明                                                         |
| ------------ | ------------- | ------------------------------------------------------------ |
| 输入文件     | `input.mp4`   | 输入视频文件的路径                                           |
| 导出分辨率   | `320:240`     | 长和宽必须都是2的倍数                                        |
| 色彩数量     | `128`         | 可接受的值为`[4, 256]`；值越大，色彩越保真，但输出的文件体积也越大； |
| 色板文件     | `palette.png` | `GIF`调色板文件。在第一行生成，并第二行使用到                |
| 视频帧率     | `60`          | 输入的视频的帧率                                             |
| 输出文件帧率 | `10`          | 输出的`GIF`的帧率                                            |
| 变速速率     | `1.0`         | 如果不需要变速，填写`1.0`；二倍速则填写`2.0`，依此类推       |
| 输出文件     | `output.gif`  | 输出`GIF`文件的路径                                          |

------

## 光流法补帧

```
$ ffmpeg -i input.mp4 -filter:v "minterpolate='fps=60:mi_mode=mci:mc_mode=aobmc:vsbmc=1'" optical_flow.mp4
```

`60`为目标帧率。

速度较慢，效果可能没有`Premiere Pro`的光流法好。

------

## 降低视频抖动

```
$ ffmpeg -i input.mp4 -vf vidstabdetect=shakiness=10:result="mytransforms.trf" -f null -
$ ffmpeg -i input.mp4 -vf vidstabtransform=smoothing=30:input="mytransforms.trf",unsharp=5:5:0.8:3:3:0.4  stabilized.mp4
```

此操作需要两行：第一行分析视频`input.mp4`的内容，并将结果保存至`mytransforms.trf`；第二行生成稳定后的视频`stabilized.mp4`。

速度较慢，且效果不如`Google Photos`和`Premiere Pro`好。

------

## 获取媒体文件属性

```
$ ffprobe -v error -show_format -show_streams input.mp4
```

上面将返回媒体文件的所有属性。

```
$ ffprobe -v quiet -select_streams V:0 -show_entries stream=width,height,r_frame_rate,bit_rate -of csv=p=0:sv=fail -i input.mp4
```

有时只需要媒体文件中的特定几项信息，可以通过类似这样的方式指定。（这条脚本将返回视频流的宽、高、帧率、比特率，中间以逗号分隔，如`1920,1080,30/1,11895227`）

------

## 压缩音频为无损 FLAC

```
$ ffmpeg -i input.wav -c:a flac -compression_level 12 output.flac
```

------

## 压缩音频为有损 Opus

```
$ ffmpeg -i input.wav -c:a libopus -b:a 128k output.ogg
```

`128k`为比特率。

`Opus`可能是目前压缩率最佳的音频编码器，在极低的比特率下也能提供优秀的音质，且大部分软件都兼容此格式。

## 从一堆ts文件生成m3u8文件的脚本

```shell
#!/bin/bash

echo '#EXTM3U'
echo '#EXT-X-VERSION:3'
echo '#EXT-X-MEDIA-SEQUENCE:1'

maxDuration=0

while read f; do
	duration="$(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "$f" |  grep -E '^[0-9]+(\.[0-9]+)?$' | head -n1)"
	echo "#EXTINF:$duration,"
	echo $f

	if [ `echo "$duration > $maxDuration" | bc` -eq 1 ]; then
		maxDuration="$duration"
	fi
done

echo '#EXT-X-ENDLIST'
echo "#EXT-X-TARGETDURATION:$maxDuration"
```

#### 依赖：

- `ffprobe`命令，可通过安装`ffmpeg`软件包得到。
- `bc`命令，可通过安装`bc`软件包得到。

```
# 在Debian上安装依赖
sudo apt install ffmpeg bc
```

#### 用法：

```
wget -O gen_ts_m3u8.sh https://vkceyugu.cdn.bspapp.com/VKCEYUGU-cc8cf08f-49f5-4fc5-83c3-ed2a683704d4/4db7c4a8-9131-4771-9d36-71a2b30ca35a.sh
chmod +x gen_ts_m3u8.sh
ls *.ts | ./gen_ts_m3u8.sh | tee main.m3u8
```

## 使用GPU加速

```
ffmpeg -hwaccels
```

如下

```
ffmpeg version 4.2.4-1ubuntu0.1 Copyright (c) 2000-2020 the FFmpeg developers
  built with gcc 9 (Ubuntu 9.3.0-10ubuntu2)
  configuration: --prefix=/usr --extra-version=1ubuntu0.1 --toolchain=hardened --libdir=/usr/lib/x86_64-linux-gnu --incdir=/usr/include/x86_64-linux-gnu --arch=amd64 --enable-gpl --disable-stripping --enable-avresample --disable-filter=resample --enable-avisynth --enable-gnutls --enable-ladspa --enable-libaom --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 --enable-libflite --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libgme --enable-libgsm --enable-libjack --enable-libmp3lame --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libopus --enable-libpulse --enable-librsvg --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libssh --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opencl --enable-opengl --enable-sdl2 --enable-libdc1394 --enable-libdrm --enable-libiec61883 --enable-nvenc --enable-chromaprint --enable-frei0r --enable-libx264 --enable-shared
  libavutil      56. 31.100 / 56. 31.100
  libavcodec     58. 54.100 / 58. 54.100
  libavformat    58. 29.100 / 58. 29.100
  libavdevice    58.  8.100 / 58.  8.100
  libavfilter     7. 57.100 /  7. 57.100
  libavresample   4.  0.  0 /  4.  0.  0
  libswscale      5.  5.100 /  5.  5.100
  libswresample   3.  5.100 /  3.  5.100
  libpostproc    55.  5.100 / 55.  5.100
Hardware acceleration methods:
vdpau
cuda
vaapi
drm
opencl
cuvid
```

### 测试命令

将当前目录下的0.mp4转成00.mp4

```
ffmpeg -hwaccel cuvid -c:v h264_cuvid -i 0.mp4 -c:v h264_nvenc -y 00.mp4
```


将当前目录下的0.mp4转成00.mp4，并指定输出帧率为15（-r 15），比特率为500k（-b 500k）

```
ffmpeg -hwaccel cuvid -c:v h264_cuvid -i 0.mp4 -c:v h264_nvenc -r 15 -b 500k -y 00.mp4

```

```
ffmpeg -hwaccel cuvid -c:v h264_cuvid -i <input> -c:v h264_nvenc -b:v 2048k -vf scale_npp=1280:-1 -y <output>
```

- hwaccel cuvid：指定使用cuvid硬件加速

- c:v h264_cuvid：使用h264_cuvid进行视频解码
- c:v h264_nvenc：使用h264_nvenc进行视频编码
- vf scale_npp=1280:-1：指定输出视频的宽高，注意，这里和软解码时使用的-vf scale=x:x不一样

### 多颗显卡命令

GPU转码效率测试

> 在配有两颗Intel-E5-2630v3 CPU和两块Nvidia Tesla M4显卡的服务器上，进行h264视频转码测试，成绩如下：

GPU转码平均耗时：8s
CPU转码平均耗时：25s

> 并行转码时，CPU软转的效率有所提高，3个转码任务并行时32颗核心全被占满，此时的成绩

GPU转码平均耗时：8s
CPU转码平均耗时：18s

不难看出，并行时GPU的转码速度并没有提高，可见一颗GPU同时只能执行一个转码任务。那么，如果服务器上插有多块显卡，ffmpeg是否会使用多颗GPU进行并行转码呢？
很遗憾，答案是否。
ffmpeg并不具备自动向不同GPU分配转码任务的能力，但经过一番调查后，发现可以通过-hwaccel_device参数指定转码任务使用的GPU！

> 向不同GPU提交转码任务

**显卡0**

```
ffmpeg -hwaccel cuvid -hwaccel_device 0 -c:v h264_cuvid -i <input> -c:v h264_nvenc -b:v 2048k -vf scale_npp=1280:-1 -y <output>
```

**显卡1**

```
ffmpeg -hwaccel cuvid -hwaccel_device 1 -c:v h264_cuvid -i <input> -c:v h264_nvenc -b:v 2048k -vf scale_npp=1280:-1 -y <output>
```

> hw accel_device N：指定某颗GPU执行转码任务，N为数字

Linux下稍微麻烦一点儿，具体可参考：https://www.jianshu.com/p/59da3d350488

### AMD GPU

AMD的GPU不需要额外下载东西，只要把ffmpeg编译好就能用。Windows版的ffmpeg官网提供了编译好的版本，因此Windows用户无需过多操心这个了，Linux如有需要，请参考：

https://stackoverflow.com/questions/56933969/how-to-run-ffmpeg-in-gpuamd

### 命令

将a.mp4转成b.mp4

```
ffmpeg -i .\a.mp4 -c:v h264_amf .\b.mp4
```

# ffprobe

获取视频总帧数

```shell
ffprobe -v error -count_frames -select_streams v:0 -show_entries stream=nb_read_frames -of default=nokey=1:noprint_wrappers=1 input.mp4
```

>输出6000。 在本例中，6000的输出是指读取帧的数量。因为整个文件必须解码，命令可能需要一段时间才能完成，具体取决于具体的输入文件大小。

选项的含义

- -v error：这隐藏了“info”输出(版本信息等)，使解析更容易。
- -count_frames：计算每个流的帧数，并在相应的流部分中报告。
- -select_streams v:0 ：仅选择视频流。
- -show_entries stream = nb_read_frames ：只显示读取的帧数。
- -of default = nokey = 1：noprint_wrappers = 1 ：将输出格式(也称为“writer”)设置为默认值，不打印每个字段的键(nokey = 1)，不打印节头和页脚(noprint_wrappers = 1)。





# 推荐

ot玩转直播流：使用SRS搭建推流服务器；使用SRS+ffmpeg中转推流；OBS推流到自建服务器；使用ffmpeg把直播流复制到多个网站: https://hu60.cn/q.php/bbs.topic.102309.html
官方文档： http://ffmpeg.org/ffmpeg.html
入门教程：https://ruanyifeng.com/blog/2020/01/ffmpeg.html
FFMPEG最全教程： https://cloud.tencent.com/developer/article/1773248