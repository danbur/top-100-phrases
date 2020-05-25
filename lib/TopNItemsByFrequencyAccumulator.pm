# Top n items by frequency accumulator - this is a generic class that increments the count of a series of items and
# returns the top n items by frequency.  It is implemented using a hash map and a min-heap.
# TODO: More explanation of the algorithm
package TopNItemsByFrequencyAccumulator;
use strict;
use warnings FATAL => 'all';
use IndexedMinHeap;
use Comparator::ItemCount;

sub new {
    my ($class, $count) = @_;
    my $item_counts = {};
    my $self = {
        'count'       => $count,
        'item_counts' => $item_counts,
        'heap'        => IndexedMinHeap->new($count, Comparator::ItemCount->new($item_counts))
    };
    return bless $self, $class;
}

# Increments the count of an item (or adds it if is absent)
sub increment_count {
    my ($self, $item) = @_;
    # DEBUG
    print "$item\n";
    ++$self->{item_counts}->{$item};
    if ($self->{heap}->contains($item)) {
        # Item is already in the heap
        # TODO
    }
    else {
        # Item is not in the heap - add it
        $self->{heap}->insert($item);
    }

}

sub get_top_items {
    # TODO
    return [ ItemCount->new('foo bar baz', 2), ItemCount->new('quick brown fox', 3), ItemCount->new('fold over this', 1) ];
}

1;