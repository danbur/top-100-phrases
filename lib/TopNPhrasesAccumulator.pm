# Top n phrases accumulator - takes one word at a time as input and produces a list of the top n phrases with the
# highest frequency, for the provided phrase length
package TopNPhrasesAccumulator;
use strict;
use warnings FATAL => 'all';
use English;
use PhraseProcessor;
use TopNItemsByFrequencyAccumulator;

# Constructor
#
# Takes two arguments
#   phrase_length - The phrase length in number of words
#   count - The number of phrases desired (this will be the number returned by the get_top_phrases method)
sub new {
    my ($class, $phrase_length, $count) = @ARG;
    my $accumulator = TopNItemsByFrequencyAccumulator->new($count);
    my $self = {
        'top_items_accumulator' => $accumulator,
        'phrase_processor' => PhraseProcessor->new($phrase_length, sub {$accumulator->increment_count($ARG[0])})
    };
    return bless $self, $class;
}

# Adds a word to the text
sub add_word {
    my ($self, $word) = @ARG;
    $self->{phrase_processor}->add_word($word);
}

# Returns the top n phrases in terms of frequency, from the most to least frequent
# If there are less than n phrases, this will return all of them
# This a destructive operation - it can only be called once, as it removes all items from the underlying heap
sub get_top_phrases {
    my $self = shift;
    return $self->{top_items_accumulator}->get_top_items();
}

1;