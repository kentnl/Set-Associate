
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.4003",
    "Test::More" => "0.98",
    "strict" => 0
  },
  "configure_requires" => {
    "Module::Build" => "0.4003"
  },
  "dist_abstract" => "Pick items from a dataset associatively",
  "dist_author" => [
    "Kent Fredric <kentfredric\@gmail.com>"
  ],
  "dist_name" => "Set-Associate",
  "dist_version" => "0.002000",
  "license" => "perl",
  "module_name" => "Set::Associate",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Carp" => 0,
    "Digest::MD5" => 0,
    "Digest::SHA1" => 0,
    "List::Util" => 0,
    "Moo" => 0,
    "Scalar::Util" => 0,
    "bigint" => 0,
    "perl" => "v5.16.0",
    "warnings" => 0
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
