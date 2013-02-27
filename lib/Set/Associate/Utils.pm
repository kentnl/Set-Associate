use v5.16;
use warnings;

package Set::Associate::Utils {
BEGIN {
  $Set::Associate::Utils::AUTHORITY = 'cpan:KENTNL';
}

{
  $Set::Associate::Utils::VERSION = '0.001002';
}


  # ABSTRACT: Shared Guts between Set::Associate modules

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
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::Utils - Shared Guts between Set::Associate modules

=head1 VERSION

version 0.001002

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
