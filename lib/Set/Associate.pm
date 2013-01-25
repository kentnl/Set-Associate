use v5.16;
use warnings;

package Set::Associate {
BEGIN {
  $Set::Associate::AUTHORITY = 'cpan:KENTNL';
}

{
  $Set::Associate::VERSION = '0.001000';
}


    # ABSTRACT: Pick items from a dataset associatively



    use Moo;
    use Scalar::Util qw( blessed  );
    use Set::Associate::NewKey;
    use Set::Associate::RefillItems;


    has items => (
        isa => sub {
            die 'should be ArrayRef' unless ref $_[0] and ref $_[0] eq 'ARRAY';
        },
        is       => rwp =>,
        required => 1,
    );
    sub items_elements { @{ $_[0]->items } }


    has _items_cache => (
        isa => sub {
            die 'should be ArrayRef' unless ref $_[0] and ref $_[0] eq 'ARRAY';
        },
        is      => rwp =>,
        lazy    => 1,
        default => sub { [] },
    );
    sub _items_cache_empty { scalar @{ $_[0]->_items_cache } == 0 }
    sub _items_cache_shift { shift @{ $_[0]->_items_cache } }
    sub _items_cache_push  { push @{ $_[0]->_items_cache }, splice @_, 1 }
    sub _items_cache_count { scalar @{ $_[0]->_items_cache } }
    sub _items_cache_get   { $_[0]->_items_cache->[ $_[1] ] }


    has _association_cache => (
        isa => sub {
            die 'Should be HashRef' unless ref $_[0] and ref $_[0] eq 'HASH';
        },
        is      => rwp =>,
        default => sub { {} }
    );
    sub _association_cache_has { exists $_[0]->_association_cache->{ $_[1] } }
    sub _association_cache_get { $_[0]->_association_cache->{ $_[1] } }
    sub _association_cache_set { $_[0]->_association_cache->{ $_[1] } = $_[2] }


    has on_items_empty => (
        isa => sub {
            die 'Should be a ::RefillItems'
              unless blessed( $_[0] )
              and $_[0]->isa('Set::Associate::RefillItems');
        },
        is      => rwp =>,
        lazy    => 1,
        default => \&Set::Associate::RefillItems::linear,
    );


    sub run_on_items_empty { $_[0]->on_items_empty->run(@_) }


    has on_new_key => (
        isa => sub {
            die 'Should be a ::NewKey'
              unless blessed( $_[0] )
              and $_[0]->isa('Set::Associate::NewKey');
        },
        is      => rwp =>,
        lazy    => 1,
        default => \&Set::Associate::NewKey::linear_wrap,
    );

    sub run_on_new_key { $_[0]->on_new_key->run(@_) }


    sub associate {
        my ( $self, $key ) = @_;
        return if $self->_association_cache_has($key);
        if ( $self->_items_cache_empty ) {
            $self->_items_cache_push( $self->run_on_items_empty );
        }
        $self->_association_cache_set( $key, $self->run_on_new_key($key) );
        return 1;
    }


    sub get_associated {
        my ( $self, $key ) = @_;
        $self->associate($key);
        return $self->_association_cache_get($key);
    }

};

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate - Pick items from a dataset associatively

=head1 VERSION

version 0.001000

=head1 DESCRIPTION

Essentially, this is a simple toolkit to map an infinite-many items to a corresponding finite-many values,
ie: A nick coloring algorithm.

