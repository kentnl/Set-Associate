use v5.16;
use warnings;

package Set::Associate::RefillItems {

    sub linear {
        return sub {
            my ( $self, ) = @_;
            return  @{ $self->items };
        };
    }

    sub shuffle {
        return sub {
            my ( $self, ) = @_;
            require List::Util;
            return List::Util::shuffle @{ $self->items };
        };
    }
}

1;
BEGIN {
  $Set::Associate::RefillItems::AUTHORITY = 'cpan:KENTNL';
}
{
  $Set::Associate::RefillItems::VERSION = '0.1.0';
}

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::RefillItems

=head1 VERSION

version 0.1.0

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
