#test that the module is loaded properly
use strict;
use warnings;
use Test::More 0.88;
plan tests => 1;
use Test::NoWarnings;
my $package = 'Convert::TBX::Min';

new_ok($package);

__END__