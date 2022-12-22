#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new();
print $q->header(-type => "text/xml", -charset => "utf-8");
my $user = $q->param("user");
my $password = $q->param("password");

my $contenido;
if(defined($user) && defined($password)){
  my @info = loginUser($user,$password);
  if(@info){
    my @campos = ("owner","firstName","lastName");
    my %xml = (
      $campos[0] =>$info[0],
      $campos[1] =>$info[1],
      $campos[2] =>$info[2],
    );
    $contenido = renderContenido(\@campos,\%xml);
  }
}
printXML("user",$contenido);

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
sub printXML{
  my $principal = $_[0];
  my $contenido  = $_[1];
  print "<$principal>\n";
  if(defined($contenido)){
    print $contenido;
  }
  print "</$principal>\n";
}
sub renderContenido{
  my @claves =@{$_[0]};
  my %campos =%{$_[1]};
  my $str = "";
  foreach my $key (@claves){
    $str .= "  <$key>".$campos{$key}."</$key>\n";
  }
  return $str;
} 
