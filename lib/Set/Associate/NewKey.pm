use v5.16;
use warnings;

package Set::Associate::NewKey {
BEGIN {
  $Set::Associate::NewKey::AUTHORITY = 'cpan:KENTNL';
}

{
  $Set::Associate::NewKey::VERSION = '0.003000';
}


  # ABSTRACT: New Key assignment methods


  use Carp qw( croak );
  use Moose;
  use MooseX::AttributeShortcuts;

  use Set::Associate::Utils;

  *_warn_nonmethod = *Set::Associate::Utils::_warn_nonmethod;


  has name => (
    isa      => Str =>,
    is       => rwp =>,
    required => 1,
  );


  has code => (
    isa      => CodeRef =>,
    is       => rwp     =>,
    required => 1,
  );


  sub run {
    my ( $self, $sa, $key ) = @_;
    croak('->run(x,y), x should be a ref') if not ref $sa;
    $self->code->( $sa, $key );
  }

  no Moo;


  sub linear_wrap {
    if ( _warn_nonmethod( $_[0], __PACKAGE__, 'linear_wrap' ) ) {
      unshift @_, __PACKAGE__;
    }
    my ( $class, @args ) = @_;
    require Set::Associate::NewKey::LinearWrap;

    return Set::Associate::NewKey::LinearWrap->new(@args);
  }


  sub random_pick {
    if ( _warn_nonmethod( $_[0], __PACKAGE__, 'random_pick' ) ) {
      unshift @_, __PACKAGE__;
    }
    my ( $class, @args ) = @_;
    require Set::Associate::NewKey::RandomPick;
    return Set::Associate::NewKey::RandomPick->new(@args);
  }


  sub pick_offset {
    if ( _warn_nonmethod( $_[0], __PACKAGE__, 'pick_offset' ) ) {
      unshift @_, __PACKAGE__;
    }
    my ( $class, @args ) = @_;
    require Set::Associate::NewKey::PickOffset;
    return Set::Associate::NewKey::PickOffset->new(@args);
  }


  sub hash_sha1 {
    if ( _warn_nonmethod( $_[0], __PACKAGE__, 'hash_sha1' ) ) {
      unshift @_, __PACKAGE__;
    }
    my ( $class, @args ) = @_;
    require Set::Associate::NewKey::HashSHA1;
    return Set::Associate::NewKey::HashSHA1->new(@args);
  }


  sub hash_md5 {
    if ( _warn_nonmethod( $_[0], __PACKAGE__, 'hash_md5' ) ) {
      unshift @_, __PACKAGE__;
    }
    my ( $class, @args ) = @_;
    require Set::Associate::NewKey::HashMD5;
    return Set::Associate::NewKey::HashMD5->new(@args);
  }
};

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::NewKey - New Key assignment methods

=head1 VERSION

version 0.003000

=head1 DESCRIPTION

This class implements the mechanism which controls how the values are assigned to 'new' keys.

The part you're mostly interested in are the L</CLASS METHODS>, which return the right populator.

This is more or less a wrapper for passing around subs with an implict interface.

    my $assigner = Set::Associate::NewKey->new(
        name => 'linear_wrap',
        code => sub {
            my ( $self, $sa , $key ) = @_;
            ....
        },
    );

    my $value = $assigner->run( $set_associate_object, $key );

=head1 CONSTRUCTOR ARGUMENTS

=head2 name

    required Str

=head2 code

    required CodeRef

=head1 CLASS METHODS

=head2 linear_wrap

C<shift>'s the first item off the internal C<_items_cache>

    my $sa = Set::Associate->new(
        ...
        on_new_key => Set::Associate::NewKey->linear_wrap
    );

or alternatively

    my $code = Set::Associate::NewKey->linear_wrap
    my $newval = $code->run( $set, $key_which_will_be_ignored );

=head2 random_pick

non-destructively picks an element from C<_items_cache> at random.

    my $sa = Set::Associate->new(
        ...
        on_new_key => Set::Associate::NewKey->random_pick
    );

or alternatively

    my $code = Set::Associate::NewKey->random_pick
    my $newval = $code->run( $set, $key_which_will_be_ignored );

=head2 pick_offset

Assuming offset is numeric, pick either that number, or a modulo of that number.

B<NOTE:> do not use this unless you are only working with numeric keys.

If you're using anything else, the hash_sha1 or hash_md5 methods are suggested.

    my $sa = Set::Associate->new(
        ...
        on_new_key => Set::Associate::NewKey->pick_offset
    );

or alternatively

    my $code = Set::Associate::NewKey->pick_offset
    my $newval = $code->run( $set, 9001 ); # despite picking numbers OVER NINE THOUSAND
                                           # will still return items in the array

=head2 hash_sha1

B<requires bigint support>

Determines the offset for L</pick_offset> from taking the numeric value of the SHA1 hash of the given string

    my $sa = Set::Associate->new(
        ...
        on_new_key => Set::Associate::NewKey->hash_sha1
    );

or alternatively

    my $code = Set::Associate::NewKey->hash_sha1();
    my $newval = $code->run( $set, "Some String" );

=head2 hash_md5

B<requires bigint support>

Determines the offset for L</pick_offset> from taking the numeric value of the MD5 hash of the given string

    my $sa = Set::Associate->new(
        ...
        on_new_key => Set::Associate::NewKey->hash_md5
    );

or alternatively

    my $code = Set::Associate::NewKey->hash_md5();
    my $newval = $code->run( $set, "Some String" );

=head1 METHODS

=head2 run

runs code attached via L</code>

    my $value = $object->run( $set_associate_object , $key );

And C<$value> is the newly formed associaiton value.

=head1 ATTRIBUTES

=head2 name

=head2 code

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
