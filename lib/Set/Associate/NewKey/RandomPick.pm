use v5.16;
use warnings;

package Set::Associate::NewKey::RandomPick {
BEGIN {
  $Set::Associate::NewKey::RandomPick::AUTHORITY = 'cpan:KENTNL';
}

{
  $Set::Associate::NewKey::RandomPick::VERSION = '0.003000';
}


  # ABSTRACT: Associate a key by randomly picking from a pool

  use Moose;

  with 'Set::Associate::Role::NewKey' => { can_get_assoc => 1, };

  sub name { 'random_pick' }

  sub get_assoc {
    my ( $self, $sa, $key ) = @_;
    return $sa->_items_cache_get( int( rand( $sa->_items_cache_count ) ) );
  }

  __PACKAGE__->meta->make_immutable;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::NewKey::RandomPick - Associate a key by randomly picking from a pool

=head1 VERSION

version 0.003000

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
