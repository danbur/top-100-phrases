# A binary min-heap that keeps an additional index of the position of each item in the heap in an associated map
package IndexedMinHeap;
use strict;
use warnings FATAL => 'all';

# Constructor
# Takes two arguments
#   max_size - Maximum heap size
#   comparator - A comparator of class Comparator
sub new {
    my ($class, $max_size, $comparator) = @_;
    my $self = { 'nodes' => [], 'max_size' => $max_size, 'item_indexes' => {}, 'comparator' => $comparator };
    return bless $self, $class;
}

# Returns true if the heap is full
sub is_full {
    my $self = shift;
    return @{$self->{nodes}} == $self->{max_size};
}

# Returns true if heap is empty
sub is_empty {
    my $self = shift;

    return !$self->_num_nodes;
}

# Insert an element to the heap
sub insert {
    my ($self, $item) = @_;
    !$self->is_full() || die("Heap is full");

    # DEBUG
    print "Insert $item";

    # Start at next free leaf
    my $node_num = $self->_num_nodes;
    $self->{nodes}->[$node_num] = $item;
    $self->{item_indexes}->{$item} = $node_num;

    # Move up to appropriate level
    $self->_sift_up($node_num);

    print $self->printable;
}

# Returns true if the heap contains the item
sub contains {
    my ($self, $item) = @_;
    return exists($self->{item_indexes}->{$item});
}

# Returns the minimum value of the heap, after removing it
sub remove_min {
    my $self = shift;
    !$self->is_empty || die("Heap is empty");

    my $item = $self->{nodes}->[0];

    # Shift up last leaf
    $self->{nodes}->[0] = $self->{nodes}->[$self->_last_node];
    delete($self->{nodes}->[$self->_last_node]);

    # Move down to appropriate level
    $self->_sift_down(0);

    # Remove index for item
    delete($self->{item_indexes}->{$item});

    return $item;
}

# Returns the minimum value in the heap without removing it
sub peek {
    my $self = shift;
    !$self->is_empty || die("Heap is empty");
    return $self->{nodes}->[0];
}

# Returns a printable representation of the heap
sub printable {
    my $self = shift;

    return $self->_printable_node(0);
}

# Returns all items in the heap from min to max
sub all_items {
    my $self = shift;
    return @{$self->{nodes}};
}

# Move an item that is already in the heap to the correct position, after increasing its value
sub increase_value() {
    my($self, $item) = @_;
    $self->contains($item) || die("Item is not present in heap");
    # DEBUG
    print ("Increase value for $item\n");
    $self->_sift_up($self->{item_indexes}->{$item});
    print $self->printable;
}

# Helper functions

# Move a node up recursively to the appropriate position in the heap
sub _sift_up {
    my ($self, $node_num) = @_;

    if ($node_num == 0) {
        return;
    }

    my $parent = $self->_parent($node_num);
    if ($self->_compare($node_num, $parent) < 0) {
        $self->_swap($node_num, $parent);
        $self->_sift_up($parent);
    }
}

# Move a node down recursively to the appropriate position in the heap (
sub _sift_down {
    my ($self, $node_num) = @_;
    my $lowest = $node_num;

    if ($self->_has_left_child($node_num) && $self->_compare($self->_left_child($node_num), $lowest) < 0) {
        $lowest = $self->_left_child($node_num);
    }
    if ($self->_has_right_child($node_num) && $self->_compare($self->_right_child($node_num), $lowest) < 0) {
        $lowest = $self->_right_child($node_num);
    }
    if ($lowest != $node_num) {
        $self->_swap($node_num, $lowest);
        $self->_sift_down($lowest);
    }
}

# Return the number of nodes
sub _num_nodes {
    my $self = shift;

    return scalar @{$self->{nodes}};
}

# Return the index of the last node
sub _last_node {
    my $self = shift;

    return $self->_num_nodes - 1;
}

# Return the parent node number of a node
sub _parent {
    use integer;

    my $node_num = $_[1];

    return ($node_num + 1) / 2 - 1;
}

# Swap two nodes
# Takes two node numbers as arguments
sub _swap {
    my ($self, $node1, $node2) = @_;

    my $item1 = $self->{nodes}->[$node1];
    my $item2 = $self->{nodes}->[$node2];
    $self->{nodes}->[$node1] = $item2;
    $self->{nodes}->[$node2] = $item1;
    $self->{item_indexes}->{$item1} = $node2;
    $self->{item_indexes}->{$item2} = $node1
}

# Return the result of the comparator function on two nodes
# Takes two node numbers as arguments
sub _compare {
    my ($self, $node1, $node2) = @_;

    return $self->{comparator}->compare($self->{nodes}->[$node1],
        $self->{nodes}->[$node2]);
}

# Return the left child of a node
sub _left_child {
    my $node_num = $_[1];

    return 2 * ($node_num + 1) - 1;
}

# Return the right child of a node
sub _right_child {
    my $node_num = $_[1];

    return 2 * ($node_num + 1);
}

# Returns true if a node has a left child
sub _has_left_child {
    my ($self, $node_num) = @_;

    return $self->_left_child($node_num) < $self->_num_nodes;
}

# Return true if a node has a right child
sub _has_right_child {
    my ($self, $node_num) = @_;

    return $self->_right_child($node_num) < $self->_num_nodes;
}

# Return a printable representation of the heap below node #node_num
sub _printable_node {
    my ($self, $node_num) = @_;
    my $print = '(';

    $print .= $self->{nodes}->[$node_num];

    if ($self->_has_left_child($node_num)) {
        $print .= " L";
        $print .= $self->_printable_node($self->_left_child($node_num));
    }

    if ($self->_has_right_child($node_num)) {
        $print .= " R";
        $print .= $self->_printable_node($self->_right_child($node_num));
    }

    $print .= ')';

    return $print;
}


1;