use v5.16;
use warnings;

package Set::Associate::NewKey {

    sub linear_wrap {
        return sub {
            my ( $self, ) = @_;
            return shift @{ $self->_items_cache };
        };
    }

    sub random_pick {
        return sub {
            my ( $self, ) = @_;
            return $self->_items_cache_get(
                int( rand( $self->_items_cache_count ) ) );
        };
    }

    sub pick_offset {
        return sub {
            my ( $self, $offset ) = @_;
            use bigint;
            return $self->_items_cache_get(
                $offset % $self->_items_cache_count );
        };
    }

    sub hash_sha1 {
        require Digest::SHA1;
        my $pick_offset = pick_offset();
        return sub {
            my ( $self, $key ) = @_;
            use bigint;
            return $pick_offset->( $self, hex( Digest::SHA1::sha1_hex($key) ) );
        };
    }

    sub hash_md5 {
        require Digest::MD5;
        my $pick_offset = pick_offset();
        return sub {
            my ( $self, $key ) = @_;
            use bigint;
            return $pick_offset->( $self, hex( Digest::MD5::md5_hex($key) ) );
        };
    }
}

1;
BEGIN {
  $Set::Associate::NewKey::AUTHORITY = 'cpan:KENTNL';
}
{
  $Set::Associate::NewKey::VERSION = '0.1.0';
}

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::NewKey

=head1 VERSION

version 0.1.0

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
