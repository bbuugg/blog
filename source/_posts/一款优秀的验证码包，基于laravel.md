---
title: 一款优秀的验证码包，基于laravel
date: 2021-08-08 20:20:27
tags:
---

[![Build Status](https://camo.githubusercontent.com/395cf595b422485eaaaf4af93448e94db6ab39c159bbe040f96f19affc41c19e/68747470733a2f2f7472617669732d63692e6f72672f6d6577656273747564696f2f636170746368612e7376673f6272616e63683d6d6173746572)](https://travis-ci.org/mewebstudio/captcha) [![Scrutinizer Code Quality](https://camo.githubusercontent.com/35a43570fdb405e443b752285f41fdc6301de269bcd6160e5a79fab8a624182c/68747470733a2f2f7363727574696e697a65722d63692e636f6d2f672f6d6577656273747564696f2f636170746368612f6261646765732f7175616c6974792d73636f72652e706e673f623d6d6173746572)](https://scrutinizer-ci.com/g/mewebstudio/captcha/?branch=master) [![Latest Stable Version](https://camo.githubusercontent.com/05a5411699cfafef1c83e3920fda31e5ff835b86a00c5ff0cb1180d02fee691f/68747470733a2f2f706f7365722e707567782e6f72672f6d6577732f636170746368612f762f737461626c652e737667)](https://packagist.org/packages/mews/captcha) [![Latest Unstable Version](https://camo.githubusercontent.com/8e6a81d170dce05c6a99d0eac9902bdec469568c592adbeb5fc405068c57c7e6/68747470733a2f2f706f7365722e707567782e6f72672f6d6577732f636170746368612f762f756e737461626c652e737667)](https://packagist.org/packages/mews/captcha) [![License](https://camo.githubusercontent.com/ebe2dc7c9f30e3495d0e13731c5f24c6942076749e4e52911638ad816bdae5ae/68747470733a2f2f706f7365722e707567782e6f72672f6d6577732f636170746368612f6c6963656e73652e737667)](https://packagist.org/packages/mews/captcha) [![Total Downloads](https://camo.githubusercontent.com/45b6291a5f81f60a8d2f4e6344903c5ae67f128ce76810f4ce14bf5ce46d07ab/68747470733a2f2f706f7365722e707567782e6f72672f6d6577732f636170746368612f646f776e6c6f6164732e737667)](https://packagist.org/packages/mews/captcha)

A simple [Laravel 5/6](http://www.laravel.com/) service provider for including the [Captcha for Laravel](https://github.com/mewebstudio/captcha).

for Laravel 4 [Captcha for Laravel Laravel 4](https://github.com/mewebstudio/captcha/tree/master-l4)

## Preview

[![Preview](https://camo.githubusercontent.com/d323d054f44c6f7368792d153fce739b1651f61dcfcecb4e43e1f965ccbac276/68747470733a2f2f696d6167652e6962622e636f2f6b5a784d4c6d2f696d6167652e706e67)](https://camo.githubusercontent.com/d323d054f44c6f7368792d153fce739b1651f61dcfcecb4e43e1f965ccbac276/68747470733a2f2f696d6167652e6962622e636f2f6b5a784d4c6d2f696d6167652e706e67)

- Captcha for Laravel 5/6/7
  - [Preview](https://packagist.org/packages/mews/captcha#user-content-preview)
  - [Installation](https://packagist.org/packages/mews/captcha#user-content-installation)
  - [Usage](https://packagist.org/packages/mews/captcha#user-content-usage)
  - [Configuration](https://packagist.org/packages/mews/captcha#user-content-configuration)
  - Example Usage
    - [Session Mode:](https://packagist.org/packages/mews/captcha#user-content-session-mode-)
    - [Stateless Mode:](https://packagist.org/packages/mews/captcha#user-content-stateless-mode-)
- [Return Image](https://packagist.org/packages/mews/captcha#user-content-return-image)
- [Return URL](https://packagist.org/packages/mews/captcha#user-content-return-url)
- [Return HTML](https://packagist.org/packages/mews/captcha#user-content-return-html)
- To use different configurations
  - [Links](https://packagist.org/packages/mews/captcha#user-content-links)

## Installation

The Captcha Service Provider can be installed via [Composer](http://getcomposer.org/) by requiring the `mews/captcha` package and setting the `minimum-stability` to `dev` (required for Laravel 5) in your project's `composer.json`.

```
{
    &quot;require&quot;: {
        &quot;laravel/framework&quot;: &quot;5.0.*&quot;,
        &quot;mews/captcha&quot;: &quot;~2.0&quot;
    },
    &quot;minimum-stability&quot;: &quot;dev&quot;
}
```

or

Require this package with composer:

```
composer require mews/captcha
```

Update your packages with `composer update` or install with `composer install`.

In Windows, you'll need to include the GD2 DLL `php_gd2.dll` in php.ini. And you also need include `php_fileinfo.dll` and `php_mbstring.dll` to fit the requirements of `mews/captcha`'s dependencies.

## Usage

To use the Captcha Service Provider, you must register the provider when bootstrapping your Laravel application. There are essentially two ways to do this.

Find the `providers` key in `config/app.php` and register the Captcha Service Provider.

```
    'providers' =&gt; [
        // ...
        'Mews\Captcha\CaptchaServiceProvider',
    ]
```

for Laravel 5.1+

```
    'providers' =&gt; [
        // ...
        Mews\Captcha\CaptchaServiceProvider::class,
    ]
```

Find the `aliases` key in `config/app.php`.

```
    'aliases' =&gt; [
        // ...
        'Captcha' =&gt; 'Mews\Captcha\Facades\Captcha',
    ]
```

for Laravel 5.1+

```
    'aliases' =&gt; [
        // ...
        'Captcha' =&gt; Mews\Captcha\Facades\Captcha::class,
    ]
```

## Configuration

To use your own settings, publish config.

```
$ php artisan vendor:publish
config/captcha.php
return [
    'default'   =&gt; [
        'length'    =&gt; 5,
        'width'     =&gt; 120,
        'height'    =&gt; 36,
        'quality'   =&gt; 90,
        'math'      =&gt; true,  //Enable Math Captcha
        'expire'    =&gt; 60,    //Stateless/API captcha expiration
    ],
    // ...
];
```

## Example Usage

### Session Mode:

```
    // [your site path]/Http/routes.php
    Route::any('captcha-test', function() {
        if (request()-&gt;getMethod() == 'POST') {
            $rules = ['captcha' =&gt; 'required|captcha'];
            $validator = validator()-&gt;make(request()-&gt;all(), $rules);
            if ($validator-&gt;fails()) {
                echo '&lt;p style=&quot;color: #ff0000;&quot;&gt;Incorrect!&lt;/p&gt;';
            } else {
                echo '&lt;p style=&quot;color: #00ff30;&quot;&gt;Matched :)&lt;/p&gt;';
            }
        }
    
        $form = '&lt;form method=&quot;post&quot; action=&quot;captcha-test&quot;&gt;';
        $form .= '&lt;input type=&quot;hidden&quot; name=&quot;_token&quot; value=&quot;' . csrf_token() . '&quot;&gt;';
        $form .= '&lt;p&gt;' . captcha_img() . '&lt;/p&gt;';
        $form .= '&lt;p&gt;&lt;input type=&quot;text&quot; name=&quot;captcha&quot;&gt;&lt;/p&gt;';
        $form .= '&lt;p&gt;&lt;button type=&quot;submit&quot; name=&quot;check&quot;&gt;Check&lt;/button&gt;&lt;/p&gt;';
        $form .= '&lt;/form&gt;';
        return $form;
    });
```

### Stateless Mode:

You get key and img from this url `http://localhost/captcha/api/math` and verify the captcha using this method:

```
    //key is the one that you got from json response
    // fix validator
    // $rules = ['captcha' =&gt; 'required|captcha_api:'. request('key')];
    $rules = ['captcha' =&gt; 'required|captcha_api:'. request('key') . ',math'];
    $validator = validator()-&gt;make(request()-&gt;all(), $rules);
    if ($validator-&gt;fails()) {
        return response()-&gt;json([
            'message' =&gt; 'invalid captcha',
        ]);

    } else {
        //do the job
    }
```

# Return Image

```
captcha();
```

or

```
Captcha::create();
```

# Return URL

```
captcha_src();
```

or

```
Captcha::src('default');
```

# Return HTML

```
captcha_img();
```

or

```
Captcha::img();
```

# To use different configurations

```
captcha_img('flat');

Captcha::img('inverse');
```

etc.

Based on [Intervention Image](https://github.com/Intervention/image)

^_^

## Links

- [Intervention Image](https://github.com/Intervention/image)
- [L5 Captcha on Github](https://github.com/mewebstudio/captcha)
- [L5 Captcha on Packagist](https://packagist.org/packages/mews/captcha)
- [For L4 on Github](https://github.com/mewebstudio/captcha/tree/master-l4)
- [License](http://www.opensource.org/licenses/mit-license.php)
- [Laravel website](http://laravel.com/)
- [Laravel Turkiye website](http://www.laravel.gen.tr/)
- [MeWebStudio website](http://www.mewebstudio.com/)

&gt; https://packagist.org/packages/mews/captcha