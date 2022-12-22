#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new();

print $q->header(-type => "text/xml", -charset => "utf-8");
my $userName = $q->param("userName");
my $password = $q->param("password");
my $firstName = $q->param("firstName");
my $lastName = $q->param("lastName");

if(defined($userName) && defined($password) && defined($firstName) && defined($lastName)){
  my $flag =registerUser($userName,$password,$firstName,$lastName);
  if(defined($flag)){
    my @campos = ("owner","firstName","lastName");
    my %xml = (
      $campos[0] =>$userName,
      $campos[1] =>$firstName,
      $campos[2] =>$lastName,
    );
    $contenido = renderContenido(\@campos,\%xml);
  }
}
printXML("user",$contenido);

sub registerUser{
  my $userName = $_[0];
  my $password = $_[1];
  my $lastName = $_[2];
  my $firstName = $_[3];

  my $user = "alumno";
  my $paswd = "pweb1";
  my $dsn = "DBI:MariaDB:database=pweb1;host=localhost";
  my $dbh = DBI->connect($dsn, $user, $paswd) or die("No se pudo conectar!");

  my $sql = "INSERT INTO Users (userName,password,firstName,lastName) VALUES (?,?,?,?)";
  my $sth = $dbh->prepare($sql);
  my $flag = $sth->execute($userName,$password,$lastName,$firstName);
  $sth->finish;
  $dbh->disconnect;
  return $flag;
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
