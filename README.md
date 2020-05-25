# Top 100 Phrases of Three Words

This is the solution to the following problem:

Your challenge, should you choose to accept it, is to write a program that meets the requirements listed below. Feel free to implement the program in the language of your choice (Go, Ruby, or Python are preferred if you're choosing between languages).

* The program accepts as arguments a list of one or more file paths (e.g. ./solution.rb file1.txt file2.txt ...).
* The program also accepts input on stdin (e.g. cat file1.txt | ./solution.rb).
* The program outputs a list of the 100 most common three word sequences in the text, along with a count of how many times each occurred in the text. For example: 231 - i will not, 116 - i do not, 105 - there is no, 54 - i know not, 37 - i am not …
* The program ignores punctuation, line endings, and is case insensitive (e.g. “I love\nsandwiches.” should be treated the same as "(I LOVE SANDWICHES!!)", and "fifty-fifth" should be treated the same as "fifty fifth")
* The program is capable of processing large files and runs as fast as possible.
* The program should be tested. Provide a test file for your solution or you can use "Moby Dick" at http://www.gutenberg.org/files/2701/2701-0.txt or "Origin Of Species" at  http://www.gutenberg.org/cache/epub/2009/pg2009.txt

My solution first tokenizes the text into single words.  It then processes one word at time, accumulating those into
phrases of three words and increments the count of each phrase, one a time.  I use a combination data structure to keep
track of the top 100 phrases.  This is a binary min-heap containing the top n items with an additional hash map
containing the index of each item in the heap.  Phrases are added to the heap one by one until it is full.  If a phrase
is already in the heap, its position in the heap is looked up in the map, and then its value is updated and the
sift-down method is invoked to move it to the correct new position.  If heap is full, each phrase is compared to the
minimum item in the heap.  If its count is greater, the minimum item is replaced with the new phrase, and the sift-down
method is invoked to move the newly added phrase to the correct position (and to maintain the heap property).  Once all
words in the text have been processed, all phrases are removed from the heap, and then the phrases and counts are
printed in reverse order (from highest count to lowest).

Under the covers, some of my code is more generic, and not specific to just this problem.  Once the text is broken
up into phrases, each phrase is fed into a generic top n items by frequency accumulator.  As far as this class is
concerned, each item is just an object with a count, and it does not know anything about phrases.  It just increments
the count for each item, and when all items are added, it return the top n, in terms of count.  Similarly, this uses
an indexed min-heap, which is more generic and not specific to the top n items by frequency problem.  This allowed me
to keep different pieces of my logic separate - for example the text processing aspects that break a text into phrases
is completely separate form logic that counts those phrases, and this made the code easier to test.

I implemented my solution in Perl, because it designed for this purpose (processing text files and matching patterns),
and it is one of the fastest scripting languages for this.  It has an easy means to read from a list of files, specified
on the command line or the standard input (if there are no arguments), and it supports POSIX character classes in its
regular expression implementation, a feature I used to find strings of alphanumeric characters (because I used a
POSIX character class, this should work with Unicode characters.) Had I been more familiar with the language and had
enough time, I might have attempted to rewrite this in Ruby, as it is a more modern language with many of the same
features.  Then I would have seen which implementation was faster.  (This would have been harder to write in a language
like Python that lacks some of features like reading a list of files, specified in the command line arguments and
support for POSIX character classes.)

This should be run on Perl 5.20 or later.  To run the program use the following command line in the root project
directory:

`perl bin/solution.pl`.

## Tests

I tested this program with the two texted in the links above, and it was able to process each one in about a second
on my machine.  I also tested it with the following German text to make sure it could process Unicdoe characters:

https://www.gutenberg.org/files/60360/60360-0.txt

I also wrote unit tests for various pieces of the code. To run the following command in the root project
directory:

`perl test/test.pl`

The tests require the Array::Compare CPAN module to be installed.