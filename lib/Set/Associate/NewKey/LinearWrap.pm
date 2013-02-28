use v5.16;
use warnings;

package Set::Associate::NewKey::LinearWrap {
BEGIN {
  $Set::Associate::NewKey::LinearWrap::AUTHORITY = 'cpan:KENTNL';
}

{
  $Set::Associate::NewKey::LinearWrap::VERSION = '0.003000';
}


  use Moose;

  with 'Set::Associate::Role::NewKey' => { can_get_assoc => 1, };

  sub name { 'linear_wrap' }

  sub get_assoc {
    my ( $self, $sa, $key ) = @_;
    return $sa->_items_cache_shift;
  }

  __PACKAGE__->meta->make_immutable;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::NewKey::LinearWrap

=head1 VERSION

version 0.003000

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
