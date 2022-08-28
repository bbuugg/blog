---
title: PHP检索类
date: 2021-01-23 21:51:41
tags:
---

```php
&lt;?php
class Spider
{
    protected string $url = '';
    protected array $keywords = [];
    protected string $rule = '';
    protected array $include = [];
    protected array $except = [];
    protected string $return;
    protected $ch;
    protected int $timeout = 200000;
    protected int $total = 0;

    public function __construct(string $url, int $timeout = 200000)
    {
        $this-&gt;url = $url;
        $this-&gt;timeout = $timeout;
        $this-&gt;ch = curl_init();
        $options = [
            CURLOPT_SSL_VERIFYHOST =&gt; false,
            CURLOPT_SSL_VERIFYPEER =&gt; false,
            CURLOPT_RETURNTRANSFER =&gt; true,
            CURLOPT_FOLLOWLOCATION =&gt; true,
            CURLOPT_USERAGENT =&gt; 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50'
        ];
        curl_setopt_array($this-&gt;ch, $options);
    }
    protected function _check(string $url, string $keyword)
    {
        $key = str_replace('{k}', trim($keyword), $this-&gt;rule);
        $pattern = '#' . $key . '#iU';
        if (preg_match($pattern, $this-&gt;return, $matches)) {
            $res = &quot;'{$url}',中包含关键字{$key}&quot;;
            $this-&gt;include[] = $url;
        } else {
            $res = &quot;\033[31m'{$url}',中不包含关键字{$key}\033[0m&quot;;
            $this-&gt;except[] = $url;
        }
        echo $res . &quot;\n&quot;;
    }
    public function rule(string $rule): Spider
    {
        $this-&gt;rule = $rule;
        return $this;
    }
    public function run(\Closure $closure): array
    {
        while (!empty($this-&gt;keywords)) {
            $keyword = array_shift($this-&gt;keywords);
            usleep($this-&gt;timeout);
            $url = str_replace('{k}', trim($keyword), $this-&gt;url);
            curl_setopt($this-&gt;ch, CURLOPT_URL, $url);
            $this-&gt;return = mb_convert_encoding(curl_exec($this-&gt;ch),'UTF-8',['gbk','UTF-8']);
            $this-&gt;_check($url, $keyword);
            $closure($this-&gt;return, $url, $keyword);
            $this-&gt;_showProcess();
        }
        return ['include' =&gt; $this-&gt;include, 'except' =&gt; $this-&gt;except];
    }
    public function __destruct()
    {
        curl_close($this-&gt;ch);
    }
    protected function _showProcess()
    {
        $process = array_fill(0, 25, '-');
        $percentage = round((($this-&gt;total - count($this-&gt;keywords)) / $this-&gt;total) * 100, 2);
        $length = ceil($percentage / 4);
        array_splice($process, 0, $length, array_fill(0, $length, '&gt;'));
        echo implode('', $process), ' ', $percentage, &quot;%\r&quot;;
    }
    public function keywords(array $keywords): Spider
    {
        is_string($keywords) &amp;&amp; ($keywords = explode(',', $keywords));
        $this-&gt;keywords = $keywords;
        $this-&gt;total = count($keywords);
        return $this;
    }

}
$url = 'http://bbs.chinaunix.net/search.php?mod=forum&amp;searchid=745&amp;orderby=lastpost&amp;ascdesc=desc&amp;searchsubmit=yes&amp;kw={k}';
$keys = file('keys.txt');
// 没有匹配到{k}
$rule = &quot;没有找到匹配结果&quot;;
$s = new Spider($url, 300);
$res = $s-&gt;rule($rule)
    -&gt;keywords($keys)
    -&gt;run(function ($return, $url, $keyword) {
        // $data = &quot;\n地址：&quot; . $url . &quot;\n关键字：&quot; . $keyword . &quot;返回值：&quot; . $return;
        // file_put_contents('./res.txt', $data, FILE_APPEND);
        // echo $data;
    });
echo &quot;\n\n\n\n---------------------------------------------------------------\n包含\n&quot;;
foreach ($res['include'] as $d) {
    echo $d, &quot;\n&quot;;
}
echo &quot;---------------------------------------------------------------\n排除\n&quot;;
foreach ($res['except'] as $d) {
    echo $d, &quot;\n&quot;;
}
```