---
title: PHP正则表达式中模式修正符 (Pattern Modifiers)
date: 2021-11-17 20:29:48
tags:
---

The current possible PCRE modifiers are listed below. The names in parentheses refer to internal PCRE names for these modifiers. Spaces and newlines are ignored in modifiers, other characters cause error.

<!-- more -->

##  i (PCRE_CASELESS)

  If this modifier is set, letters in the pattern match both upper and lower case letters.

## m (PCRE_MULTILINE)

  By default, PCRE treats the subject string as consisting of a single &quot;line&quot; of characters (even if it actually contains several newlines). The &quot;start of line&quot; metacharacter (^) matches only at the start of the string, while the &quot;end of line&quot; metacharacter ($) matches only at the end of the string, or before a terminating newline (unless *D* modifier is set). This is the same as Perl. When this modifier is set, the &quot;start of line&quot; and &quot;end of line&quot; constructs match immediately following or immediately before any newline in the subject string, respectively, as well as at the very start and end. This is equivalent to Perl&#039;s /m modifier. If there are no &quot;\n&quot; characters in a subject string, or no occurrences of ^ or $ in a pattern, setting this modifier has no effect.

##  s (PCRE_DOTALL)

  If this modifier is set, a dot metacharacter in the pattern matches all characters, including newlines. Without it, newlines are excluded. This modifier is equivalent to Perl&#039;s /s modifier. A negative class such as [^a] always matches a newline character, independent of the setting of this modifier.

##  x (PCRE_EXTENDED)

  If this modifier is set, whitespace data characters in the pattern are totally ignored except when escaped or inside a character class, and characters between an unescaped # outside a character class and the next newline character, inclusive, are also ignored. This is equivalent to Perl&#039;s /x modifier, and makes it possible to include commentary inside complicated patterns. Note, however, that this applies only to data characters. Whitespace characters may never appear within special character sequences in a pattern, for example within the sequence (?( which introduces a conditional subpattern.

##  A (PCRE_ANCHORED)

  If this modifier is set, the pattern is forced to be &quot;anchored&quot;, that is, it is constrained to match only at the start of the string which is being searched (the &quot;subject string&quot;). This effect can also be achieved by appropriate constructs in the pattern itself, which is the only way to do it in Perl.

##  D (PCRE_DOLLAR_ENDONLY)

  If this modifier is set, a dollar metacharacter in the pattern matches only at the end of the subject string. Without this modifier, a dollar also matches immediately before the final character if it is a newline (but not before any other newlines). This modifier is ignored if *m* modifier is set. There is no equivalent to this modifier in Perl.

##  S

  When a pattern is going to be used several times, it is worth spending more time analyzing it in order to speed up the time taken for matching. If this modifier is set, then this extra analysis is performed. At present, studying a pattern is useful only for non-anchored patterns that do not have a single fixed starting character.

##  U (PCRE_UNGREEDY)

  This modifier inverts the &quot;greediness&quot; of the quantifiers so that they are not greedy by default, but become greedy if followed by `?`. It is not compatible with Perl. It can also be set by a (`?U`) [modifier setting within the pattern](https://www.php.net/manual/en/regexp.reference.internal-options.php) or by a question mark behind a quantifier (e.g. `.*?`).**Note**:It is usually not possible to match more than [pcre.backtrack_limit](https://www.php.net/manual/en/pcre.configuration.php#ini.pcre.backtrack-limit) characters in ungreedy mode.

##  X (PCRE_EXTRA)

  This modifier turns on additional functionality of PCRE that is incompatible with Perl. Any backslash in a pattern that is followed by a letter that has no special meaning causes an error, thus reserving these combinations for future expansion. By default, as in Perl, a backslash followed by a letter with no special meaning is treated as a literal. There are at present no other features controlled by this modifier.

##  J (PCRE_INFO_JCHANGED)

  The (?J) internal option setting changes the local `PCRE_DUPNAMES` option. Allow duplicate names for subpatterns. As of PHP 7.2.0 `J` is supported as modifier as well.

##  u (PCRE_UTF8)

  This modifier turns on additional functionality of PCRE that is incompatible with Perl. Pattern and subject strings are treated as UTF-8. An invalid subject will cause the preg_* function to match nothing; an invalid pattern will trigger an error of level E_WARNING. Five and six octet UTF-8 sequences are regarded as invalid.
  
参考文档：https://www.php.net/manual/en/reference.pcre.pattern.modifiers.php