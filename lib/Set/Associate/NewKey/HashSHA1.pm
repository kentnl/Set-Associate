use v5.16;
use warnings;

package Set::Associate::NewKey::HashSHA1 {
BEGIN {
  $Set::Associate::NewKey::HashSHA1::AUTHORITY = 'cpan:KENTNL';
}

{
  $Set::Associate::NewKey::HashSHA1::VERSION = '0.003000';
}


  # ABSTRACT: Pick a value from the pool based on the SHA1 value of the key

  use Moose;
  use Digest::SHA1;
  extends 'Set::Associate::NewKey::PickOffset';

  sub name { 'hash_sha1' }

  around get_assoc => sub {
    my ( $orig, $self, $sa, $key ) = @_;
    use bigint;
    return $self->$orig( $sa, hex Digest::SHA1::sha1_hex($key) );
  };

  __PACKAGE__->meta->make_immutable;
};

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::NewKey::HashSHA1 - Pick a value from the pool based on the SHA1 value of the key

=head1 VERSION

version 0.003000

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
