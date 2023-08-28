use strict; # restrict unsafe construct
use warnings; # control optional warnings

use File::Copy;

$|=1; # output any data immediately, without buffering

sub main {
    my $dir_base = '/home/user/Downloads/ps1';
    my $dir = $dir_base;
    $dir =~ s/ps1/ps1\/chd/;

    foreach my $fp (glob("$dir_base/*.7z")) {
        my $fp_base = $fp;
        $fp =~ s/ps1/ps1\/chd/;
        printf "%s\n", $fp;
        system("cp",$fp_base,$fp);
        my $dir_7z = "-o";
        $dir_7z .= $dir;
        $dir_7z .= "/";
        print $dir_7z;
        system("7z","x",$fp,$dir_7z);#"*.7z");
        system("rm",$fp);
        #my $cmd = 'for i in *.cue; do chdman createcd -i "$i" -o "${i%cue}chd";';
        foreach my $fp_cue (glob("$dir/*.cue")) {

            my $fp_chd = $fp_cue;
            $fp_chd =~ s/cue/chd/;
            system("chdman","createcd","-f","-i",$fp_cue,"-o",$fp_chd);

            opendir(DIR, $dir) or die $!;

            while (my $file = readdir(DIR)) {

                # We only want files
                next unless (-f "$dir/$file");

                # Use a regular expression to find files ending in .cue or .bin
                next unless ($file =~ m/\.cue$|\.bin$/);

                unlink "$dir/$file";
            }

            closedir(DIR);
        }
        #last;
    }
}

main();