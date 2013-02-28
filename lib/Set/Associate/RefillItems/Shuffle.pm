use v5.16;
use warnings;

package Set::Associate::RefillItems::Shuffle {
BEGIN {
  $Set::Associate::RefillItems::Shuffle::AUTHORITY = 'cpan:KENTNL';
}

{
  $Set::Associate::RefillItems::Shuffle::VERSION = '0.003000';
}


  use Moose;

  with 'Set::Associate::Role::RefillItems' => { can_get_all => 1, };

  has items => ( isa => 'ArrayRef', is => 'rw', required => 1 );

  sub name { 'shuffle' }

  use List::Util qw( shuffle );

  sub get_all { return shuffle( @{ $_[0]->items } ) }

  __PACKAGE__->meta->make_immutable;
};

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::RefillItems::Shuffle

=head1 VERSION

version 0.003000

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
