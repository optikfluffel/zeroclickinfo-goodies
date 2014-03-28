#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::Goodie::Calculator;    # For function subtests.

zci answer_type => 'calc';
zci is_cached   => 1;

subtest 'display format selection' => sub {
    my $ds_name = 'DDG::Goodie::Calculator::display_style';
    my $ds      = \&$ds_name;

    is($ds->('4,431',      '4.321')->{id}, 'perl', '4,321 and 4.321 is perl');
    is($ds->('4,431',      '4.32')->{id},  'perl', '4,321 and 4.32 is perl');
    is($ds->('4,431',      '4,32')->{id},  'euro', '4,321 and 4,32 is euro');
    is($ds->('4534,345.0', '1',)->{id},    'perl', '4534,345.0 should have another comma, not enforced; call it perl.');
    is($ds->('4,431', '4,32', '5,42')->{id}, 'euro', '4,321 and 4,32 and 5,42 is nicely euro-style');
    is($ds->('4,431', '4.32', '5.42')->{id}, 'perl', '4,321 and 4.32 and 5.42 is nicely perl-style');

    is($ds->('5234534.34.54', '1',), undef, '5234534.34.54 and 1 has a mal-formed number, so we cannot proceed');
    is($ds->('4,431', '4,32',     '4.32'), undef, '4,321 and 4,32 and 4.32 is confusingly ambig; no style');
    is($ds->('4,431', '4.32.10',  '5.42'), undef, '4,321 and 4.32.10 is hard to figure; no style');
    is($ds->('4,431', '4,32,100', '5.42'), undef, '4,321 and 4,32,100 and 5.42 has a mal-formed number, so no go.');
    is($ds->('4,431', '4,32,100', '5,42'), undef, '4,321 and 4,32,100 and 5,42 is too crazy to work out; no style');
};

