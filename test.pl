# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 3 };
use HTML::TextToHTML;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

my $conv = new HTML::TextToHTML();
ok(1);

@args = ();
push @args, "--system_link_dict", "txt2html.dict";
push @args, "--file", "sample.txt";
push @args, "--outfile", "sample.html";
push @args, "--append_file", "sample.foot";
push @args, "-tf", "--mail";
push @args, "-H", '^ *--[\w\s]+-- *$';
#push @args, "--debug";
#push @args, "--dict_debug", "7";
$result = $conv->txt2html(\@args);
ok($result);
