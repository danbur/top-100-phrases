# Processes a line of text, parses it into words, and calls a provided function for each word
package LineProcessor;
use strict;
use warnings FATAL => 'all';
use English;
use utf8;

# Constructor
# Takes one argument - the word function
sub new {
    my ($class, $word_function) = @ARG;
    return bless { 'word_function' => $word_function }, $class
}

# Process the line of text and call the word function on each word
sub process_line() {
    my($self, $line)= @ARG;

    while ($line =~ /[[:alnum:]]+/g) {
        my $word = lc($MATCH);
        $self->{word_function}->($word);
    }
}

1;