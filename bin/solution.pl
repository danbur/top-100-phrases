#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use English;
use FindBin;
use lib "$FindBin::Bin/../lib";
use TopNPhrasesAccumulator;
use Data::Dumper;

my $accumulator = TopNPhrasesAccumulator->new(3, 100);

while (<>) {
    while (/[[:alnum:]]+/g) {
        $accumulator->add_word(lc($MATCH));
    }
}

for my $item_count ($accumulator->get_top_phrases()) {
    print $item_count->value, ' - ', $item_count->item, "\n";
}