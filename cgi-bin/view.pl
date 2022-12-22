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
 my $body = " "; 
my $text = getText($title,$owner);
if($text){
  $body = translate(@types,$text);
}
print $body."\n";

sub getText{
  my $title = $_[0];
  my $owner = $_[1];
  my ($user,$password,$dsn) = ('alumno','pweb1',"DBI:MariaDB:database=pweb1;host=localhost");
  my $dbh = DBI->connect($dsn,$user,$password) or die ("No se pudo conectar!");
  my $sth = $dbh->prepare("SELECT text FROM Articles WHERE title = ? AND owner =?");
  $sth->execute($title,$owner);
  my @row = $sth->fetchrow_array;
  my $text = $row[0];
  $sth->finish;
  $dbh->disconnect;
  return $text;
}
sub translate{
  my $str=pop(@_);
  my @types = @_;

  foreach my $type (@types){
    my $tag = $type->{tag};
    my $regex = $type->{regex};

    if($tag eq 'a'){
        $str =~ s/$regex/<p><$tag href="$2">$1<\/$tag><\/p>/gm;
    }
    else{
        $str =~ s/$regex/<$tag>$1<\/$tag>/gm;
    }
  }
  return $str;
}

