---
title: Guzzle上传文件
date: 2022-04-24 18:57:39
tags:
---

```
$client = new Client();
            $pa = $_SERVER['HTTP_ORIGIN'];
            $domain = parse_url($pa)['host'];
            $cookie_arr = [
                'PHPSEXXX' => '12345678',
            ];
            $cookieJar = CookieJar::fromArray($cookie_arr, $domain);
            $file_name = '';
            $file_name = '../xxx' . $la_code . '.pdf';
            $r = $client->request('POST', $pa . '/checkingxxxx/upfiles', [
                'cookies' => $cookieJar,
                'multipart' => [
                    [
                        'name' => 'file_name[]',
                        'contents' => fopen($file_name, 'r')
                    ],
                    [
                        'name' => 'id_link',
                        'contents' => $value
                    ],
                ]
            ]);
```