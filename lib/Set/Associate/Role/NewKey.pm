use v5.16;
use warnings;

package Set::Associate::Role::NewKey {
BEGIN {
  $Set::Associate::Role::NewKey::AUTHORITY = 'cpan:KENTNL';
}

{
  $Set::Associate::Role::NewKey::VERSION = '0.003000';
}


  # ABSTRACT: A Key Association methodology for Set::Associate
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
};

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::Role::NewKey - A Key Association methodology for Set::Associate

=head1 VERSION

version 0.003000

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
