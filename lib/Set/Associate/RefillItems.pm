use v5.16;
use warnings;

package Set::Associate::RefillItems {

  # ABSTRACT: Pool repopulation methods
  use Moo;

  has name => (
    isa => sub { die 'should be Str' if ref $_[0] },
    is       => rwp =>,
    required => 1,
  );
  has code => (
    isa => sub { die 'should be CodeRef' unless ref $_[0] and ref $_[0] eq 'CODE' },
    is       => rwp =>,
    required => 1,
  );

  sub run {
    my ( $self, $sa ) = @_;
    die if not ref $sa;
    $self->code->($sa);
  }

  no Moo;

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
};

1;
