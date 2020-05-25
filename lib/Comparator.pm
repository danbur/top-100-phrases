# A generic comparator interface for item ordering
# This class is not complete - the default implementation just considers all items equal
package Comparator;

use strict;
use warnings FATAL => 'all';


sub new {
    my $class = shift;
    return bless {}, $class;
}

# This function takes two elements and returns -1, 0, or 1 if the
# first is less than, equal to, or greater than the second, according
# to some given criteria -- this should be reimplemented by a subclass.
sub compare {
    return 0;
}

1;
