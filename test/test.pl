#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use English;
use utf8;
use open ':locale';
use FindBin;
use lib "$FindBin::Bin/../lib";
use LineProcessor;
use PhraseProcessor;
use IndexedMinHeap;
use Array::Compare;
use Comparator::Num;
use TopNItemsByFrequencyAccumulator;
use TopNPhrasesAccumulator;
use Test::Simple tests => 11;

my $array_comparator = Array::Compare->new;

sub test_line_processor() {
    my @words;
    my $line_processor = LineProcessor->new(sub {push @words, $ARG[0]});
    $line_processor->process_line("Don't let the dogs out/1234.\nabc ABC");
    my @expected_words = qw(don t let the dogs out 1234 abc abc);
    return $array_comparator->compare(\@words, \@expected_words);
}

sub test_line_processor_unicde() {
    my @words;
    my $line_processor = LineProcessor->new(sub {push @words, $ARG[0]});
    $line_processor->process_line("gestattet und so durch die Änderung der äußeren Form das Eindringen");
    my @expected_words = qw(gestattet und so durch die änderung der äußeren form das eindringen);
    return $array_comparator->compare(\@words, \@expected_words);
}

sub test_phrase_processor {
    my @phrases;
    my $phrase_processor = PhraseProcessor->new(3, sub {push @phrases, $ARG[0]});
    $phrase_processor->add_word('the');
    $phrase_processor->add_word('quick');
    $phrase_processor->add_word('brown');
    $phrase_processor->add_word('fox');
    $phrase_processor->add_word('jumps');
    $phrase_processor->add_word('over');
    $phrase_processor->add_word('the');
    my @expected_phrases =
        ('the quick brown', 'quick brown fox', 'brown fox jumps', 'fox jumps over', 'jumps over the');
    return $array_comparator->compare(\@phrases, \@expected_phrases);
}

sub test_indexed_min_heap_is_empty {
    my $heap = IndexedMinHeap->new(999, Comparator::Num->new);
    return $heap->is_empty();
}


sub test_indexed_min_heap_ordering {
    my $heap = IndexedMinHeap->new(5, Comparator::Num->new);
    $heap->insert("a", 8);
    $heap->insert("b", 1);
    $heap->insert("c", -1);
    $heap->insert("d", 11);
    $heap->insert("e", 52);
    my @items;
    my @values;
    while (!$heap->is_empty()) {
        my $item_value = $heap->remove_min();
        push @items, $item_value->item;
        push @values, $item_value->value;
    }
    my @expected_items = qw(c b a d e);
    my @expected_values = (-1, 1, 8, 11, 52);
    return $array_comparator->compare(\@items, \@expected_items) &&
        $array_comparator->compare(\@values, \@expected_values);
}

sub test_indexed_min_heap_is_full {
    my $heap = IndexedMinHeap->new(3, Comparator::Num->new);
    $heap->insert("a", 8);
    $heap->insert("b", 1);
    $heap->insert("c", -1);
    return $heap->is_full();
}

sub test_indexed_min_heap_contains {
    my $heap = IndexedMinHeap->new(3, Comparator::Num->new);
    $heap->insert("a", 8);
    $heap->insert("b", 1);
    $heap->insert("c", -1);
    return $heap->contains("b") && !$heap->contains("d");
}

sub test_indexed_min_heap_peek {
    my $heap = IndexedMinHeap->new(3, Comparator::Num->new);
    $heap->insert("a", 8);
    $heap->insert("b", 1);
    $heap->insert("c", -1);
    # Peek
    my $item_value = $heap->peek();
    return $item_value->item eq "c" && $item_value->value == -1 && $heap->is_full();
}

sub test_indexed_min_heap_replace_min {
    my $heap = IndexedMinHeap->new(5, Comparator::Num->new);
    $heap->insert("a", 8);
    $heap->insert("b", 1);
    $heap->insert("c", -1);
    $heap->insert("d", 11);
    $heap->insert("e", 52);
    $heap->replace_min("f", 12);
    my @items;
    my @values;
    while (!$heap->is_empty()) {
        my $item_value = $heap->remove_min();
        push @items, $item_value->item;
        push @values, $item_value->value;
    }
    my @expected_items = qw(b a d f e);
    my @expected_values = (1, 8, 11, 12, 52);
    return $array_comparator->compare(\@items, \@expected_items) &&
        $array_comparator->compare(\@values, \@expected_values);
}

