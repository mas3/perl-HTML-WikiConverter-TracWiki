#!perl -T
use 5.008;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'HTML::WikiConverter::TracWiki' ) || print "Bail out!\n";
}

diag( "Testing HTML::WikiConverter::TracWiki $HTML::WikiConverter::TracWiki::VERSION, Perl $], $^X" );