The most simple usage of this code gives out values from C<items> seqeuntially, and remembers seen values
and persists them within the scope of the program, ie:

    my $set = Set::Associate->new(
        items => [qw( red blue yellow )],
    );
    sub color_nick {
        my $nick = shift;
        return colorize( $nick, $set->get_associated( $nick );
    }
    ...
    printf '<< %s >> %s', color_nick( $nick ), $message;

And this is extensible to use some sort of persisting allocation method such as a hash

    my $set = Set::Associate->new(
        items => [qw( red blue yellow )],
        on_new_key => Set::Associate::NewKey::hash_sha1,
    );
    sub color_nick {
        my $nick = shift;
        return colorize( $nick, $set->get_associated( $nick );
    }
    ...
    printf '<< %s >> %s', color_nick( $nick ), $message;

Alternatively, you could use 1 of 2 random forms:

    # Can produce colour runs if you're unlucky

    my $set = Set::Associate->new(
        items => [qw( red blue yellow )],
        on_new_key => Set::Associate::NewKey::random_pick,
    );

    # Will exhaust the colour variation before giving out the same colour twice
    my $set = Set::Associate->new(
        items => [qw( red blue yellow )],
        on_items_empty => Set::Associate::RefillItems::shuffle,
    );

=head1 IMPLEMENTATION DETAILS

There are 2 Main phases that occur within this code

=over 4

=item * pool population

=item * pool selection

=back

=head2 Pool Population

The pool of available options ( C<_items_cache> ) is initialised as an empty list, and every time the pool is being detected as empty ( C<_items_cache_empty> ), the C<on_items_empty> method is called ( C<run_on_items_empty> ) and the results are pushed into the pool.

The L<< default implementation|Set::Associate::RefillItems/linear >> copies items from C<items> into the pool.

=head2 Pool Selection

Pool selection can either be cherry-pick based, where the pool doesn't shrink, or can be destructive, so that the pool population phase is triggered to replenish the supply of items only when all values have been exhausted.

The L<< default implementation|Set::Associate::NewKey/linear_wrap >> C<shift>'s the first item off the queue, allowing the queue to be exhausted and requiring pool population to occur periodically to regenerate the source list.

=head1 CONSTRUCTOR ARGUMENTS

=head2 items

    required ArrayRef[ Any ]

=head2 on_items_empty

    lazy Set::Associate::RefillItems = Set::Associate::RefillItems::linear

=head2 on_new_key

    lazy Set::Associate::NewKey = Set::Associate::NewKey::linear_wrap

=head1 METHODS

=head2 item_elements

=head2 run_on_items_empty

    if( not @items ){
        push @items, $sa->run_on_items_empty();
    }

=head2 run_on_new_key

    if ( not exists $cache{$key} ){
        $cache{$key} = $sa->run_on_new_key( $key );
    }

=head2 associate

    if( $object->associate( $key ) ) {
        say "already cached";
    } else {
        say "new value"
    }

=head2 get_associated

Generates an association automatically.

    my $result = $object->get_associated( $key );

=head1 ATTRIBUTES

=head2 items

=head2 on_items_empty

    my $object = $sa->on_items_empty();
    say "Running empty items mechanism " . $object->name;
    push @items, $object->run( $sa  );

=head2 on_new_key

    my $object = $sa->on_new_key();
    say "Running new key mechanism " . $object->name;
    my $value = $object->run( $sa, $key );

=head1 PRIVATE CONSTRUCTOR ARGUMENTS

=head2 _items_cache

    lazy ArrayRef[ Any ] = [ ]

=head2 _association_cache

    lazy HashRef[ Any ] = { }

=head1 PRIVATE ATTRIBUTES

=head2 _items_cache

=head2 _association_cache

    my $cache = $sa->_association_cache();
    $cache->{ $key } = $value;

=head1 PRIVATE ATTRIBUTE HANDLES

=head2 _items_cache_empty => Native::Array/is_empty

=head2 _items_cache_shift => Native::Array/shift

=head2 _items_cache_push  => Native::Array/push

=head2 _items_cache_count => Native::Array/count

=head2 _items_cache_get   => Native::Array/get

=head2 _association_cache_has =>   Native::Hash/exists

    if ( $sa->_assocition_cache_has( $key ) ){
        return $sa->_association_cache_get( $key );
    }

=head2 _association_cache_get =>   Native::Hash/get

    my $assocval = $sa->_association_cache_get( $key );

=head2 _association_cache_set =>   Native::Hash/set

    $sa->_association_cache_set( $key, $assocval );

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
