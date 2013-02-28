use v5.16;
use warnings;

package Set::Associate::Role::NewKey {
  use MooseX::Role::Parameterized;

  parameter can_get_next => (
    isa     => Bool =>,
    is      => rw   =>,
    default => sub  { undef },
  );

  parameter can_get_assoc => (
    isa     => Bool =>,
    is      => rw   =>,
    default => sub  { undef },
  );

  role {
    my $p = shift;

    requires name =>;

    if ( $p->can_get_next ) {
      requires get_next =>;
    }
    if ( $p->can_get_assoc ) {
      requires get_assoc =>;
    }

  }
}

