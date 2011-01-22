package Plack::Middleware::ChromeFrame;

use strict;
use warnings;
use parent qw(Plack::Middleware);

use Plack::Util;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

sub call {
    my ($self, $env) = @_;

    my $res = $self->app->($env);
    $self->response_cb($res, sub {
        my $res = shift;

        return unless ($env->{HTTP_USER_AGENT} || '') =~ /MSIE/;

        my $h = Plack::Util::headers($res->[1]);
        if ($env->{HTTP_USER_AGENT} =~ /chromeframe/) {
            $h->set('X-UA-Compatible' => 'chrome=1');
        }
        else {
            $h->set(Location => 'http://www.google.com/chromeframe');
            $res->[0] = 302;
        }
    });
}


1;

__END__

=head1 NAME

Plack::Middleware::ChromeFrame - injects Google Chrome Frame into IE

=head1 SYNOPSIS

    # in  app.psgi
    builder {
        enable 'ChromeFrame';
        $app;
    };

    # or in Plack::Handler::*
    $app = Plack::Middleware::ChromeFrame->wrap($app);

=head1 DESCRIPTION

The C<Plack::Middleware::ChromeFrame> module injects the Google Chrome Frame
into Internet Explorer.

=head1 SEE ALSO

L<Plack>

L<https://code.google.com/chrome/chromeframe/>

=head1 REQUESTS AND BUGS

Please report any bugs or feature requests to
L<http://rt.cpan.org/Public/Bug/Report.html?Queue=Plack-Middleware-ChromeFrame>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Plack::Middleware::ChromeFrame

You can also look for information at:

=over

=item * GitHub Source Repository

L<http://github.com/gray/plack-middleware-chromeframe>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Plack-Middleware-ChromeFrame>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Plack-Middleware-ChromeFrame>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/Public/Dist/Display.html?Name=Plack-Middleware-ChromeFrame>

=item * Search CPAN

L<http://search.cpan.org/dist/Plack-Middleware-ChromeFrame/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 gray <gray at cpan.org>, all rights reserved.

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 AUTHOR

gray, <gray at cpan.org>

=cut
