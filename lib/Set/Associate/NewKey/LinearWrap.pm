use v5.16;
use warnings;

package Set::Associate::NewKey::LinearWrap {
our $AUTHORITY = 'cpan:KENTNL';

$Set::Associate::NewKey::LinearWrap::VERSION = '0.003001';
  # ABSTRACT: destructively empty the supply pool from the left hand end to give associations.
  use Moose;

  with 'Set::Associate::Role::NewKey' => { can_get_assoc => 1, };


  sub name { 'linear_wrap' }


  sub get_assoc {
    my ( $self, $sa, $key ) = @_;
    return $sa->_items_cache_shift;
  }

  __PACKAGE__->meta->make_immutable;
};

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Set::Associate::NewKey::LinearWrap - destructively empty the supply pool from the left hand end to give associations.

=head1 VERSION

version 0.003001

=head1 METHODS

=head2 name

The name of this key assignment method ( C<linear_wrap> )

=head2 get_assoc

Returns a value destructively by taking the first value from C<$set_assoc>'s pool.

C<$new_key> is ignored with this method.

   my $value = $object->get_assoc( $set_assoc, $new_key );

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
