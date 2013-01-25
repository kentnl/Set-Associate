use v5.16;
use warnings;

package Set::Associate {

    # ABSTRACT: Pick items from a dataset associatively

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

=cut

=head2 Pool Population

The pool of available options ( C<_items_cache> ) is initialised as an empty list, and every time the pool is being detected as empty ( C<_items_cache_empty> ), the C<on_items_empty> method is called ( C<run_on_items_empty> ) and the results are pushed into the pool.

The L<< default implementation|Set::Associate::RefillItems/linear >> copies items from C<items> into the pool.

=head2 Pool Selection

Pool selection can either be cherry-pick based, where the pool doesn't shrink, or can be destructive, so that the pool population phase is triggered to replenish the supply of items only when all values have been exhausted.

The L<< default implementation|Set::Associate::NewKey/linear_wrap >> C<shift>'s the first item off the queue, allowing the queue to be exhausted and requiring pool population to occur periodically to regenerate the source list.


=cut

    use Moose;
    use MooseX::AttributeShortcuts;
    use MooseX::Types::Moose qw( ArrayRef HashRef Any CodeRef );
    use Set::Associate::NewKey;
    use Set::Associate::RefillItems;

=carg items

    required ArrayRef[ Any ]

=attr items

=ahandle item_elements =>  Native::Array/elements

=cut

    has items => (
        isa => ArrayRef [Any],
        is       => rwp     =>,
        required => 1,
        traits   => [ Array => ],
        handles  => {
            items_elements => elements =>,
        }
    );

=carg _items_cache

    lazy ArrayRef[ Any ] = [ ]

=attr _items_cache

=ahandle _items_cache_empty => Native::Array/is_empty

=ahandle _items_cache_shift => Native::Array/shift

=ahandle _items_cache_push  => Native::Array/push

=ahandle _items_cache_count => Native::Array/count

=ahandle _items_cache_get   => Native::Array/get

=cut

    has _items_cache => (
        isa => ArrayRef [Any],
        is      => rwp     =>,
        lazy    => 1,
        default => sub     { [] },
        traits  => [ Array => ],
        handles => {
            _items_cache_empty => is_empty =>,
            _items_cache_shift => shift    =>,
            _items_cache_push  => push     =>,
            _items_cache_count => count    =>,
            _items_cache_get   => get      =>,
        }
    );

=carg _association_cache

    lazy HashRef[ Any ] = { }

=attr _association_cache

=ahandle _association_cache_has =>   Native::Hash/exists

=ahandle _association_cache_get =>   Native::Hash/get

=ahandle _association_cache_set =>   Native::Hash/set

=cut

    has _association_cache => (
        isa => HashRef [Any],
        is      => rwp    =>,
        traits  => [ Hash => ],
        lazy    => 1,
        default => sub    { {} },
        handles => {
            _association_cache_has => exists =>,
            _association_cache_get => get    =>,
            _association_cache_set => set    =>,
        }
    );

=carg on_items_empty

    lazy CodeRef = Set::Associate::RefillItems::linear

=attr on_items_empty

=cut

    has on_items_empty => (
        isa     => 'Set::Associate::RefillItems',
        is      => rwp =>,
        lazy    => 1,
        default => \&Set::Associate::RefillItems::linear,
    );

    sub run_on_items_empty {
        my ($self) = @_;
        return $self->on_items_empty->run($self);
    }

=carg on_new_key

    lazy CodeRef = Set::Associate::NewKey::linear_wrap

=attr on_new_key

=ahandle run_on_new_key =>  Native::Code/execute_method

=cut

    has on_new_key => (
        isa     => 'Set::Associate::NewKey',
        is      => rwp =>,
        lazy    => 1,
        default => \&Set::Associate::NewKey::linear_wrap,
    );

    sub run_on_new_key {
        my ( $self, $key ) = @_;
        return $self->on_new_key->run( $self, $key );
    }

=method associate

    if( $object->associate( $key ) ) {
        say "already cached";
    } else {
        say "new value"
    }

=cut

    sub associate {
        my ( $self, $key ) = @_;
        return if $self->_association_cache_has($key);
        if ( $self->_items_cache_empty ) {
            $self->_items_cache_push( $self->run_on_items_empty );
        }
        $self->_association_cache_set( $key, $self->run_on_new_key($key) );
        return 1;
    }

=method get_associated

    my $result = $object->get_associated( $key );

=cut

    sub get_associated {
        my ( $self, $key ) = @_;
        $self->associate($key);
        return $self->_association_cache_get($key);
    }

    __PACKAGE__->meta->make_immutable;

    no Moose;

}

1;
