use 5.006;
use strict;
use warnings;

package Set::Associate::Role::NewKey;

# ABSTRACT: A Key Association methodology for Set::Associate

our $VERSION = '0.004000';

# AUTHORITY

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

};

1;
