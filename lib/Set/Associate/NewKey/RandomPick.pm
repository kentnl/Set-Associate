use 5.006;
use strict;
use warnings;

package Set::Associate::NewKey::RandomPick;

# ABSTRACT: Associate a key by randomly picking from a pool

our $VERSION = '0.004000';

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moose;

with 'Set::Associate::Role::NewKey' => { can_get_assoc => 1, };







sub name { 'random_pick' }











sub get_assoc {
  my ( $self, $sa, $key ) = @_;
  return $sa->_items_cache_get( int( rand( $sa->_items_cache_count ) ) );
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Set::Associate::NewKey::RandomPick - Associate a key by randomly picking from a pool

=head1 VERSION

version 0.004000

=head1 METHODS

=head2 name

The name of this key assignment method ( C<random_pick> )

=head2 get_assoc

Returns a value non-destructively at random from C<$set_assoc>'s pool.

C<$new_key> is ignored with this method.

   my $value = $object->get_assoc( $set_assoc, $new_key );

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
