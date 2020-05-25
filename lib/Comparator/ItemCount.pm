# Comparator that looks up items in a map of counts and compares the counts
package Comparator::ItemCount;
use strict;
use warnings FATAL => 'all';
use Comparator;
our @ISA = 'Comparator';

# Constructor
# Takes one argument - a map from items to item counts
sub new {
    my($class, $item_counts) = @_;
    my $self = { 'item_counts' => $item_counts };
    return bless $self, $class;
}

sub compare {
    my ($self, $item1, $item2) = @_;

    return $self->{item_counts}->{$item1} <=> $self->{item_counts}->{$item2};
}
1;