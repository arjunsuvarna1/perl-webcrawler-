#!/usr/bin/perl

use Modern::Perl;
use WWW::Mechanize;

my $root = 'http://stackoverflow.com';
my $domain = 'http://stackoverflow';
my $mech = WWW::Mechanize->new;

sub visit {
    my $url = shift;
    my $indent = shift || 0;
    my $visited = shift || {};
    my $tab = ' ' x $indent;

    # Already seen that.
    return if $visited->{$url}++;

    # Leaves domain.
    if ($url !~ /^$domain/) {
        $rootdom = $url
        $rootdom =~ s/www\.(.*\.(?:net|org|com)).*/$1/; 
        print $rootdom
        say $tab, "-> $url";
        return;
    }
    
    # Not seen yet.
    $rootdom = $url
        $rootdom =~ s/www\.(.*\.(?:net|org|com)).*/$1/; 
        print $rootdom
    say $tab, "- $url ";
    $mech->get($url);
    visit($_, $indent+2, $visited) for
        map {$_->url_abs} $mech->links;
}

visit($root);