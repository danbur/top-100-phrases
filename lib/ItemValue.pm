# Represents an item and associated value
package ItemValue;
use strict;
use warnings FATAL => 'all';
use English;

sub new {
    my ($class, $item, $value) = @ARG;
    my $self = { 'item' => $item, 'value' => $value };
    return bless $self, $class;
}

sub item {
    my $self = shift;
    return $self->{item};
}

sub value {
    my $self = shift;
    return $self->{value};
}

1;