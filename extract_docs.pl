##  extract_docs.pl
##
##  This Perl program reads through a .tsv file and extracts the keys in a has.  It then reads each line of the stories file
##  for those keys, if found, the story is printed to a new file until the doc is over.  As a result, the new file, called 
##  extracted.txt, contains only the stories from the .tsv file.
##
##  TO RUN PROGRAM:
##
##  perl extract_docs.pl
##
##
##  INPUT FILES:
##
##    DOCS : "stories.genfed"
##
##    TOP5: "coded_SS.tsv"
##
##  OUTPUT FILES:
##
##    FOUT : "extracted.txt"
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
#  $_[0] =~ s/\t/\ /; #remove tabs in string
  $_[0] =~ s/\r/\ /; #remove carriage return in string
  $_[0] =~ s/\n/\ /; #remove newline in string
  return $_[0];
}

###################
## globals

my %topKeys = ();
my $line = "";
my $k1 = 0;
my %keyPred = ();
my @vals = ();

####

open(DOCS,"stories.genfed")  or die "Can\'t open stories file; error $!";
open(TOP5,"top5percent.tsv")  or die "Can\'t open spreadsheet file; error $!";
open(FOUT,">top5percent.txt")  or die "Can\'t open output data file; error $!";

# establishing the hash of keys in the top five percent
while ($line = <TOP5>) {
  chomp($line);
  @vals = split("\t", $line);
  my $docID = &TrimString($vals[0]);
  $docID =~ s/\"//g;
  $topKeys{$docID} = 1;
}

while ($line = <DOCS>) {
  chomp($line);
  my $docKey = "";
  if ($line =~ m/Key\: /) {
    $docKey = $line;
    $docKey =~ s/Key\: //;
  }

  if (exists($topKeys{$docKey})) {
    print FOUT $line."\n";
    PRINT: while ($line = <DOCS>) {
      print FOUT $line;
      if ($line =~ m/----------------------------/) {last PRINT;}
    }
  }
}  


close(DOCS);
close(TOP5);
close(FOUT);

exit;




