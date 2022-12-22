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

my $contenido;
if(defined($title) && defined($owner)){
  my $flag =actualizarArticulo($title,$text,$owner);
  if($flag !=0){
    my @campos = ("title","text");
    my %xml = (
      $campos[0] =>$title,
      $campos[1] =>$text,
    );
    $contenido = renderContenido(\@campos,\%xml);
  }
}

printXML("article",$contenido);

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


