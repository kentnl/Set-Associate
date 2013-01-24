use v5.16;
use warnings;

package Set::Associate {

  # ABSTRACT: Pick items from a dataset associatively



  use Moose;
  use MooseX::AttributeShortcuts;
  use MooseX::Types::Moose qw( ArrayRef HashRef Any CodeRef );
  use Set::Associate::NewKey;
  use Set::Associate::RefillItems;


  has items => (
    isa => ArrayRef [Any],
    is       => rwp     =>,
    required => 1,
    traits   => [ Array => ],
    handles  => {
      items_elements => elements =>,
    }
  );


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


  has on_items_empty => (
    isa     => CodeRef,
    is      => rwp =>,
    traits  => [ Code => ],
    lazy    => 1,
    default => \&Set::Associate::RefillItems::linear,
    handles => {
      run_on_items_empty => execute_method =>,
    }
  );


  has on_new_key => (
    isa     => CodeRef,
    is      => rwp =>,
    traits  => [ Code => ],
    lazy    => 1,
    default => \&Set::Associate::NewKey::linear_wrap,
    handles => {
      run_on_new_key => execute_method =>,
    },
  );


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

  __PACKAGE__->meta->make_immutable;

  no Moose;

}

1;
BEGIN {
  $Set::Associate::AUTHORITY = 'cpan:KENTNL';
}
{
  $Set::Associate::VERSION = '0.1.0';
}

__END__

=pod

=encoding utf-8

=head1 NAME

Set::Associate - Pick items from a dataset associatively

=head1 VERSION

version 0.1.0

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

=head2 Pool Population

The pool of available options ( C<_items_cache> ) is initialised as an empty list, and every time the pool is being detected as empty ( C<_items_cache_empty> ), the C<on_items_empty> method is called ( C<run_on_items_empty> ) and the results are pushed into the pool.

The L<< default implementation|Set::Associate::RefillItems/linear >> copies items from C<items> into the pool.

=head2 Pool Selection

Pool selection can either be cherry-pick based, where the pool doesn't shrink, or can be destructive, so that the pool population phase is triggered to replenish the supply of items only when all values have been exhausted.

The L<< default implementation|Set::Associate::NewKey/linear_wrap >> C<shift>'s the first item off the queue, allowing the queue to be exhausted and requiring pool population to occur periodically to regenerate the source list.

=head1 CONSTRUCTOR ARGUMENTS

=head2 items

=head2 _items_cache

=head2 _association_cache

=head2 on_items_empty

=head2 on_new_key

=head1 METHODS

=head2 associate

    if( $object->associate( $key ) ) {
        say "already cached";
    } else {
        say "new value"
    }

=head2 get_associated

    my $result = $object->get_associated( $key );

=head1 ATTRIBUTES

=head2 items

=head2 _items_cache

=head2 _association_cache

=head2 on_items_empty

=head2 on_new_key

=head1 ATTRIBUTE HANDLES

=head2 item_elements

    Native::Array/elements

=head2 _items_cache_empty => Native::Array/is_empty

=head2 _items_cache_shift => Native::Array/shift

=head2 _items_cache_push  => Native::Array/push

=head2 _items_cache_count => Native::Array/count

=head2 _items_cache_get   => Native::Array/get

=head2 _association_cache_has =>   Native::Hash/exists

=head2 _association_cache_get =>   Native::Hash/get

=head2 _association_cache_set =>   Native::Hash/set

=head2 run_on_items_empty

    Native::Code/execute_method

=head2 run_on_new_key

    Native::Code/execute_method

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
