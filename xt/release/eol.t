use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::EOLTests 0.18

use Test::More 0.88;
use Test::EOL;

my @files = (
    'lib/Set/Associate.pm',
    'lib/Set/Associate/NewKey.pm',
    'lib/Set/Associate/NewKey/HashMD5.pm',
    'lib/Set/Associate/NewKey/HashSHA1.pm',
    'lib/Set/Associate/NewKey/LinearWrap.pm',
    'lib/Set/Associate/NewKey/PickOffset.pm',
    'lib/Set/Associate/NewKey/RandomPick.pm',
    'lib/Set/Associate/RefillItems.pm',
    'lib/Set/Associate/RefillItems/Linear.pm',
    'lib/Set/Associate/RefillItems/Shuffle.pm',
    'lib/Set/Associate/Role/NewKey.pm',
    'lib/Set/Associate/Role/RefillItems.pm',
    'lib/Set/Associate/Utils.pm',
    't/00-compile.t',
    't/000-report-versions-tiny.t',
    't/01_assoc/01_linear.t',
    't/01_assoc/02_random_shuffle.t',
    't/01_assoc/03_random_pick.t',
    't/01_assoc/04_hash_sha1.t',
    't/01_assoc/05_hash_md5.t',
    't/02_assoc_new/01_linear.t',
    't/02_assoc_new/02_random_shuffle.t',
    't/02_assoc_new/03_random_pick.t',
    't/02_assoc_new/04_hash_sha1.t',
    't/02_assoc_new/05_hash_md5.t',
    't/03_assoc_direct/01_linear.t',
    't/03_assoc_direct/02_random_shuffle.t',
    't/03_assoc_direct/03_random_pick.t',
    't/03_assoc_direct/04_hash_sha1.t',
    't/03_assoc_direct/05_hash_md5.t'
);

eol_unix_ok($_, { trailing_whitespace => 1 }) foreach @files;
done_testing;
