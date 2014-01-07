#basic test file

use strict;
use warnings;
use Test::More;
plan tests => 1;
use Test::NoWarnings;
use Convert::TBX::Min;
use FindBin qw($Bin);
use Path::Tiny;

my $corpus_dir = path($Bin, 'corpus');
my $min = Convert::TBX::Min->new();