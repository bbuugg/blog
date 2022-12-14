---
title: PostgreSQL Copy 命令
date: 2021-04-02 18:46:48
tags:
---

COPY --  在表和文件之间拷贝数据



Synopsis
COPY tablename [ ( column [, ...] ) ] FROM { 'filename' | STDIN } [ [ WITH ] [ BINARY ] [ OIDS ] [ DELIMITER [ AS ] 'delimiter' ] [ NULL [ AS ] 'null string' ] [ CSV [ QUOTE [ AS ] 'quote' ] [ ESCAPE [ AS ] 'escape' ] [ FORCE NOT NULL column [, ...] ] COPY tablename [ ( column [, ...] ) ] TO { 'filename' | STDOUT } [ [ WITH ] [ BINARY ] [ OIDS ] [ DELIMITER [ AS ] 'delimiter' ] [ NULL [ AS ] 'null string' ] [ CSV [ QUOTE [ AS ] 'quote' ] [ ESCAPE [ AS ] 'escape' ] [ FORCE QUOTEcolumn [, ...] ]

描述
COPY 在 PostgreSQL表和标准文件系统文件之间交换数据。 COPY TO 把一个表的所有内容都拷贝到一个文件， 而 COPY FROM 从一个文件里拷贝数据到一个表里（把数据附加到表中已经存在的内容里）。

如果声明了一个字段列表，COPY 将只在文件和表之间拷贝声明的字段的数据。 如果表中有任何不在字段列表里的字段，那么 COPY FROM 将为那些字段插入缺省值。

带文件名的 COPY 指示 PostgreSQL 服务器直接从文件中读写数据。 如果声明了文件名，那么该文件必须为服务器可见，而且文件名必须从服务器的角度声明。如果声明的是STDIN 或 STDOUT，数据通过连接在客户前端和服务器之间流动。


参数
tablename
现存表的名字（可以有模式修饰）。

column
可选的待拷贝字段列表。如果没有声明字段列表，那么将使用所有字段。

filename
输入或输出文件的绝对路径名。

STDIN
声明输入是来自客户端应用。

STDOUT
声明输入前往客户端应用。

BINARY
使用二进制格式存储和读取，而不是以文本的方式。 在二进制模式下，不能声明 DELIMITERS，NULL 或者 CSV选项。

OIDS
声明为每行拷贝内部对象标识（OID）。 （如果给那些没有 OID 的表声明了 OIDS 选项，则抛出一个错误。）

delimiter
用于在文件中每行中分隔各个字段的单个字符。 在文本模式下，缺省是水平制表符（tab），在 CSV 模式下是一个逗号。

null string
个代表 NULL 值的字串。在文本模式下缺省是 \N （反斜杠-N）， 在 CSV 模式下是一个没有引号的空值。 如果你不想区分空值和空字串，那么即使在文本模式下可能你也会用一个空字串。

注意: 在使用 COPY FROM 的时候，任何匹配这个字串的字串将被存储为 NULL 值， 所以你应该确保你用的字串和COPY TO相同。

CSV
打开逗号分隔变量（CSV）模式。

quote
声明 CSV 模式里的引号字符。缺省是双引号。

escape
声明在 CSV 模式下应该出现在数据里 QUOTE 字符值前面的字符。 缺省是 QUOTE 值（通常是双引号）。

FORCE QUOTE
在 CSV COPY TO 模式下，强制在每个声明的字段周围对所有非 NULL 值都使用引号包围。 NULL 从不会被引号包围。

FORCE NOT NULL
在 CSV COPY FROM 模式下，把声明的每个字段都当作它们有引号包围来处理， 因此就没有 NULL 值。对于在CSV 模式下的缺省空字串（''）， 这样导致一个缺失的数值当作一个零长字串输入。


注意
COPY 只能用于表，不能用于视图。

BINARY 关键字将强制使用二进制对象而不是文本存储/读取所有数据。 这样做在一定程度上比传统的拷贝命令快，但二进制拷贝文件在不同机器体系间的植性不是很好。

你对任何要COPY TO 出来的数据必须有选取数据的权限，对任何要 COPY FROM 入数据的表必须有插入权限。

COPY 命令里面的文件必须是由服务器直接读或写的文件，而不是由客户端应用读写。 因此，它们必须位于数据库服务器上或者可以为数据库服务器所访问，而不是由客户端做这些事情。 它们必须是PostgreSQL用户（服务器运行的用户 ID）可以访问到并且可读或者可写，而不是客户端。 COPY 到一个命名文件是只允许数据库超级用户进行的，因为它允许读写任意服务器有权限访问的文件。

不要混淆 COPY 和 psql 指令 \copy。 \copy 调用 COPY FROM STDIN 或者 COPY TO STDOUT， 然后把数据抓取/存储到一个 psql 客户端可以访问的文件中。 因此，使用 \copy 的时候，文件访问权限是由客户端而不是服务器端决定的。

我们建议在 COPY 里的文件名字总是使用绝对路径。 在 COPY TO 的时候是由服务器强制进行的， 但是对于COPY FROM，你的确有从一个声明为相对路径的文件里读取的选择。 该路径将解释为相对于服务器的工作目录（在数据目录里的什么地方），而不是客户端的工作目录。

COPY FROM 会激活所有触发器和检查约束。不过，不会激活规则。

COPY 输入和输出是被 DateStyle 影响的。 为了和其它 PostgreSQL 安装移植，（它们可能用的不是缺省DateStyle 设置）， 我们应该在使用 COPY 前把 DateStyle 设置为ISO。

COPY 在第一个错误处停下来。这些在 COPY TO中不应该导致问题， 但在 COPY FROM 时目的表会已经接收到早先的行， 这些行将不可见或不可访问，但是仍然会占据磁盘空间。 如果你碰巧是拷贝很大一块数据文件的话， 积累起来，这些东西可能会占据相当大的一部分磁盘空间。你可以调用 VACUUM 来恢复那些磁盘空间。


文件格式

文本格式
当不带 BINARY 或者 CSV 选项使用 COPY 时， 读写的文件是一个文本文件，每行代表表中一个行。 行中的列（字段）用分隔符分开。 字段值本身是由与每个字段类型相关的输出函数生成的字符串， 或者是输入函数可接受的字串。 数据中使用特定的空值字串表示那些为 NULL 的字段。 如果输入文件的任意行包含比预期多或者少的字段，那么 COPY FROM将抛出一个错误。 如果声明了 OIDS，那么 OID 将作为第一个字段读写， 放在所有用户字段前面。

数据的结束可以用一个只包含反斜杠和句点（\.）的行表示。 如果从文件中读取数据，那么数据结束的标记是不必要的， 因为文件结束起的作用就很好了；但是在 3.0 之前的客户端协议里，如果在客户端应用之间拷贝数据， 那么必须要有结束标记。

反斜杠字符（\）可以用在 COPY 里给那些会有歧义的字符进行逃逸（否则那些字符会被当做行或者字段分隔符处理）。 特别是下面的字符如果是字段值的一部分时，必须前缀一个反斜杠：反斜杠本身，换行符，回车，以及当前分隔符。

声明的空字串被 COPY TO 不加任何反斜杠发送；与之相对，COPY FROM 在删除反斜杠之前拿它的输入与空字串比较。因此，像 \N 这样的空字串不会和实际数据值 \N 之间混淆（因为后者会表现成 \\N）。

COPY FROM 识别下列特殊反斜杠序列：


序列
代表物

\b
反斜杠 (ASCII 8)

\f
进纸 (ASCII 12)

\n
换行符 (ASCII 10)

\r
回车 (ASCII 13)

\t
Tab (ASCII 9)

\v
垂直制表符 (ASCII 11)

\digits
反斜杠后面跟着一到三个八进制数，表示ASCII值为该数的字符

目前，COPY TO 将绝不会发出一个八进制反斜杠序列， 但是它的确使用了上面列出的其它字符用于控制字符。

绝对不要把反斜杠放在一个数据字符N或者句点（.）前面。 这样的组合将分别被误认为是空字串或者数据结束标记。 另外一个没有在上面的表中列出的反斜杠字符就是它自己。

我们强烈建议生成 COPY 数据的应用把换行符和回车分别转换成 \n 和 \r 序列。 目前我们可以用一个反斜杠和一个回车表示一个数据回车，以及用一个反斜杠和一个换行符表示一个数据换行符。 不过，这样的表示在将来的版本中缺省时可能不会被接受。 并且，如果在不同机器之间传递 COPY 文件，也是非常容易出错的 （比如在 Unix 和 Windows 之间）。

COPY TO 将再每行的结尾是用一个 Unix 风格的换行符("\n")， 或者是在 Microsoft Windows 上运行的服务器上用（"\r\n"）标记一行终止，但只是用于COPY到服务器文件里； 为了在不同平台之间一致，COPY TO STDOUT总是发送 "\n"，不管服务器平台是什么。 COPY FROM 可以处理那些以回车符，或者换行符，或者回车换行符作为行结束的数据。 为了减少在数据中出现的未逃逸的新行或者回车导致的错误，如果输入的行结尾不像上面这些符号， COPY FROM 会发出警告。


CSV 格式
这个格式用于输入和输出逗号分隔数值（CSV）文件格式， 许多其它程序都用这个文件格式，比如电子报表。这个模式下生成并识别逗号分隔的 CSV 逃逸机制， 而不是使用PostgreSQL 标准文本模式的逃逸。

每条记录的值都是用 DELIMITER 字符分隔的。 如果数值本身包含分隔字符，QUOTE 字符，NULL 字串， 一个回车，或者进行字符，那么整个数值用 QUOTE 字符前缀和后缀（包围）， 并且数值里任何 QUOTE 字符或者ESCAPE 字符都前导逃逸字符。 你也可以使用 FORCE QUOTE 在输出非 NULL 的指定字段值时强制引号包围。

CSV 格式没有标准的办法区分一个 NULL 值和一个空字串。 PostgreSQL 的 COPY 通过引号包围来处理这些。 一个当作 NULL 输出的 NULL 值是没有引号包围的， 而匹配 NULL字串的数据值是用引号包围的。 因此，使用缺省设置时，一个 NULL 是写做一个无引号包围的空字串， 而一个空字串写做双引号包围（""）。读取数值也遵循类似的规则。 你可以使用 FORCE NOT NULL 来避免为特定字段进行 NULL 比较。

注意: CSV 模式可以识别和生成带有引号包围的回车和进行（hang）的 CVS 文件。 因此这些文件并不像文本模式的文件那样严格地每个数据行一行。 不过，如果任何字段本身包含并不匹配 CVS 文件本身的换行符序列， 那么 PostgreSQL 会拒绝 COPY 输入。通常，输入包含行结束符的数据的时候，用文本或者二进制格式比 CSV 更安全。

注意: 许多程序生成奇怪的并且有时候不正确的 CVS 文件， 所以这个文件格式更像一种惯用格式，而不是一种标准。 因此你可能碰到一些不能使用这个机制输入的文件，而 COPY 也可能生成一些其它程序不能处理的文件。


二进制格式
在PostgreSQL 7.4 中的 COPY BINARY 的文件格式做了变化。新格式由一个文件头，零或多条元组， 以及文件尾组成。文件头和数据现在是网络字节序。


文件头
文件头由 15 个字节的固定域组成，后面跟着一个变长的头扩展区。 固定域是：

签名
11-字节的序列 "PGBCOPY\n\377\r\n\0" — 请注意字节零是签名是要求的一部分。 （使用这个签名是为了让我们能够很容易看出文件是否已经被一个非 8 位安全的转换器给糟蹋了。 这个签名会被行结尾转换过滤器，删除字节零，删除高位，或者奇偶的改变而改变。）

标志域
32 位整数掩码表示该文件格式的重要方面。 位是从 0（LSB）到 31 （MSB）编码的 — 请注意这个域是以网络字节序存储的（高位在前）， 后继的整数都是如此。位 16 - 31 是保留用做关键文件格式信息的； 如果读者发现一个不认识的位出现在这个范围内，那么它应该退出。 位 0-15 都保留为标志向后兼容的格式使用；读者可以忽略这个范围内的不认识的位。目前只定义了一个标志位，而其它的必须是零：

Bit 16
如果为 1，那么在数据中包括了 OID；如果为 0，则没有

头扩展范围长度
32 位整数，以字节计的头剩余长度，不包括自身。目前，它是零， 后面紧跟第一条元组。对该格式的更多的修改都将允许额外的数据出现在头中。 读者应该忽略任何它不知道该如何处理的头扩展数据。

头扩展数据是一个用来保留一个自定义的数据序列块用的。这个标志域无意告诉读者扩展区的内容是什么。头扩展的具体设计内容留给以后的版本用。

这样设计就允许向下兼容头附加（增加头扩展块，或者设置低位序标志位）以及非向下兼容修改（设置高位标志位以标识这样的修改， 并且根据需要向扩展区域增加支持数据）。


元组
每条元组都以一个 16 位整数计数开头，该计数是元组中字段的数目。 （目前，在一个表里的每条元组都有相同的计数，但可能不会永远这样。） 然后后面不断出现元组中的各个字段，字段先是一个 32 位的长度字，后面跟着那么长的字段数据。 （长度字并不包括自己，并且可以为零。）一个特例是：-1 表示一个 NULL 字段值。 在 NULL 情况下，后面不会跟着数值字节。

在数据域之间没有对奇填充或者任何其它额外的数据。

目前，一个 COPY BINARY 文件里的所有数据值都假设是二进制格式的（格式代码为一）。 预计将来的扩展可能增加一个头域，允许为每个字段声明格式代码。

为了判断实际元组数据的正确的二进制格式，你应该阅读 PostgreSQL 源代码， 特别是该字段数据类型的*send 和 *recv 函数（典型的函数可以在源代码的src/backend/utils/adt/ 目录找到）。

如果在文件中包括了 OID，那么该 OID 域立即跟在字段计数字后面。 它是一个普通的字段，只不过它没有包括在字段计数。但它包括长度字 --- 这样就允许我们不用花太多的劲就可以处理 4 字节和 8 字节的 OID，并且如果某个家伙允许 OID 是可选的话，那么还可以把 OID 显示成空。


文件尾
文件尾包括保存着 -1 的一个 16 位整数字。这样就很容易与一条元组的域计数字相区分。

如果一个域计数字既不是 -1 也不是预期的字段的数目，那么读者应该报错。 这样就提供了对丢失与数据的同步的额外的检查。


例子
下面的例子把一个表拷贝到客户端， 使用竖直条（|）作为域分隔符：

COPY country TO STDOUT WITH DELIMITER '|';
从一个 Unix 文件中拷贝数据到一个country表中：

COPY country FROM '/usr1/proj/bray/sql/country_data';
下面是一个可以从 STDIN 中拷贝数据到表中的例子：

AF AFGHANISTAN AL ALBANIA DZ ALGERIA ZM ZAMBIA ZW ZIMBABWE
请注意在这里每行里的空白实际上是一个水平制表符 tab。

下面的是同样的数据，在一台 Linux/i586 机器上以二进制形式输出。 这些数据是用 Unix 工具 od -c 过滤之后输出的。 该表有三个字段；第一个是 char(2)， 第二个是text， 第三个是integer。所有的行在第三个域都是一个 null 值。

0000000 P G C O P Y \n 377 \r \n \0 \0 \0 \0 \0 \0 0000020 \0 \0 \0 \0 003 \0 \0 \0 002 A F \0 \0 \0 013 A 0000040 F G H A N I S T A N 377 377 377 377 \0 003 0000060 \0 \0 \0 002 A L \0 \0 \0 007 A L B A N I 0000100 A 377 377 377 377 \0 003 \0 \0 \0 002 D Z \0 \0 \0 0000120 007 A L G E R I A 377 377 377 377 \0 003 \0 \0 0000140 \0 002 Z M \0 \0 \0 006 Z A M B I A 377 377 0000160 377 377 \0 003 \0 \0 \0 002 Z W \0 \0 \0 \b Z I 0000200 M B A B W E 377 377 377 377 377 377

兼容性
在 SQL 标准里没有 COPY 语句。

PostgreSQL 7.3 以前使用下面的语法，现在仍然支持：

COPY [ BINARY ] tablename [ WITH OIDS ] FROM { 'filename' | STDIN } [ [USING] DELIMITERS 'delimiter' ] [ WITH NULL AS 'null string' ] COPY [ BINARY ] tablename [ WITH OIDS ] TO { 'filename' | STDOUT } [ [USING] DELIMITERS 'delimiter' ] [ WITH NULL AS 'null string' ]
————————————————
版权声明：本文为CSDN博主「DemonHunter211」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/kwame211/article/details/75968013