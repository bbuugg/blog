---
title: jquery获取所有选中的checkbox
date: 2020-10-09 20:06:17
tags:
---

获取所有name为spCodeId的checkbox

     var spCodesTemp = &quot;&quot;;
      $('input:checkbox[name=spCodeId]:checked').each(function(i){
       if(0==i){
        spCodesTemp = $(this).val();
       }else{
        spCodesTemp += (&quot;,&quot;+$(this).val());
       }
      });
      $(&quot;#txt_spCodes&quot;).val(spCodesTemp);
以类型查找

$(&quot;input[type='checkbox'][checked]&quot;)
以名称查找

$(&quot;input:checkbox[name='the checkbox name']:checked&quot;) 

//如果是在某一些标签下查找的话，为了防止查找到table #tbTemplate元素以外的checkbox：checked，我们可以这样来限制：

$(&quot;table#tbTemplate input:checkbox[name='the checkbox name']:checked&quot;)  
原生态的用法

 

$($(&quot;table#tbTemplate input[type='checkbox']&quot;),function(i,checkbox){

     if(checkbox.checked){

          // keep the state. or log this checked......

     }

});
判断多选框是否有选中

if (!$(&quot;input[type='checkbox']&quot;).is(':checked')) {
    $('#sitetable').hide();
}


    &lt;!doctype html&gt;
    &lt;html lang=&quot;en&quot;&gt;
    &lt;head&gt;
        &lt;meta charset=&quot;UTF-8&quot;&gt;
        &lt;meta name=&quot;viewport&quot;
              content=&quot;width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0&quot;&gt;
        &lt;meta http-equiv=&quot;X-UA-Compatible&quot; content=&quot;ie=edge&quot;&gt;
        &lt;title&gt;Document&lt;/title&gt;
    &lt;/head&gt;
    &lt;body&gt;
    &lt;input type=&quot;checkbox&quot; name=&quot;use&quot; data-id=&quot;1&quot;&gt;
    &lt;input type=&quot;checkbox&quot; name=&quot;usr&quot; data-id=&quot;3&quot;&gt;
    &lt;input type=&quot;checkbox&quot; name=&quot;use&quot; data-id=&quot;5&quot;&gt;
    &lt;input type=&quot;checkbox&quot; name=&quot;ser&quot; data-id=&quot;7&quot;&gt;
    &lt;input type=&quot;checkbox&quot; name=&quot;uer&quot; data-id=&quot;9&quot;&gt;
    &lt;input type=&quot;button&quot; value=&quot;选择&quot;&gt;
    &lt;script src=&quot;/static/admin/js/core/jquery.3.2.1.min.js&quot;&gt;&lt;/script&gt;
    &lt;script&gt;
        $(() =&gt; {
            $('input:button').click(() =&gt; {
                $('input:checkbox:checked').each((e,w) =&gt; {
                    console.log($(w).attr('data-id'))
                })
            })
        })
    &lt;/script&gt;
    
    &lt;/body&gt;
    &lt;/html&gt;