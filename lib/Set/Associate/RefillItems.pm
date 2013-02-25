use v5.16;
use warnings;

package Set::Associate::RefillItems {

  # ABSTRACT: Pool repopulation methods
  use Moo;

  sub _croak {
    require Carp;
    goto \&Carp::croak;
  }

  has name => (
    isa => sub { _croak('should be Str') if ref $_[0] },
    is       => rwp =>,
    required => 1,
  );
  has code => (
    isa => sub { _croak('should be CodeRef') unless ref $_[0] and ref $_[0] eq 'CODE' },
    is       => rwp =>,
    required => 1,
  );

  sub run {
    my ( $self, $sa ) = @_;
    _croak('->run(x) should be a ref') if not ref $sa;
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
