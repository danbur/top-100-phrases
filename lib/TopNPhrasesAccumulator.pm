# Top n phrases accumulator - takes one word at a time as input and produces a list of the top n phrases with the
# highest frequency, for the provided phrase length
package TopNPhrasesAccumulator;
use strict;
use warnings FATAL => 'all';
use PhraseProcessor;
use TopNItemsByFrequencyAccumulator;

# Constructor
#
# Takes two arguments
#   phrase_length - The phrase length in number of words
#   count - The number of phrases desired (this will be the number returned by the get_top_phrases method)
sub new {
    my ($class, $phrase_length, $count) = @_;
    my $accumulator = TopNItemsByFrequencyAccumulator->new($count);
    my $process_function = sub {
        my $phrase = shift;
        $accumulator->increment_count($phrase);
    };
    my $self = {
        'top_items_accumulator' => $accumulator,
        'phrase_processor' => PhraseProcessor->new($phrase_length, $process_function)
    };
    return bless $self, $class;
}

# Adds a word to the text
sub add_word {
    my ($self, $word) = @_;
    $self->{phrase_processor}->add_word($word);
}

# Returns the top n phrases in terms of frequency, from the most to least frequent
sub get_top_phrases {
    my $self = shift;
    return $self->{top_items_accumulator}->get_top_items();
}

1;