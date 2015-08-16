use 5.006;
use strict;
use warnings;

package Set::Associate::Role::RefillItems;

# ABSTRACT: A data provider for Set::Associate

our $VERSION = '0.004000';

# AUTHORITY

use MooseX::Role::Parameterized;

parameter can_get_next => (
  isa     => Bool =>,
  is      => rw   =>,
  default => sub  { undef },
);

parameter can_get_all => (
  isa     => Bool =>,
  is      => rw   =>,
  default => sub  { undef },
);

parameter can_get_nth => (
  isa => Bool =>,
  ,
  is      => rw  =>,
  default => sub { undef },
);

role {
  my $p = shift;

  requires name =>;

  if ( $p->can_get_next ) {
    requires get_next =>;
  }
  if ( $p->can_get_all ) {
    requires get_all =>;
  }
  if ( $p->can_get_nth ) {
    requires get_nth =>;
  }

};

1;
