#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new();
print $q->header(-type => "text/xml", -charset => "utf-8");
my $user = $q->param("user");
my $password = $q->param("password");


sub loginUser{
  my $userQuery = $_[0];
  my $passwordQuery = $_[1];

  my $user = "alumno";
  my $password = "pweb1";
  my $dsn = "DBI:MariaDB:database=pweb1;host=localhost";
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

  my $sql = "SELECT UserName,firstName,lastName FROM Users WHERE userName=? AND password=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($userQuery, $passwordQuery);
  my @row = $sth->fetchrow_array;
  $sth->finish;
  $dbh->disconnect;
  return @row;
}
