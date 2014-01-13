package HTML::WikiConverter::TracWiki;

use 5.008;
use strict;
use warnings FATAL => 'all';
use base 'HTML::WikiConverter';

=head1 NAME

HTML::WikiConverter::TracWiki - Convert HTML to TracWiki markup

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use HTML::WikiConverter;
    my $wc = new HTML::WikiConverter(dialect => 'TracWiki');
    print $wc->html2wiki($html);

=head1 DESCRIPTION

This module contains rules for converting HTML into TracWiki
markup. See L<HTML::WikiConverter> for additional usage details.

=head1 AUTHOR

MASUDA Takashi, C<< <t-masuda at mvd.biglobe.ne.jp> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTML::WikiConverter::TracWiki

=head1 LICENSE AND COPYRIGHT

Copyright 2014 MASUDA Takashi.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

sub rules {
    my $self = shift;
    my $rules = {
        a => { replace => \&_link },
        b => { alias => 'strong' },
        blockquote => {
            line_prefix => ">", 
            block => 1, trim => 'both', line_format => 'blocks' },
        br => { replace => "[[BR]]" },
        del => { start => "~~", end => "~~" },
        em => { start => "''", end => "''" },
        h1 => { start => "= ", end => " =",
            block => 1, trim => 'both', line_format => 'single' },
        h2 => { start => "== ", end => " ==",
            block => 1, trim => 'both', line_format => 'single' },
        h3 => { start => "=== ", end => " ===",
            block => 1, trim => 'both', line_format => 'single' },
        h4 => { start => "==== ", end => " ====",
            block => 1, trim => 'both', line_format => 'single' },
        h5 => { start => "===== ", end => " =====",
            block => 1, trim => 'both', line_format => 'single' },
        h6 => { start => "====== ", end => " ======",
            block => 1, trim => 'both', line_format => 'single' },
        i => { alias => 'em' },
        li => { start => \&_li_start, trim => 'leading' },
        p => { end => "\n\n", trim => 'both' },
        pre => { start => "{{{", end => "}}}" },
        strong => { start => "'''", end => "'''" },
        sub => { start => ",,", end => ",," },
        sup => { start => "^", end => "^" },
        td => { replace => \&_td },
        th => { replace => \&_th },
        tr => { end => "||\n" },
        ul => { line_format => 'multi', block => 1 },
    };
    
    return $rules;
}

sub postprocess_output {
    my ($self, $outref) = @_;

}

sub _li_start {
    my($self, $node, $rules) = @_;
    my @parent_lists = $node->look_up(_tag => qr/ul|ol/);

    my $prefix = '';
    foreach my $parent (@parent_lists) {
        my $bullet = '';
        $bullet = '*' if $parent->tag eq 'ul';
        $bullet = '1.' if $parent->tag eq 'ol';
        if ($prefix eq '') {
            $prefix = $bullet . $prefix;
        } else {
            $prefix = '  ' . $prefix;
        }
    }

    return "\n$prefix ";
}

sub _link {
    my($self, $node, $rules) = @_;
    my $url = $node->attr('href') || '';
    my $caption = $self->get_elem_contents($node) || '';
    return $caption if $url eq '';
    return sprintf '[%s %s]', $url, $caption;
}

sub _td {
    my($self, $node, $rules) = @_;
    my $data = $self->get_elem_contents($node) || '';
    return sprintf '||%s', $data;
}

sub _th {
    my($self, $node, $rules) = @_;
    my $data = $self->get_elem_contents($node) || '';
    return sprintf '||=%s', $data;
}


1; # End of HTML::WikiConverter::TracWiki
