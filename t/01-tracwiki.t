#!perl -T

use strict;
use warnings;
use Test::More;
use HTML::WikiConverter;

my $dialect = 'TracWiki';

my $wc = new HTML::WikiConverter(dialect => $dialect);

can_ok($wc, 'html2wiki');

is($wc->html2wiki('<h1>text</h1>'), '= text =', 'h1');
is($wc->html2wiki('<h2>text</h2>'), '== text ==', 'h2');
is($wc->html2wiki('<h3>text</h3>'), '=== text ===', 'h3');
is($wc->html2wiki('<h4>text</h4>'), '==== text ====', 'h4');
is($wc->html2wiki('<h5>text</h5>'), '===== text =====', 'h5');
is($wc->html2wiki('<h6>text</h6>'), '====== text ======', 'h6');


is($wc->html2wiki("<strong>text</strong>"), "'''text'''", "strong");
is($wc->html2wiki("before <strong>text</strong>"), "before '''text'''", "strong");
is($wc->html2wiki("<strong>text</strong> after"), "'''text''' after", "strong");
is($wc->html2wiki(
    "before <strong>text</strong> after"), "before '''text''' after", "strong");

is($wc->html2wiki("<b>text</b>"), "'''text'''", "b");
is($wc->html2wiki("before <b>text</b>"), "before '''text'''", "b");
is($wc->html2wiki("<b>text</b> after"), "'''text''' after", "b");
is($wc->html2wiki(
    "before <b>text</b> after"), "before '''text''' after", "b");


is($wc->html2wiki("<em>text</em>"), "''text''", "em");
is($wc->html2wiki("before <em>text</em>"), "before ''text''", "em");
is($wc->html2wiki("<em>text</em> after"), "''text'' after", "em");
is($wc->html2wiki(
    "before <em>text</em> after"), "before ''text'' after", "em");


is($wc->html2wiki("<i>text</i>"), "''text''", "i");
is($wc->html2wiki("before <i>text</i>"), "before ''text''", "i");
is($wc->html2wiki("<i>text</i> after"), "''text'' after", "i");
is($wc->html2wiki(
    "before <i>text</i> after"), "before ''text'' after", "i");


is($wc->html2wiki('<div><del>text</del></div>'), '~~text~~', 'del');
is($wc->html2wiki(
    '<div>before <del>text</del></div>'), 'before ~~text~~', 'del');
is($wc->html2wiki(
    '<div><del>text</del> after</div>'), '~~text~~ after', 'del');
is($wc->html2wiki(
    '<div>before <del>text</del> after</div>'),
    'before ~~text~~ after', 'del');


is($wc->html2wiki('<div><sup>text</sup></div>'), '^text^', 'sup');
is($wc->html2wiki(
    '<div>before <sup>text</sup></div>'), 'before ^text^', 'sup');
is($wc->html2wiki(
    '<div><sup>text</sup> after</div>'), '^text^ after', 'sup');
is($wc->html2wiki(
    '<div>before <sup>text</sup> after</div>'),
    'before ^text^ after', 'sup');


is($wc->html2wiki('<div><sub>text</sub></div>'), ',,text,,', 'sub');
is($wc->html2wiki(
    '<div>before <sub>text</sub></div>'), 'before ,,text,,', 'sub');
is($wc->html2wiki(
    '<div><sub>text</sub> after</div>'), ',,text,, after', 'sub');
is($wc->html2wiki(
    '<div>before <sub>text</sub> after</div>'),
    'before ,,text,, after', 'sub');


is($wc->html2wiki('<blockquote>text</blockquote>'), '>text', 'blockqute');
is($wc->html2wiki('<blockquote><p>text</p></blockquote>'),
    '>text', 'blockqute');
is($wc->html2wiki("<blockquote><p>text<br />text2</p></blockquote>"),
    ">text[[BR]]text2", 'blockqute');
is($wc->html2wiki("<blockquote><p>text<br>text2</p></blockquote>"),
    ">text[[BR]]text2", 'blockqute');


is($wc->html2wiki(
    '<div><a href="http://www.example.com" target="_blank">example</a></div>'),
    '[http://www.example.com example]', 'a');


is($wc->html2wiki('<ul>
  <li>text1</li>
  <li>text2</li>
</ul>'), "* text1\n* text2", 'ul');
is($wc->html2wiki('<ul>
  <li>text1</li>
  <ul>
    <li>text2</li>
  </ul>
</ul>'), "* text1\n  * text2", 'ul');


is($wc->html2wiki('<ol>
  <li>text1</li>
  <li>text2</li>
</ol>'), "1. text1\n1. text2", 'ol');
is($wc->html2wiki('<ol>
  <li>text1</li>
  <ol>
    <li>text2</li>
  </ol>
</ol>'), "1. text1\n  1. text2", 'ol');


is($wc->html2wiki('<table>
<tr>
  <td>1-1</td>
  <td>1-2</td>
</tr>
<tr>
  <td>2-1</td>
  <td>2-2</td>
</tr>
</table>'), "||1-1||1-2||\n||2-1||2-2||", 'table');

is($wc->html2wiki('<table>
<tr>
  <th>1-1</th>
  <th>1-2</th>
</tr>
<tr>
  <td>2-1</td>
  <td>2-2</td>
</tr>
</table>'), "||=1-1||=1-2||\n||2-1||2-2||", 'table');


is($wc->html2wiki('<pre>
print &quot;Hello, world!\n&quot;
print &quot;hello, world\n&quot;
</pre>
'), "{{{\nprint \"Hello, world!\\n\"\nprint \"hello, world\\n\"\n}}}", 'pre');


is($wc->html2wiki("<p>text1</p>\n<p>text2</p>"), "text1\n\ntext2", 'p');


done_testing();

