#!/usr/bin/perl

use Modern::Perl;
use WWW::Mechanize;
use Domain::PublicSuffix qw( );
use URI                  qw( );

my $root = 'https://stackoverflow.com';
my $domain = 'https://stackoverflow.com';
my $mech = WWW::Mechanize->new;
sub root_domain {
   my ($domain) = @_;
   state $parser = Domain::PublicSuffix->new();
   return $parser->get_root_domain($domain);
}

# Accepts urls as strings and as URI objects.
sub url_root_domain {
   my ($abs_url) = @_;
   my $domain = URI->new($abs_url)->host();
   return root_domain($domain);
}
open my $fh, '>', "links.txt";
sub visit {
    my $url = shift;
    my $indent = shift || 0;
    my $visited = shift || {};
    my $tab = ' ' x $indent;
    # Already seen that.
    return if $visited->{$url}++;

    # Leaves domain.
    if ($url !~ /^$domain/) {
        say url_root_domain($url);
        print $fh "$url \n";
        return; 
    }
    
    # Not seen yet.
    print $domain;
     print $fh "$url \n";
    $mech->get($url);
    visit($_, $indent+2, $visited) for
        map {$_->url_abs} $mech->links;
        
}

visit($root);