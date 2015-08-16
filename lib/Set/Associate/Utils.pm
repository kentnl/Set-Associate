use 5.006;
use strict;
use warnings;

package Set::Associate::Utils;

# ABSTRACT: Shared Guts between Set::Associate modules

our $VERSION = '0.004000';

# AUTHORITY

sub _carp {
  require Carp;
  goto \&Carp::carp;
}

sub _blessed {
  require Scalar::Util;
  goto \&Scalar::Util::blessed;
}

sub _warn_nonmethod {
  if ( defined $_[0] and not ref $_[0] ) {
    return if $_[0]->isa( $_[1] );
  }
  if ( defined $_[0] and _blessed( $_[0] ) ) {
    return if $_[0]->isa( $_[1] );
  }
  _carp( $_[1] . '->' . $_[2] . ' should be called as a method' );
  return 1;
}

1;
