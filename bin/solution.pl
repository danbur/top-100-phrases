#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use English;
use FindBin;
use open ':locale';
use lib "$FindBin::Bin/../lib";
use LineProcessor;
use TopNPhrasesAccumulator;

my $accumulator = TopNPhrasesAccumulator->new(3, 100);
my $line_processor = LineProcessor->new(sub {$accumulator->add_word($ARG[0])});

while (<>) {
    $line_processor->process_line($ARG);
}

for my $item_count ($accumulator->get_top_phrases()) {
    print $item_count->value, ' - ', $item_count->item, "\n";
}