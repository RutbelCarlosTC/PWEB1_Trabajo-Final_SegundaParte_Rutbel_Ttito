#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new();
print $q->header(-type => "text/xml", -charset => "utf-8");
my $owner = $q->param("owner");

my $contenido;
if(defined($owner)){
  my @articulos =getArticulos($owner);
  if(@articulos){
    $contenido = renderContenido(\@articulos,$owner);
  }
}
print renderXML("articles",$contenido);

sub getArticulos{
  my $owner = $_[0];
  my $user = 'alumno';
  my $paswd = 'pweb1';
  my $dsn = 'DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $paswd) or die("No se pudo conectar!");

  my $sql = "SELECT Title FROM Articles WHERE owner = ?";

  my $sth = $dbh->prepare($sql);
  $sth->execute($owner);
  my @articulos=();
  while(my @row = $sth->fetchrow_array){
    push(@articulos,$row[0]);
  }
  $sth->finish;
  $dbh->disconnect;
  return @articulos;
}
sub renderXML{
  my $principal = $_[0];
  my $contenido  = $_[1];
  my $xml="";
  $xml .= "<$principal>\n";
  if(defined($contenido)){
    $xml .= $contenido;
  }
  $xml .= "</$principal>\n";
}
sub renderContenido{
  my @titulos =@{$_[0]};
  my $owner =$_[1];
  my $str = "";
  foreach my $titulo (@titulos){
    my $arti = "  <article>\n";
    $arti .= "    <owner>".$owner."</owner>\n";
    $arti .= "    <title>".$titulo."</title>\n";
    $arti .= "  </article>\n";
    $str .= $arti;
  }
  return $str;
}
