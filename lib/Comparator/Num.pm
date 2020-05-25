# A simple comparator for numbers

package Comparator::Num;

use strict;
use warnings FATAL => 'all';
use Comparator;
use English
our @ISA = 'Comparator';

sub compare {
    my $value1 = $ARG[1];
    my $value2 = $ARG[2];

    return $value1 <=> $value2;
}

1;
