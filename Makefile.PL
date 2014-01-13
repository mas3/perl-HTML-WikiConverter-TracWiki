use 5.008;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'HTML::WikiConverter::TracWiki',
    AUTHOR           => q{MASUDA Takashi <t-masuda@mvd.biglobe.ne.jp>},
    VERSION_FROM     => 'lib/HTML/WikiConverter/TracWiki.pm',
    ABSTRACT_FROM    => 'lib/HTML/WikiConverter/TracWiki.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.008,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'HTML::WikiConverter' => 0.68,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'HTML-WikiConverter-TracWiki-*' },
);
