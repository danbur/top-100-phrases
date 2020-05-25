# Represents an item and associated count
package ItemCount;
use strict;
use warnings FATAL => 'all';

sub new {
    my ($class, $item, $count) = @_;
    my $self = { 'item' => $item, 'count' => $count };
    return bless $self, $class;
}

sub item {
    my $self = shift;
    return $self->{item};
}

sub count {
    my $self = shift;
    return $self->{count};
}

1;