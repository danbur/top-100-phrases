# Top n items by frequency accumulator - this is a generic class that increments the count of a series of items and
# returns the top n items by frequency.  It is implemented using a hash map and a min-heap.
# TODO: More explanation of the algorithm
package TopNItemsByFrequencyAccumulator;
use strict;
use warnings FATAL => 'all';
use IndexedMinHeap;
use Comparator::Num;

sub new {
    my ($class, $count) = @_;
    my $item_counts = {};
    my $self = {
        'count'       => $count,
        'item_counts' => $item_counts,
        'heap'        => IndexedMinHeap->new($count, Comparator::Num->new)
    };
    return bless $self, $class;
}

# Increments the count of an item (or adds it if is absent)
sub increment_count {
    my ($self, $item) = @_;
    ++$self->{item_counts}->{$item};
    if ($self->{heap}->contains($item)) {
        # Item is already in the heap - update it
        $self->{heap}->increase_value($item, $self->{item_counts}->{$item});
    }
    else {
        # Item is not in the heap
        if (!$self->{heap}->is_full()) {
            # If the heap is not full, add it
            $self->{heap}->insert($item, $self->{item_counts}->{$item});
        }
        else {
            # If the heap is full, compare the count to the min item in the heap
            if ($self->{item_counts}->{$item} > $self->{item_counts}->{$self->{heap}->peek().value}) {
                # Item count is greater than the min item in the heap - remove and replace it
                # TODO: optimize this
                $self->{heap}->remove();
                $self->{heap}->insert($item, $self->{item_counts}->{$item});
            }
        }
    }

}

# Returns the top n items from the highest to lowest count
sub get_top_items {
    my $self = shift;
    my @top_items;
    while (!$self->{'heap'}->is_empty) {
        unshift @top_items, $self->{'heap'}->remove_min();
    }
    return @top_items;
}

1;