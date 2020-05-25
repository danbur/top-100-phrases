# Phrase processor - this class consumes one word at a time and processes every phrase of length n words, using a
# provided processing function
package PhraseProcessor;
use strict;
use warnings FATAL => 'all';
use English;
use ItemValue;

sub new {
    my ($class, $phrase_length, $process_function) = @ARG;
    my $self = { 'current_phrase' => [], 'phrase_length' => $phrase_length, 'process_function' => $process_function };
    return bless $self, $class;
}

sub add_word {
    my ($self, $word) = @ARG;
    # If the current phrase is already the desired length, discard the first word
    if (@{$self->{current_phrase}} == $self->{phrase_length}) {
        shift @{$self->{current_phrase}};
    }
    # Add the next word
    push @{$self->{current_phrase}}, $word;
    # If we have reached the desired length, concatenate the words and process the phrase
    if (@{$self->{current_phrase}} == $self->{phrase_length}) {
        $self->{process_function}->(join(' ', @{$self->{current_phrase}}));
    }
}

1;