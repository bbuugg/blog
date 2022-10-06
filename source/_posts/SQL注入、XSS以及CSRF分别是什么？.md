---
title: SQL注入、XSS以及CSRF分别是什么？
date: 2021-04-03 21:25:35
tags:
---

#SQL注入

SQL注入是属于注入式攻击，这种攻击是因为在项目中没有将代码与数据（比如用户敏感数据）隔离，在读取数据的时候，错误的将数据作为代码的一部分执行而导致的。

<!-- more -->

典型的例子就是当对SQL语句进行字符串拼接的时候，直接使用未转义的用户输入内容作为变量。这时，只要在sql语句的中间做修改，比如加上drop、delete等关键字，执行之后后果不堪设想。

说到这里，那么该怎么处理这种情况呢？三个方面：

1、过滤用户输入参数中的特殊字符，降低风险。

2、禁止通过字符串拼接sql语句，要严格使用参数绑定来传入参数。

3、合理使用数据库框架提供的机制。就比如Mybatis提供的传入参数的方式 #{}，禁止使用${}，后者相当于是字符串拼接sql，要使用参数化的语句。

总结下，就是要正确使用参数化绑定sql变量。

#XSS

XSS：跨站脚本攻击，Cross-Site Scripting，为了和前端的css避免重名，简称为XSS，是指通过技术手段，向正常用户请求的HTML页面中插入恶意脚本，执行。

这种攻击主要是用于信息窃取和破坏等目的。比如2011年的微博XSS攻击事件，攻击者利用了微博发布功能中未对action-data漏洞做有效的过滤，在发布微博信息的时候带上了包含攻击脚本的URL，用户访问就会加载恶意脚本，导致大量用户被攻击。

关于防范XSS上，主要就是通过对用户输入的数据做过滤或者是转义，可以使用框架提供的工具类HtmlUtil。另外前端在浏览器展示数据的时候，要使用安全的API展示数据。比如使用innerText而不是innerHTML。

#CSRF

跨站请求伪造，在用户并不知情的情况下，冒充用户发送请求，在当前已经登录的web网站上执行恶意操作，比如恶意发帖，修改密码等。

大致来看，与XSS有重合的地方，前者是黑客盗用用户浏览器中的登录信息，冒充用户去执行操作。后者是在正常用户请求的HTML中放入恶意代码，XSS问题出在用户数据没有转义，过滤；CSRF问题出现在HTTP接口没有防范不守信用的调用。

#防范CSRF的漏洞方式

1、CSRF Token验证，利用浏览器的同源限制，在HTTP接口执行前验证Cookie中的Token，验证通过才会继续执行请求。

2、人机交互，例如短信验证码、界面的滑块。

以上就是什么是SQL注入、XSS和CSRF？的详细内容，更多请关注php中文网其它相关文章！



#PHP如何防止XSS攻击

PHP防止XSS跨站脚本攻击的方法:**是针对非法的HTML代码包括单双引号等，使用htmlspecialchars()函数** 。

在使用htmlspecialchars()函数的时候注意第二个参数, 直接用htmlspecialchars($string) 的话,第二个参数默认是ENT_COMPAT,函数默认只是转化双引号(“), 不对单引号(‘)做转义.

所以,htmlspecialchars函数更多的时候要加上第二个参数, 应该这样用: htmlspecialchars($string,ENT_QUOTES).当然,如果需要不转化任何引号,用htmlspecialchars($string,ENT_NOQUOTES).

另外, 尽量少用htmlentities, 在全部英文的时候htmlentities和htmlspecialchars没有区别,都可以达到目的.但是,中文情况下, htmlentities却会转化所有的html代码，连同里面的它无法识别的中文字符也给转化了。

htmlentities和htmlspecialchars这两个函数对 '之类的字符串支持不好,都不能转化, 所以用htmlentities和htmlspecialchars转化的字符串只能防止XSS攻击,不能防止SQL注入攻击.

所有有打印的语句如echo，print等 在打印前都要使用htmlentities() 进行过滤，这样可以防止Xss，注意中文要写出htmlentities($name,ENT_NOQUOTES,GB2312) 。

 (1).网页不停地刷新 `<meta http-equiv="refresh" content="0">`

 (2).嵌入其它网站的链接 <iframe src=http://xxxx width=250 height=250></iframe>  除了通过正常途径输入XSS攻击字符外，还可以绕过JavaScript校验，通过修改请求达到XSS攻击的目的.

```
<?php
//php防注入和XSS攻击通用过滤
$_GET     && SafeFilter($_GET);
$_POST    && SafeFilter($_POST);
$_COOKIE  && SafeFilter($_COOKIE);
  
function SafeFilter (&$arr) 
{
   $ra=Array('/([\x00-\x08,\x0b-\x0c,\x0e-\x19])/','/script/','/javascript/','/vbscript/','/expression/','/applet/'
   ,'/meta/','/xml/','/blink/','/link/','/style/','/embed/','/object/','/frame/','/layer/','/title/','/bgsound/'
   ,'/base/','/onload/','/onunload/','/onchange/','/onsubmit/','/onreset/','/onselect/','/onblur/','/onfocus/',
   '/onabort/','/onkeydown/','/onkeypress/','/onkeyup/','/onclick/','/ondblclick/','/onmousedown/','/onmousemove/'
   ,'/onmouseout/','/onmouseover/','/onmouseup/','/onunload/');
     
   if (is_array($arr))
   {
     foreach ($arr as $key => $value) 
     {
        if (!is_array($value))
        {
          if (!get_magic_quotes_gpc())  //不对magic_quotes_gpc转义过的字符使用addslashes(),避免双重转义。
          {
             $value  = addslashes($value); //给单引号（'）、双引号（"）、反斜线（\）与 NUL（NULL 字符）
             #加上反斜线转义
          }
          $value       = preg_replace($ra,'',$value);     //删除非打印字符，粗暴式过滤xss可疑字符串
          $arr[$key]     = htmlentities(strip_tags($value)); //去除 HTML 和 PHP 标记并转换为 HTML 实体
        }
        else
        {
          SafeFilter($arr[$key]);
        }
     }
   }
}
?>
$str = 'www.90boke.com<meta http-equiv="refresh" content="0;">';
SafeFilter ($str); //如果你把这个注释掉，提交之后就会无休止刷新
echo $str;
```

