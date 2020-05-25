# A binary min-heap that also keeps the array index of each item in an associated map
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

# Insert an element to the heap
sub insert {
    my ($self, $element) = @_;
    !$self->is_full() || die("Heap is full");

    # Start at next free leaf
    my $nodeNum = $self->numNodes;
    $self->{nodes}->[$nodeNum] = $element;
    $self->{item_indexes}->{$element} = $nodeNum;

    # Move up to appropriate level
    $self->siftUp($nodeNum);
}

# Returns true if the heap contains the item
sub contains {
    my ($self, $item) = @_;
    return exists($self->{heap_indexes}->{$item});
}

# Remove the top node and return it
sub remove {
    my $self = shift;
    my $item = $self->{nodes}->[0];

    # Shift up last leaf
    $self->{nodes}->[0] = $self->{nodes}->[$self->lastNode];
    delete($self->{nodes}->[$self->lastNode]);

    # Move down to appropriate level
    $self->siftDown(0);

    # Remove index for item
    delete($self->{item_indexes}->{$item});

    return $item;
}

# Returns a printable representation of the heap
sub printable {
    my $self = shift;

    return $self->printable_node(0);
}

# Helper functions

# Move a node up recursively to the appropriate position in the heap
sub siftUp {
    my ($self, $nodeNum) = @_;

    if ($nodeNum == 0) {
        return;
    }

    my $parent = $self->parent($nodeNum);
    if ($self->compare($nodeNum, $parent) < 0) {
        $self->swap($nodeNum, $parent);
        $self->siftUp($parent);
    }
}

# Move a node down recursively to the appropriate position in the heap (
sub siftDown {
    my ($self, $nodeNum) = @_;
    my $lowest = $nodeNum;

    if ($self->hasLeftChild($nodeNum) && $self->compare($self->leftChild($nodeNum), $lowest) < 0) {
        $lowest = $self->leftChild($nodeNum);
    }
    if ($self->hasRightChild($nodeNum) && $self->compare($self->rightChild($nodeNum), $lowest) < 0) {
        $lowest = $self->rightChild($nodeNum);
    }
    if ($lowest != $nodeNum) {
        $self->swap($nodeNum, $lowest);
        $self->siftDown($lowest);
    }
}

# Return the number of nodes
sub numNodes {
    my $self = shift;

    return scalar @{$self->{nodes}};
}

# Return the index of the last node
sub lastNode {
    my $self = shift;

    return $self->numNodes - 1;
}

# Return the parent node number of a node
sub parent {
    use integer;

    my $nodeNum = $_[1];

    return ($nodeNum + 1) / 2 - 1;
}

# Swap two nodes
# Takes two node numbers as arguments
sub swap {
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
sub compare {
    my ($self, $node1, $node2) = @_;

    return $self->{comparator}->compare($self->{nodes}->[$node1],
        $self->{nodes}->[$node2]);
}

# Return the left child of a node
sub leftChild {
    my $nodeNum = $_[1];

    return 2 * ($nodeNum + 1) - 1;
}

# Return the right child of a node
sub rightChild {
    my $nodeNum = $_[1];

    return 2 * ($nodeNum + 1);
}

# Returns true if a node has a left child
sub hasLeftChild {
    my ($self, $nodeNum) = @_;

    return $self->leftChild($nodeNum) < $self->numNodes;
}

# Return true if a node has a right child
sub hasRightChild {
    my ($self, $nodeNum) = @_;

    return $self->rightChild($nodeNum) < $self->numNodes;
}

# Return a printable representation of the heap below node #nodeNum
sub printable_node {
    my ($self, $nodeNum) = @_;
    my $print = '(';

    $print .= $self->{nodes}->[$nodeNum];

    if ($self->hasLeftChild($nodeNum)) {
        $print .= " L";
        $print .= $self->printable_node($self->leftChild($nodeNum));
    }

    if ($self->hasRightChild($nodeNum)) {
        $print .= " R";
        $print .= $self->printable_node($self->rightChild($nodeNum));
    }

    $print .= ')';

    return $print;
}


1;