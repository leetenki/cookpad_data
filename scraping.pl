#!/opt/plenv/shims/perl

use strict;
use warnings;
use LWP::UserAgent;
use HTML::TagParser;
use Data::Dumper;
use utf8;
use JSON;

my $ua = LWP::UserAgent->new;
$ua->agent('Chrome/50.0.2661.94 ');

my $recipes = load_json();
for(my $recipe_id = 1015000; $recipe_id < 2000000; $recipe_id++) {
	# send request
	my $req = HTTP::Request->new(GET => "http://cookpad.com/recipe/".$recipe_id);
	my $res = $ua->request($req);

	#parse
	my $html = HTML::TagParser->new($res->content);
	my $not_found = $html->getElementById("not_found");

	my $recipe = {
		title => "",
		ingredients => [],
		processes => [],
		tags => []
	};

	print "No.".$recipe_id." ";
	unless($not_found) {
		print "found\n";

		# タイトル抽出
		$recipe->{title} = $html->getElementsByClassName("recipe-title fn clearfix")->innerText;

		# 食材抽出
		my @names = $html->getElementsByClassName("ingredient_name");
		my @amounts = $html->getElementsByClassName("ingredient_quantity amount");
		for(my $i = 0; $i <= $#amounts; $i++) {
			push(@{$recipe->{ingredients}}, {
				name => $names[$i]->innerText,
				amount => $amounts[$i]->innerText
			});
		}

		# 調理手順抽出
		my @steps = $html->getElementsByClassName("step_text");
		for(my $i = 0; $i <= $#steps; $i++) {
			push(@{$recipe->{processes}}, $steps[$i]->innerText);
		}

		# タグ抽出
		my @genre = $html->getElementsByClassName("track_hakari");
		for(my $i = 0; $i <= $#genre; $i++) {
			push(@{$recipe->{tags}}, $genre[$i]->innerText);
		}

		# push
		push(@$recipes, $recipe);
	} else {	
		print " not found\n";
	}

	# save json to file
	unless($recipe_id % 100) {
		save_json($recipes);
	}
}

sub save_json {
	open(my $out, ">", "recipes.json");
	my $json_str = to_json(shift);
	print $out $json_str;
	close($out);
}

sub load_json {
	open(my $in, "<", "recipes.json");
	my $json = from_json(<$in>);
	return $json;
}

