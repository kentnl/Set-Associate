use v5.16;
use warnings;

package Set::Associate::RefillItems {

  # ABSTRACT: Pool repopulation methods
  use Moo;
  use Set::Associate::Utils;

  *_croak          = *Set::Associate::Utils::_croak;
  *_tc_str         = *Set::Associate::Utils::_tc_str;
  *_tc_coderef     = *Set::Associate::Utils::_tc_coderef;
  *_tc_arrayref    = *Set::Associate::Utils::_tc_arrayref;
  *_warn_nonmethod = *Set::Associate::Utils::_warn_nonmethod;

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


=cut

=carg name

    required Str

=attr name

=cut

  has name => (
    isa      => \&_tc_str,
    is       => rwp =>,
    required => 1,
  );

=carg code

    required CodeRef

=attr code

=cut

  has code => (
    isa      => \&_tc_coderef,
    is       => rwp =>,
    required => 1,
  );

=carg items

    required ArrayRef

=attr items

=ahandle has_items

=cut

  has items => (
    isa       => \&_tc_arrayref,
    is        => rwp =>,
    predicate => has_items =>,
  );

=method run

runs code attached via L</code>

    my ( @list ) = $object->run( $set_associate_object );

Where <@list> is the new pool contents.

=cut

  sub run {
    my ( $self, $sa ) = @_;
    _croak('->run(x) should be a ref') if not ref $sa;
    $self->code->( $self, $sa );
  }

  no Moo;

=cmethod linear

Populate from C<items> each time.

    my $sa = Set::Associate->new(
        ...
        on_items_empty => Set::Associate::RefillItems->linear( items => [ ... ])
    );

=cut

  sub linear {
    _warn_nonmethod( $_[0], __PACKAGE__, 'linear' );
    my ( $class, @args ) = @_;
    return __PACKAGE__->new(
      name => 'linear',
      code => sub {
        my ( $self, $sa ) = @_;
        return @{ $self->items };
      },
      @args,
    );
  }

=cmethod shuffle

Populate with a shuffled version of C<items>

    my $sa = Set::Associate->new(
        ...
        on_items_empty => Set::Associate::RefillItems->shuffle( items => [ ... ]);
    );

=cut

  sub shuffle {
    _warn_nonmethod( $_[0], __PACKAGE__, 'shuffle' );
    my ( $class, @args ) = @_;
    return __PACKAGE__->new(
      name => 'shuffle',
      code => sub {
        my ( $self, $sa ) = @_;
        require List::Util;
        return List::Util::shuffle @{ $self->items };
      },
      @args
    );
  }
};

1;
