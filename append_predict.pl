##  append_predict.pl
##
##  This Perl program reads through two files, each with unique keys.  It is checking to see how many keys the files have in common.
##
##  TO RUN PROGRAM:
##
##  perl append_predict.pl
##
##
##
##---------------------------------------------------------------------------------

#!/usr/local/bin/perl
use strict;
use warnings;

# list of subroutines: TrimString

####################
## subroutines

sub TrimString {
  $_[0] =~ s/^\s+//; #remove leading whites
  $_[0] =~ s/\s+$//; #remove trailing spaces
#  $_[0] =~ s/\t/\ /; #remove tabs in string
  $_[0] =~ s/\r/\ /; #remove carriage return in string
  $_[0] =~ s/\n/\ /; #remove newline in string
  return $_[0];
}

###################
## globals

my %key1 = ();
my $line = "";
my $k1 = 0;
my @vals = ();

####

open(IN1,"top5keys.txt")  or die "Can\'t open labeled spreadsheet file; error $!";
open(IN2,"static_12837.tsv")  or die "Can\'t open SVM Light data file; error $!";


# establishing the hash of keys for the first file
while ($line = <IN1>) {
  $line = &TrimString($line);
  $key1{$line} = 1;
}

$k1 = 0;
while ($line = <DAT>) {
  chomp($line);
  @vals = split("\t", $line);
  my $docID = &TrimString($vals[$#vals]);
  $docID =~ s/\#//;
  $docID = &TrimString($docID);
  print FOUT $docID."\t".$preds{$k1}."\n";
  ++$k1;
}


close(PREDS);
close(DAT);
close(FOUT);

exit;
#############################

open(KEYPRED, "key_pred.dat") or die "Can\'t open key and prediction file; error $!";
open(SSIN, "spreadsheet.tsv") or die "Can\'t open spreadsheet file; error $!"; 
open(SSOUT, ">pred_summary.tsv") or die "Can\'t open output spreadsheet file; error $!"; 
open(NOKEY, ">noKey.tsv") or die "Can\'t open output spreadsheet file; error $!"; 

# establish the hash from key_pred.dat which was just written
while ($line = <KEYPRED>) {
  @vals = split("\t", $line);
  $keyPred{$vals[0]} = $vals[1];
}

# loop and write
while ($line = <SSIN>) {
  chomp($line);
  @vals = split("\t", $line);
  my $docID = &TrimString($vals[0]);
  $line = &TrimString($line);
  if(exists($keyPred{$docID})) {
    print SSOUT $line."\t".$keyPred{$docID};
  }
  else {
    print NOKEY $line."\n";
  }
}

close(KEYPRED);
close(SSIN);
close(SSOUT);

exit;


