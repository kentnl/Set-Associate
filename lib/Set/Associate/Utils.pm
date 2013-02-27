use v5.16;
use warnings;

package Set::Associate::Utils {

  # ABSTRACT: Shared Guts between Set::Associate modules

  use strict;

  sub _croak {
    require Carp;
    goto \&Carp::croak;
  }

  sub _carp {
    require Carp;
    goto \&Carp::carp;
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

  sub _blessed {
    require Scalar::Util;
    goto \&Scalar::Util::blessed;
  }

  sub _tc_coderef {
    return if defined $_[0] and ref $_[0] eq 'CODE';
    _croak('Should be CodeRef');
  }

  sub _tc_str {
    return if defined $_[0] and not ref $_[0];
    _croak('should be Str');
  }

  sub _tc_arrayref {
    return if ref $_[0] and ref $_[0] eq 'ARRAY';
    _croak('should be ArrayRef');
  }

  sub _tc_hashref {
    return if ref $_[0] and ref $_[0] eq 'HASH';
    _croak('Should be HashRef');
  }

  sub _tc_bless {
    my ($class) = @_;
    return sub {
      return if _blessed( $_[0] ) and $_[0]->isa($class);
      _croak( 'Should be a ' . $class );
    };
  }
};

1;
