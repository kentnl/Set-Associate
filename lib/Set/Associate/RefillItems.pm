use v5.16;
use warnings;

package Set::Associate::RefillItems {

    # ABSTRACT: Pool repopulation methods
    use Moose;
    use MooseX::AttributeShortcuts;
    use MooseX::Types::Moose qw( CodeRef Str );

    has name => (
        isa      => Str,
        is       => rwp =>,
        required => 1,
    );
    has code => (
        isa      => CodeRef,
        is       => rwp =>,
        required => 1,
        traits   => [qw( Code )],
        handles  => {
            run => execute =>,
        },
    );

    no Moose;
    __PACKAGE__->meta->make_immutable;


    sub linear {
        return __PACKAGE__->new(
            name => 'linear',
            code => sub {
                my ( $self, ) = @_;
                return @{ $self->items };
            }
        );
    }


    sub shuffle {
        return __PACKAGE__->new(
            name => 'shuffle',
            code => sub {
                my ( $self, ) = @_;
                require List::Util;
                return List::Util::shuffle @{ $self->items };
            }
        );
    }
};
BEGIN {
  $Set::Associate::RefillItems::AUTHORITY = 'cpan:KENTNL';
}
{
  $Set::Associate::RefillItems::VERSION = '0.001000';
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::RefillItems - Pool repopulation methods

=head1 VERSION

version 0.001000

=head1 METHODS

=head2 linear

Populate from C<items> each time.

=head2 shuffle

Populate with a shuffled version of C<items>

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
