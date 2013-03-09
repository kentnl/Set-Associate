use v5.16;
use warnings;

package Set::Associate::NewKey::PickOffset {
BEGIN {
  $Set::Associate::NewKey::PickOffset::AUTHORITY = 'cpan:KENTNL';
}

{
  $Set::Associate::NewKey::PickOffset::VERSION = '0.003000';
}


  # ABSTRACT: Associate a key with a value from a pool based on the keys value as a numeric offset.

  use Moose;

  with 'Set::Associate::Role::NewKey' => { can_get_assoc => 1, };


  sub name { 'pick_offset' }

  sub get_assoc {
    my ( $self, $sa, $key ) = @_;
    use bigint;
    return $sa->_items_cache_get( $key % $sa->_items_cache_count );
  }

  __PACKAGE__->meta->make_immutable;
};

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::NewKey::PickOffset - Associate a key with a value from a pool based on the keys value as a numeric offset.

=head1 VERSION

version 0.003000

=head1 METHODS

=head2 name

The name of this key assignment method ( C<pick_offset> )

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
