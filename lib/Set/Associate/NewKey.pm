use v5.16;
use warnings;

package Set::Associate::NewKey {

    # ABSTRACT: New Key assignment methods

    use Moose;
    use MooseX::AttributeShortcuts;
    use MooseX::Types::Moose qw( CodeRef Str );

    has name => (
        isa      => Str,
        is       => rwp =>,
        required => 1,
    );
    has code => (
        isa      => CodeRef,
        is       => rwp =>,
        required => 1,
        traits   => [qw( Code )],
        handles  => {
            run => execute =>,
        },
    );

    no Moose;
    __PACKAGE__->meta->make_immutable;


    sub linear_wrap {
        return __PACKAGE__->new(
            name => 'linear_wrap',
            code => sub {
                my ( $self, ) = @_;
                return $self->_items_cache_shift;
            }
        );
    }


    sub random_pick {
        return __PACKAGE__->new(
            name => 'random_pick',
            code => sub {
                my ( $self, ) = @_;
                return $self->_items_cache_get(
                    int( rand( $self->_items_cache_count ) ) );
            }
        );
    }


    sub pick_offset {
        return __PACKAGE__->new(
            name => 'pick_offset',
            code => sub {
                my ( $self, $offset ) = @_;
                use bigint;
                return $self->_items_cache_get(
                    $offset % $self->_items_cache_count );
            }
        );
    }


    sub hash_sha1 {
        require Digest::SHA1;
        my $pick_offset = pick_offset();
        return __PACKAGE__->new(
            name => 'hash_sha1',
            code => sub {
                my ( $self, $key ) = @_;
                use bigint;
                return $pick_offset->run( $self,
                    hex Digest::SHA1::sha1_hex($key) );
            }
        );
    }


    sub hash_md5 {
        require Digest::MD5;
        my $pick_offset = pick_offset();
        return __PACKAGE__->new(
            name => 'hash_md5',
            code => sub {
                my ( $self, $key ) = @_;
                use bigint;
                return $pick_offset->run( $self,
                    hex Digest::MD5::md5_hex($key) );
            }
        );
    }
}

1;
BEGIN {
  $Set::Associate::NewKey::AUTHORITY = 'cpan:KENTNL';
}
{
  $Set::Associate::NewKey::VERSION = '0.001000';
}

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::NewKey - New Key assignment methods

=head1 VERSION

version 0.001000

=head1 METHODS

=head2 linear_wrap

C<shift>'s the first item off the internal C<_items_cache>

    my $code = linear_wrap();
    my $newval = $code->( $set );

=head2 random_pick

non-destructively picks an element from C<_items_cache> at random.

    my $code = random_pick();
    my $newval = $code->run( $set );

=head2 pick_offset

Assuming offset is numeric, pick either that number, or a modulo of that number.

    my $code = pick_offset();
    my $newval = $code->run( $set, 9001 ); # despite picking numbers OVER NINE THOUSAND
                                        # will still return items in the array

=head2 hash_sha1

B<requires bigint support>

Determines the offset for L</pick_offset> from taking the numeric value of the SHA1 hash of the given string

    my $code = hash_sha1();
    my $newval = $code->( $set, "Some String" );

=head2 hash_md5

B<requires bigint support>

Determines the offset for L</pick_offset> from taking the numeric value of the MD5 hash of the given string

    my $code = hash_md5();
    my $newval = $code->( $set, "Some String" );

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
