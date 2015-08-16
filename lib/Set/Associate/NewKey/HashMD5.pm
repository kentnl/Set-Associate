use v5.16;
use warnings;

package Set::Associate::NewKey::HashMD5 {
$Set::Associate::NewKey::HashMD5::VERSION = '0.003001';
  # ABSTRACT: Pick a value from the pool based on the MD5 value of the key

  use Moose;
  use Digest::MD5;
  extends 'Set::Associate::NewKey::PickOffset';







  sub name { 'hash_md5' }

  around get_assoc => sub {
    my ( $orig, $self, $sa, $key ) = @_;
    use bigint;
    return $self->$orig( $sa, hex Digest::MD5::md5_hex($key) );
  };

  __PACKAGE__->meta->make_immutable;
};

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Set::Associate::NewKey::HashMD5 - Pick a value from the pool based on the MD5 value of the key

=head1 VERSION

version 0.003001

=head1 METHODS

=head2 name

The name of this key assignment method ( C<hash_md5> )

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
