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

  use Moo;
  use Scalar::Util qw( blessed  );
  use Set::Associate::NewKey;
  use Set::Associate::RefillItems;

  sub _croak {
    require Carp;
    goto \&Carp::croak;
  }

  sub _tc_arrayref {
    _croak('should be ArrayRef') unless ref $_[0] and ref $_[0] eq 'ARRAY';
  }

  sub _tc_hashref {
    _croak('Should be HashRef') unless ref $_[0] and ref $_[0] eq 'HASH';
  }

  sub _tc_bless {
    my ($class) = @_;
    return sub {
      _croak( 'Should be a ' . $class )
        unless blessed( $_[0] )
        and $_[0]->isa($class);
    };
  }

=carg items

    required ArrayRef[ Any ]

=attr items

=method item_elements

=cut

  has items => ( isa => \&_tc_arrayref, is => rwp =>, required => 1, );
  sub items_elements { @{ $_[0]->items } }

=pcarg _items_cache

    lazy ArrayRef[ Any ] = [ ]

=pattr _items_cache

=pmethod _items_cache_empty

=pmethod _items_cache_shift

=pmethod _items_cache_push

=pmethod _items_cache_count

=pmethod _items_cache_get

=cut

  has _items_cache => (
    isa     => \&_tc_arrayref,
    is      => rwp =>,
    lazy    => 1,
    default => sub { [] },
  );
  sub _items_cache_empty { scalar @{ $_[0]->_items_cache } == 0 }
  sub _items_cache_shift { shift @{ $_[0]->_items_cache } }
  sub _items_cache_push  { push @{ $_[0]->_items_cache }, splice @_, 1 }
  sub _items_cache_count { scalar @{ $_[0]->_items_cache } }
  sub _items_cache_get   { $_[0]->_items_cache->[ $_[1] ] }

=pcarg _association_cache

    lazy HashRef[ Any ] = { }

=pattr _association_cache

    my $cache = $sa->_association_cache();
    $cache->{ $key } = $value;

=pmethod _association_cache_has

    if ( $sa->_assocition_cache_has( $key ) ){
        return $sa->_association_cache_get( $key );
    }

=pmethod _association_cache_get

    my $assocval = $sa->_association_cache_get( $key );

=pmethod _association_cache_set

    $sa->_association_cache_set( $key, $assocval );

=cut

  has _association_cache => (
    isa     => \&_tc_hashref,
    is      => rwp =>,
    default => sub { {} },
  );
  sub _association_cache_has { exists $_[0]->_association_cache->{ $_[1] } }
  sub _association_cache_get { $_[0]->_association_cache->{ $_[1] } }
  sub _association_cache_set { $_[0]->_association_cache->{ $_[1] } = $_[2] }

=carg on_items_empty

    lazy Set::Associate::RefillItems = Set::Associate::RefillItems::linear

=attr on_items_empty

    my $object = $sa->on_items_empty();
    say "Running empty items mechanism " . $object->name;
    push @items, $object->run( $sa  );


=cut

  has on_items_empty => (
    isa     => _tc_bless('Set::Associate::RefillItems'),
    is      => rwp =>,
    lazy    => 1,
    default => \&Set::Associate::RefillItems::linear,
  );

=method run_on_items_empty

    if( not @items ){
        push @items, $sa->run_on_items_empty();
    }

=cut

  sub run_on_items_empty { $_[0]->on_items_empty->run(@_) }

=carg on_new_key

    lazy Set::Associate::NewKey = Set::Associate::NewKey::linear_wrap

=attr on_new_key

    my $object = $sa->on_new_key();
    say "Running new key mechanism " . $object->name;
    my $value = $object->run( $sa, $key );

=method run_on_new_key

    if ( not exists $cache{$key} ){
        $cache{$key} = $sa->run_on_new_key( $key );
    }

=cut

  has on_new_key => (
    isa     => _tc_bless('Set::Associate::NewKey'),
    is      => rwp =>,
    lazy    => 1,
    default => \&Set::Associate::NewKey::linear_wrap,
  );

  sub run_on_new_key { $_[0]->on_new_key->run(@_) }

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

Generates an association automatically.

    my $result = $object->get_associated( $key );

=cut

  sub get_associated {
    my ( $self, $key ) = @_;
    $self->associate($key);
    return $self->_association_cache_get($key);
  }

};

1;
