use v5.16;
use warnings;

package Set::Associate::RefillItems {

    # ABSTRACT: Pool repopulation methods

=method linear

Populate from C<items> each time.

=cut
    sub linear {
        return sub {
            my ( $self, ) = @_;
            return  @{ $self->items };
        };
    }

=method shuffle

Populate with a shuffled version of C<items>

=cut
    sub shuffle {
        return sub {
            my ( $self, ) = @_;
            require List::Util;
            return List::Util::shuffle @{ $self->items };
        };
    }
}

1;