```
//------------------------------php防注入和XSS攻击通用过滤-----Start--------------------------------------------//
function string_remove_xss($html) {
    preg_match_all("/\<([^\<]+)\>/is", $html, $ms);
 
    $searchs[] = '<';
    $replaces[] = '<';
    $searchs[] = '>';
    $replaces[] = '>';
 
    if ($ms[1]) {
        $allowtags = 'img|a|font|div|table|tbody|caption|tr|td|th|br|p|b|strong|i|u|em|span|ol|ul|li|blockquote';
        $ms[1] = array_unique($ms[1]);
        foreach ($ms[1] as $value) {
            $searchs[] = "<".$value.">";
 
            $value = str_replace('&', '_uch_tmp_str_', $value);
            $value = string_htmlspecialchars($value);
            $value = str_replace('_uch_tmp_str_', '&', $value);
 
            $value = str_replace(array('\\', '/*'), array('.', '/.'), $value);
            $skipkeys = array('onabort','onactivate','onafterprint','onafterupdate','onbeforeactivate','onbeforecopy','onbeforecut','onbeforedeactivate',
                    'onbeforeeditfocus','onbeforepaste','onbeforeprint','onbeforeunload','onbeforeupdate','onblur','onbounce','oncellchange','onchange',
                    'onclick','oncontextmenu','oncontrolselect','oncopy','oncut','ondataavailable','ondatasetchanged','ondatasetcomplete','ondblclick',
                    'ondeactivate','ondrag','ondragend','ondragenter','ondragleave','ondragover','ondragstart','ondrop','onerror','onerrorupdate',
                    'onfilterchange','onfinish','onfocus','onfocusin','onfocusout','onhelp','onkeydown','onkeypress','onkeyup','onlayoutcomplete',
                    'onload','onlosecapture','onmousedown','onmouseenter','onmouseleave','onmousemove','onmouseout','onmouseover','onmouseup','onmousewheel',
                    'onmove','onmoveend','onmovestart','onpaste','onpropertychange','onreadystatechange','onreset','onresize','onresizeend','onresizestart',
                    'onrowenter','onrowexit','onrowsdelete','onrowsinserted','onscroll','onselect','onselectionchange','onselectstart','onstart','onstop',
                    'onsubmit','onunload','javascript','script','eval','behaviour','expression','style','class');
            $skipstr = implode('|', $skipkeys);
            $value = preg_replace(array("/($skipstr)/i"), '.', $value);
            if (!preg_match("/^[\/|\s]?($allowtags)(\s+|$)/is", $value)) {
                $value = '';
            }
            $replaces[] = empty($value) ? '' : "<" . str_replace('"', '"', $value) . ">";
        }
    }
    $html = str_replace($searchs, $replaces, $html);
 
    return $html;
}
//php防注入和XSS攻击通用过滤 
function string_htmlspecialchars($string, $flags = null) {
    if (is_array($string)) {
        foreach ($string as $key => $val) {
            $string[$key] = string_htmlspecialchars($val, $flags);
        }
    } else {
        if ($flags === null) {
            $string = str_replace(array('&', '"', '<', '>'), array('&', '"', '<', '>'), $string);
            if (strpos($string, '&#') !== false) {
                $string = preg_replace('/&((#(\d{3,5}|x[a-fA-F0-9]{4}));)/', '&\\1', $string);
            }
        } else {
            if (PHP_VERSION < '5.4.0') {
                $string = htmlspecialchars($string, $flags);
            } else {
                if (!defined('CHARSET') || (strtolower(CHARSET) == 'utf-8')) {
                    $charset = 'UTF-8';
                } else {
                    $charset = 'ISO-8859-1';
                }
                $string = htmlspecialchars($string, $flags, $charset);
            }
        }
    }
 
    return $string;
}

//------------------php防注入和XSS攻击通用过滤-----End--------------------------------------------//
```

# PHP中的设置 

PHP5.2以上版本已支持HttpOnly参数的设置，同样也支持全局的HttpOnly的设置，在php.ini中

```
----------------------------------------------------- 
 session.cookie_httponly = 
-----------------------------------------------------
```

设置其值为1或者TRUE，来开启全局的Cookie的HttpOnly属性，当然也支持在代码中来开启： 

```
<?php ini_set("session.cookie_httponly", 1);   
// or session_set_cookie_params(0, NULL, NULL, NULL, TRUE);   
?>
```

Cookie操作函数setcookie函数和setrawcookie函数也专门添加了第7个参数来做为HttpOnly的选项，开启方法为： 

```php
<?php  
setcookie("abc", "test", NULL, NULL, NULL, NULL, TRUE);   
setrawcookie("abc", "test", NULL, NULL, NULL, NULL, TRUE);  
?>
```