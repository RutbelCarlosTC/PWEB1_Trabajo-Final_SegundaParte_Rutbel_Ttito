#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q=CGI->new();
print $q->header(-type => "text/html", -charset => "utf-8");
my $owner = $q->param("owner");
my $title = $q->param("title");

my @types = (
  {
    regex => '^\s{0,3}# (.*$)',
    tag => 'h1'
  },
  {
    regex => '^\s{0,3}## (.*$)',
    tag => 'h2'
  },
  {
    regex => '^\s{0,3}### (.*$)',
    tag => 'h3'
  },
  {
    regex => '^\s{0,3}##### (.*$)',
    tag => 'h4'
  },
  {
    regex => '^\s{0,3}##### (.*$)',
    tag => 'h5'
  },
  {
    regex => '^\s{0,3}###### (.*$)',
    tag => 'h6'
  },
  {
    regex => '\*\*\*(.+)\*\*\*',
    tag => 'b'
  },
  {
    regex => '\*\*(.+)\*\*',
    tag => 'strong'
  },
  {
    regex => '\*(.+)\*',
    tag => 'em'
  },
  {
    regex => '_(.+)_',
    tag => 'em'
  },

  {
    regex => '~~(.+)~~',
    tag => 'del'
  },
  {
    regex=> '\[(.+)\]\((.+)\)',
    tag=> 'a'
  },
  {
    regex => '```([\s\S.]+)```',
    tag => 'code'
  },
  {
    regex => '(((?:^[^<])|(?:<(?:b|strong|del|em)>)).+((?:[^>]$)|(?:<\/(?:b|strong|del|em)>)))',
    tag => 'p'
  }
 );
