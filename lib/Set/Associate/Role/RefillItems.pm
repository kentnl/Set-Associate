use v5.16;
use warnings;

package Set::Associate::Role::RefillItems {
BEGIN {
  $Set::Associate::Role::RefillItems::AUTHORITY = 'cpan:KENTNL';
}

{
  $Set::Associate::Role::RefillItems::VERSION = '0.003000';
}

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

  }
}

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::Role::RefillItems

=head1 VERSION

version 0.003000

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
