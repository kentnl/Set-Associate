use v5.16;
use warnings;

package Set::Associate::RefillItems {
BEGIN {
  $Set::Associate::RefillItems::AUTHORITY = 'cpan:KENTNL';
}

{
  $Set::Associate::RefillItems::VERSION = '0.001002';
}


    # ABSTRACT: Pool repopulation methods
    use Moo;
    use Set::Associate::Utils;

    *_croak       = *Set::Associate::Utils::_croak;
    *_tc_str      = *Set::Associate::Utils::_tc_str;
    *_tc_coderef  = *Set::Associate::Utils::_tc_coderef;
    *_tc_arrayref = *Set::Associate::Utils::_tc_arrayref;



    has name => (
        isa      => \&_tc_str,
        is       => rwp =>,
        required => 1,
    );


    has code => (
        isa      => \&_tc_coderef,
        is       => rwp =>,
        required => 1,
    );


    has source_pool => (
        isa       => \&_tc_arrayref,
        is        => rwp =>,
        predicate => has_source_pool =>,
    );


    sub run {
        my ( $self, $sa ) = @_;
        _croak('->run(x) should be a ref') if not ref $sa;
        $self->code->($sa);
    }

    no Moo;


    sub linear {
        return __PACKAGE__->new(
            name => 'linear',
            code => sub {
                my ( $self, ) = @_;
                return @{ $self->items };
            }
        );
    }


    sub shuffle {
        return __PACKAGE__->new(
            name => 'shuffle',
            code => sub {
                my ( $self, ) = @_;
                require List::Util;
                return List::Util::shuffle @{ $self->items };
            }
        );
    }
};

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate::RefillItems - Pool repopulation methods

=head1 VERSION

version 0.001002

=head1 DESCRIPTION

This class implements the mechanism which controls how the main pool populates.

The part you're mostly interested in are the L</CLASS METHODS>, which return the right populator.

This is more or less a wrapper for passing around subs with an implict interface.

    my $populator = Set::Associate::RefillItems->new(
        name => 'linear',
        code => sub {
            my ( $self, $sa ) = @_;
            ....
        },
    );

    my ( @new_pool ) = $populator->run( $set_associate_object );

=head1 CONSTRUCTOR ARGUMENTS

=head2 name

    required Str

=head2 code

    required CodeRef

=head2 source_pool

    required ArrayRef

=head1 CLASS METHODS

=head2 linear

Populate from C<items> each time.

    my $sa = Set::Associate->new(
        ...
        on_items_empty => Set::Associate::RefillItems->linear
    );

=head2 shuffle

Populate with a shuffled version of C<items>

    my $sa = Set::Associate->new(
        ...
        on_items_empty => Set::Associate::RefillItems->shuffle
    );

=head1 METHODS

=head2 run

runs code attached via L</code>

    my ( @list ) = $object->run( $set_associate_object );

Where <@list> is the new pool contents.

=head1 ATTRIBUTES

=head2 name

=head2 code

=head2 source_pool

=head1 ATTRIBUTE HANDLES

=head2 has_source_pool

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
