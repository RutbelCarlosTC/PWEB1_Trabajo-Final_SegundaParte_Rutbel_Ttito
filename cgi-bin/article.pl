#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new; 
print $q->header(-type => "text/xml", -charset => "utf-8");
my $owner = $q->param("owner");
my $title = $q->param("title");

my $contenido;
if(defined($title) && defined($owner)){
  my $text =getText($title,$owner);
  if(defined($text)){
    my @campos = ("owner","title","text");
    my %xml = (
      $campos[0] =>$owner,
      $campos[1] =>$title,
      $campos[2] =>$text,
    );
    $contenido = renderContenido(\@campos,\%xml);
  }
}

printXML("article",$contenido);

sub getText{
  my ($title,$owner) = ($_[0],$_[1]);
  my $user = "alumno";
  my $paswd = "pweb1";
  my $dsn = "DBI:MariaDB:database=pweb1;host=localhost";
  my $dbh = DBI->connect($dsn, $user, $paswd) or die("No se pudo conectar!");

  my $sql = "SELECT Text FROM Articles WHERE Title=? AND Owner =?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($title,$owner);
  my @row = $sth->fetchrow_array; 
  my $text = $row[0]; 
  $sth->finish;
  $dbh->disconnect;
  return $text;
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

