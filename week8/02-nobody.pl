#! usr/bin/env perl
use strict;
use warnings;
use feature 'say';

my $name;
if(scalar @ARGV < 1){
    $name="George";
}
else{
    $name = shift @ARGV
}

while(my $line = <DATA>){
    chomp $line;
    $line =~ s/Nobody/$name/;
    say $line;
}

__DATA__
Nobody by Shel Silverstein
Nobody loves me,
Nobody cares,
Nobody picks me peaches and pears.
Nobody offers me candy and Cokes,
Nobody listens and laughs at me jokes.
Nobody helps when I get in a fight,
Nobody does all my homework at night.
Nobody misses me,
Nobody cries,
Nobody thinks I'm a wonderful guy.
So if you ask me who's my best friend, in a whiz,
I'll stand up and tell you that Nobody is.
But yesterday night I got quite a scare,
I woke up and Nobody just wasn't there.
I called out and reached out for Nobody's hand,
In the darkness where Nobody usually stands.
Then I poked through the house, in each cranny and nook,
But I found somebody each place that I looked.
I searched till I'm tired, and now with the dawn,
There's no doubt about it-
Nobody's gone!
