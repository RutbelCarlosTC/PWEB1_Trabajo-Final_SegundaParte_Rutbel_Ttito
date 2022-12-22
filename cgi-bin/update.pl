#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new; 
print $q->header(-type => "text/xml", -charset => "utf-8");
my $title = $q->param("title");
my $text = $q->param("text");
my $owner = $q->param("owner");


sub actualizarArticulo{
  my ($title,$text,$owner) = ($_[0],$_[1],$_[2]);
  my $user = 'alumno';
  my $paswd = 'pweb1';
  my $dsn = 'DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $paswd) or die("No se pudo conectar!");

  my $sql = "UPDATE Articles SET Text =? WHERE Title=? AND Owner =?";
  my $sth = $dbh->prepare($sql);
  my $flag = $sth->execute($text,$title,$owner);
  $sth->finish;
  $dbh->disconnect;
  return $flag;
}