sub test_top_n_items_by_frequency_accumulator() {
    my $accumulator = TopNItemsByFrequencyAccumulator->new(5);
    my %first_pass = (
        'a' => 2,
        'b' => 4,
        'c' => 5,
        'd' => 6,
        'e' => 10,
        'f' => 11,
        'g' => 1,
        'h' => 33,
        'i' => 3,
        'j' => 4,
        'k' => 3,
    );
    increment_item_counts($accumulator, \%first_pass);
    my %second_pass = (
        'a' => 8,
        'b' => 1,
        'c' => 15,
        'd' => 1,
        'e' => 1,
        'f' => 3,
        'g' => 44,
        'h' => 11,
        'i' => 1,
        'j' => 4,
        'k' => 5,
    );
    increment_item_counts($accumulator, \%second_pass);
    # Total counts after both passes
    # a: 10
    # b: 5
    # c: 20
    # d: 7
    # e: 11
    # f: 14
    # g: 45
    # h: 44
    # i: 4
    # j: 8
    # k: 8
    my @expected_items = qw(g h c f e);
    my @expected_counts = (45, 44, 20, 14, 11);
    my @item_counts = $accumulator->get_top_items();
    my @items = map {$ARG->item} @item_counts;
    my @counts = map {$ARG->value} @item_counts;
    return $array_comparator->compare(\@items, \@expected_items) &&
        $array_comparator->compare(\@counts, \@expected_counts);
}

sub increment_item_counts {
    my ($accumulator, $frequency_map) = @ARG;
    while (my ($item, $count) = each %$frequency_map) {
        for (1 .. $count) {
            $accumulator->increment_count($item);
        }
    }
}

sub test_top_n_phrases_accumulator() {
    my @text = qw(the quick brown fox jumped over the lazy dogs jumped over the lazy fox and rocks and the dogs jumped
        over and over with 3 bees in the trees watching the fox jumped over the birds in the trees the quick birds so
        quick are they watching the stars and rocks);
    my $accumulator = TopNPhrasesAccumulator->new(2, 10);
    for my $word (@text) {
        $accumulator->add_word($word);
    }
    # These should be the word counts after adding this text:
    # 3 bees: 1
    # and rocks: 2
    # and the: 1
    # and over: 1
    # are they: 1
    # birds in: 1
    # birds so: 1
    # bees in: 1
    # brown fox: 1
    # dogs jumped: 2
    # fox jumped: 2
    # fox and: 1
    # in the: 2
    # jumped over: 4
    # lazy dogs: 1
    # lazy fox: 1
    # over and: 1
    # over the: 3
    # over with: 1
    # quick are: 1
    # quick birds: 1
    # quick brown: 1
    # rocks and: 1
    # so quick: 1
    # stars and: 1
    # the birds: 1
    # the dogs: 1
    # the fox: 1
    # the lazy: 2
    # the quick: 2
    # the stars: 1
    # the trees: 2
    # trees the: 1
    # they watching: 1
    # trees watching: 1
    # watching the: 2
    # with 3: 1
    my @phrase_counts = $accumulator->get_top_phrases();
    my @phrases = map {$ARG->item} @phrase_counts;
    my @counts = map {$ARG->value} @phrase_counts;
    my @phrases_with_count_2 =
        ('and rocks', 'dogs jumped', 'fox jumped', 'in the', 'the lazy', 'the quick', 'the trees', 'watching the');
    return $phrases[0] eq 'jumped over' && $counts[0] == 4 &&
        $phrases[1] eq 'over the' && $counts[1] == 3 &&
        $array_comparator->perm([ @phrases[2 .. 9] ], \@phrases_with_count_2) &&
        $array_comparator->compare([ @counts[2 .. 9] ], [ (2) x 8 ])
}

ok(test_line_processor(), 'Line processor can parse words correctly');
ok(test_line_processor_unicde(), 'Line processor can parse words with non-ASCII Unicode characters');
ok(test_phrase_processor(), 'Phrase processor accumulates words properly');
ok(test_indexed_min_heap_is_empty(), 'Indexed min heap is_empty() works');
ok(test_indexed_min_heap_ordering(), 'Indexed min heap orders items correctly');
ok(test_indexed_min_heap_is_full(), 'Indexed min heap is_full() works');
ok(test_indexed_min_heap_contains(), 'Indexed min heap contains() works');
ok(test_indexed_min_heap_peek(), 'Indexed min heap peek() works');
ok(test_indexed_min_heap_replace_min(), 'Indexed min heap replace_min() works');
ok(test_top_n_items_by_frequency_accumulator(), 'Top n items by frequency accumulator works');
ok(test_top_n_phrases_accumulator(), 'Top n phrases accumulator works')
