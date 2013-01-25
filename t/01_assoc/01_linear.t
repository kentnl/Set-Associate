use v5.16;
use warnings;

use Test::More;
use Set::Associate;
use Set::Associate::NewKey;
use Set::Associate::RefillItems;

my $et = Set::Associate->new(
    items      => [qw( hello world this is a test )],
    on_new_key => Set::Associate::NewKey::linear_wrap,
);

my $got = {};

for my $item (qw( a b c d e f g )) {
    $got->{$item} = $et->get_associated($item);
    ok( defined $got->{$item}, "Got something for << $item >>" );
}

for my $item (qw( a b c d e f g )) {
    is( $got->{$item}, $et->get_associated($item), "Second pass is the same" );
}

done_testing;

