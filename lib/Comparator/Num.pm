# A simple comparator for numbers

package Comparator::Num;

use strict;
use warnings FATAL => 'all';
use Comparator;
our @ISA = 'Comparator';

sub compare {
    my $value1 = $_[1];
    my $value2 = $_[2];

    return $value1 <=> $value2;
}

1;
