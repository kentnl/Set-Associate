use v5.16;
use warnings;

package Set::Associate::RefillItems::Linear {
BEGIN {
  $Set::Associate::RefillItems::Linear::AUTHORITY = 'cpan:KENTNL';
}

{
  $Set::Associate::RefillItems::Linear::VERSION = '0.003000';
}


  # ABSTRACT: a refill method that replenishes the cache with a repeating set of items
  use Moose;

  with 'Set::Associate::Role::RefillItems' => { can_get_all => 1 };


  has items => ( isa => 'ArrayRef', is => 'rw', required => 1 );


  sub name { 'linear' }


  sub get_all { return @{ $_[0]->items } }

  __PACKAGE__->meta->make_immutable;
};

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::RefillItems::Linear - a refill method that replenishes the cache with a repeating set of items

=head1 VERSION

version 0.003000

=head1 CONSTRUCTOR ARGUMENTS

=head2 items

    required ArrayRef

=head1 METHODS

=head2 name

The name of this refill method ( C<linear> )

=head2 get_all

Get a new copy of L</items>.

=head1 ATTRIBUTES

=head2 items

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