ddg_goodie_test(
    [qw( DDG::Goodie::Calculator )],
    'what is 2-2' => test_zci(
        "2 - 2 = 0",
        heading => 'Calculator',
        html    => qq(<div>2 - 2 = <a href="javascript:;" onClick="document.x.q.value='0';document.x.q.focus();">0</a></div>)
    ),
    'solve 2+2' => test_zci(
        "2 + 2 = 4",
        heading => 'Calculator',
        html    => qq(<div>2 + 2 = <a href="javascript:;" onClick="document.x.q.value='4';document.x.q.focus();">4</a></div>)
    ),
    '2^8' => test_zci(
        "2 ^ 8 = 256",
        heading => 'Calculator',
        html    => qq(<div>2<sup>8</sup> = <a href="javascript:;" onClick="document.x.q.value='256';document.x.q.focus();">256</a></div>)
    ),
    '2 *7' => test_zci(
        "2 * 7 = 14",
        heading => 'Calculator',
        html    => qq(<div>2 * 7 = <a href="javascript:;" onClick="document.x.q.value='14';document.x.q.focus();">14</a></div>)
    ),
    '1 dozen * 2' => test_zci(
        "1 dozen * 2 = 24",
        heading => 'Calculator',
        html    => qq(<div>1 dozen * 2 = <a href="javascript:;" onClick="document.x.q.value='24';document.x.q.focus();">24</a></div>)
    ),
    'dozen + dozen' => test_zci(
        "dozen + dozen = 24",
        heading => 'Calculator',
        html    => qq(<div>dozen + dozen = <a href="javascript:;" onClick="document.x.q.value='24';document.x.q.focus();">24</a></div>)
    ),
    '2divided by 4' => test_zci(
        "2 divided by 4 = 0.5",
        heading => 'Calculator',
        html    => qq(<div>2 divided by 4 = <a href="javascript:;" onClick="document.x.q.value='0.5';document.x.q.focus();">0.5</a></div>)
    ),
    '(2c) + pi' => test_zci(
        "(2 speed of light) + pi = 599,584,919.141593",
        heading => 'Calculator',
        html =>
          qq(<div>(2 speed of light) + pi = <a href="javascript:;" onClick="document.x.q.value='599,584,919.141593';document.x.q.focus();">599,584,919.141593</a></div>)
    ),
    '2^dozen' => test_zci(
        "2 ^ dozen = 4,096",
        heading => 'Calculator',
        html    => qq(<div>2<sup>dozen</sup> = <a href="javascript:;" onClick="document.x.q.value='4,096';document.x.q.focus();">4,096</a></div>)
    ),
    '2^2' => test_zci(
        "2 ^ 2 = 4",
        heading => 'Calculator',
        html    => qq(<div>2<sup>2</sup> = <a href="javascript:;" onClick="document.x.q.value='4';document.x.q.focus();">4</a></div>)
    ),
    '2^0.2' => test_zci(
        "2 ^ 0.2 = 1.14869835499704",
        heading => 'Calculator',
        html =>
          qq(<div>2<sup>0.2</sup> = <a href="javascript:;" onClick="document.x.q.value='1.14869835499704';document.x.q.focus();">1.14869835499704</a></div>)
    ),
    'cos(0)' => test_zci(
        "cos(0) = 1",
        heading => 'Calculator',
        html    => qq(<div>cos(0) = <a href="javascript:;" onClick="document.x.q.value='1';document.x.q.focus();">1</a></div>)
    ),
    'tan(1)' => test_zci(
        "tan(1) = 1.5574077246549",
        heading => 'Calculator',
        html =>
          qq(<div>tan(1) = <a href="javascript:;" onClick="document.x.q.value='1.5574077246549';document.x.q.focus();">1.5574077246549</a></div>)
    ),
    'sin(1)' => test_zci(
        "sin(1) = 0.841470984807897",
        heading => 'Calculator',
        html =>
          qq(<div>sin(1) = <a href="javascript:;" onClick="document.x.q.value='0.841470984807897';document.x.q.focus();">0.841470984807897</a></div>)
    ),
    '$3.43+$34.45' => test_zci(
        '$3.43 + $34.45 = $37.88',
        heading => 'Calculator',
        html    => qq(<div>\$3.43 + \$34.45 = <a href="javascript:;" onClick="document.x.q.value='\$37.88';document.x.q.focus();">\$37.88</a></div>)
    ),
    '64*343' => test_zci(
        '64 * 343 = 21,952',
        heading => 'Calculator',
        html    => qq(<div>64 * 343 = <a href="javascript:;" onClick="document.x.q.value='21,952';document.x.q.focus();">21,952</a></div>),
    ),
    '1E2 + 1' => test_zci(
        '(1  *  10 ^ 2) + 1 = 101',
        heading => 'Calculator',
        html => qq(<div>(1  *  10<sup>2</sup>) + 1 = <a href="javascript:;" onClick="document.x.q.value='101';document.x.q.focus();">101</a></div>),
    ),
    '1 + 1E2' => test_zci(
        '1 + (1  *  10 ^ 2) = 101',
        heading => 'Calculator',
        html => qq(<div>1 + (1  *  10<sup>2</sup>) = <a href="javascript:;" onClick="document.x.q.value='101';document.x.q.focus();">101</a></div>),
    ),
    '2 * 3 + 1E2' => test_zci(
        '2 * 3 + (1  *  10 ^ 2) = 106',
        heading => 'Calculator',
        html =>
          qq(<div>2 * 3 + (1  *  10<sup>2</sup>) = <a href="javascript:;" onClick="document.x.q.value='106';document.x.q.focus();">106</a></div>),
    ),
    '1E2 + 2 * 3' => test_zci(
        '(1  *  10 ^ 2) + 2 * 3 = 106',
        heading => 'Calculator',
        html =>
          qq(<div>(1  *  10<sup>2</sup>) + 2 * 3 = <a href="javascript:;" onClick="document.x.q.value='106';document.x.q.focus();">106</a></div>),
    ),
    '1E2 / 2' => test_zci(
        '(1  *  10 ^ 2) / 2 = 50',
        heading => 'Calculator',
        html    => qq(<div>(1  *  10<sup>2</sup>) / 2 = <a href="javascript:;" onClick="document.x.q.value='50';document.x.q.focus();">50</a></div>),
    ),
    '2 / 1E2' => test_zci(
        '2 / (1  *  10 ^ 2) = 0.02',
        heading => 'Calculator',
        html => qq(<div>2 / (1  *  10<sup>2</sup>) = <a href="javascript:;" onClick="document.x.q.value='0.02';document.x.q.focus();">0.02</a></div>),
    ),
    '424334+2253828' => test_zci(
        '424334 + 2253828 = 2,678,162',
        heading => 'Calculator',
        html => qq(<div>424334 + 2253828 = <a href="javascript:;" onClick="document.x.q.value='2,678,162';document.x.q.focus();">2,678,162</a></div>),
    ),
    '4.243,34+22.538,28' => test_zci(
        '4.243,34 + 22.538,28 = 26.781,62',
        heading => 'Calculator',
        html =>
          qq(<div>4.243,34 + 22.538,28 = <a href="javascript:;" onClick="document.x.q.value='26.781,62';document.x.q.focus();">26.781,62</a></div>),
    ),
    '4,24,334+22,53,828' => undef,
    '5234534.34.54+1'    => undef,
    '//'                 => undef,
    dividedbydividedby   => undef,
);

done_testing;

