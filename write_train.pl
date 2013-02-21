##  write_train.pl
##
##  This Perl program reads through a coded .tsv file and extracts the keys.  It then hashes each line of the .dat file
##  for those keys, if found, the line from the .dat file is printed to a new file.  As a result, the new file, called 
##  train.dat, contains the representation of only the labeled observations.
##
##  TO RUN PROGRAM:
##
##  perl write_train.pl
##
##
##  INPUT FILES:
##
##    CODEDSS : "coded_SS.txt"
##
##    DAT: "svm_tfidf.dat"
##
##  OUTPUT FILES:
##
##    TRAIN : "train.dat"
##
##
##  ----------------------------------------------------------------------------------

#!/usr/local/bin/perl
use strict;
use warnings;

# list of subroutines: TrimString

####################
## subroutines

sub TrimString {
  $_[0] =~ s/^\s+//; #remove leading whites
  $_[0] =~ s/\s+$//; #remove trailing spaces
  $_[0] =~ s/\t/\ /; #remove tabs in string
  $_[0] =~ s/\r/\ /; #remove carriage return in string
  $_[0] =~ s/\n/\ /; #remove newline in string
  return $_[0];
}

###################
## globals

my %labeled = ();
my $line = "";

####

open(CODEDSS,"coded_SS.txt")  or die "Can\'t open labeled spreadsheet file; error $!";
open(DAT,"svm_tfidf.dat")  or die "Can\'t open SVM Light data file; error $!";
open(TRAIN,">train.dat")  or die "Can\'t open output data file; error $!";

# establishing the hash of labeled keys
while ($line = <CODEDSS>) {
  my @vals = split("\t", $line);
  my $docID = &TrimString($vals[0]);
  $labeled{$docID} = 1;
}

#my $keyTest = "";
#my $valTest = "";
#open(TEMP, ">temp.txt");
#while (($keyTest, $valTest) = each(%labeled)){
#     print TEMP "$keyTest,$valTest\n";
#}
#close(TEMP);

while ($line = <DAT>) {
  chomp($line);
  my @vals = split("\t", $line);
  my $docID = &TrimString($vals[$#vals]);
  $docID =~ s/\#//;
  $docID = &TrimString($docID);
  
  if(exists($labeled{$docID})) {
    print TRAIN $line."\n";
  }
}


close(CODEDSS);
close(DAT);
close(TRAIN);

exit;


