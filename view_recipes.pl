#!/opt/plenv/shims/perl

use JSON;
use Data::Dumper;

open($in, "<", "recipes.json");
$recipes = from_json(<$in>);

my $i = 0;
for $recipe (@$recipes) {
	print "No.".++$i.":  ".$recipe->{title}."\n";
	map { print $_->{name}."[".$_->{amount}."] "; } @{$recipe->{ingredients}};
	print "\n";
	map { print "[".$_."] "; } @{$recipe->{tags}};
	print "\n";
	map { print "\t".$_."\n"; } @{$recipe->{processes}};
	print "\n\n";
}
