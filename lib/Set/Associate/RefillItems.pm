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

=method linear

Populate from C<items> each time.

=cut

    sub linear {
        return __PACKAGE__->new(
            name => 'linear',
            code => sub {
                my ( $self, ) = @_;
                return @{ $self->items };
            }
        );
    }

=method shuffle

Populate with a shuffled version of C<items>

=cut

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
}

1;
