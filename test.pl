# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 11;
use HTML::TextToHTML;
ok(1); # If we made it this far, we're ok.

#########################

# compare two files
sub compare {
    my $file1 = shift;
    my $file2 = shift;

    open(F1, $file1) || return 0;
    open(F2, $file2) || return 0;

    my $res = 1;
    my $count = 0;
    while (<F1>)
    {
	$count++;
	my $comp1 = $_;
	# remove newline/carriage return (in case these aren't both Unix)
	$comp1 =~ s/\n//;
	$comp1 =~ s/\r//;

	my $comp2 = <F2>;

	# check if F2 has less lines than F1
	if (!defined $comp2)
	{
	    print "error - line $count does not exist in $file2\n  $file1 : $comp1\n";
	    close(F1);
	    close(F2);
	    return 0;
	}

	# remove newline/carriage return
	$comp2 =~ s/\n//;
	$comp2 =~ s/\r//;
	if ($comp1 ne $comp2)
	{
	    print "error - line $count not equal\n  $file1 : $comp1\n  $file2 : $comp2\n";
	    close(F1);
	    close(F2);
	    return 0;
	}
    }
    close(F1);

    # check if F2 has more lines than F1
    if (defined($comp2 = <F2>))
    {
	$comp2 =~ s/\n//;
	$comp2 =~ s/\r//;
	print "error - extra line in $file2 : '$comp2'\n";
	$res = 0;
    }

    close(F2);

    return $res;
}

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

my $conv = new HTML::TextToHTML();
ok( defined $conv, 'new() returned something' );
ok( $conv->isa('HTML::TextToHTML'), "  and it's the right class" );

@args = ();
push @args, "--system_link_dict", "TextToHTML.dict";
push @args, "--default_link_dict", "";
#push @args, "--link", "section.dict";
push @args, "--file", "sample.txt";
push @args, "--outfile", "sample.html";
push @args, "--append_file", "sample.foot";
push @args, "-tf", "--mail";
push @args, "-H", '^ *--[\w\s]+-- *$';
push @args, "--make_tables";
#push @args, "--debug";
#push @args, "--dict_debug", "15";
$result = $conv->txt2html(\@args);
ok($result, 'converted sample.txt');

# compare the files
$result = compare('good_sample.html', 'sample.html');
ok($result, 'test file matches original example exactly');
unlink('sample.html');

# test the process_para method alone
$test_str = "Matty had a little truck
he drove it round and round
and everywhere that Matty went
the truck was *always* found.
";

$ok_str = "<P>Matty had a little truck<BR>
he drove it round and round<BR>
and everywhere that Matty went<BR>
the truck was <EM>always</EM> found.
";
@args = ();
push @args, "--file", "CLEAR";
push @args, "--outfile", "-";
push @args, "--append_file", "";

$out_str = $conv->process_para($test_str);
ok($out_str, 'converted sample string');

# compare the result
is($out_str, $ok_str, 'compare converted string with OK string');

# test the process_para method with an ordered list
$test_str = "Here is my list:

1. Spam
2. Jam
3. Ham
4. Pickles
";

$ok_str = "<P>Here is my list:

<OL>
  <LI>Spam
  <LI>Jam
  <LI>Ham
  <LI>Pickles
</OL>
";
@args = ();
push @args, "--file", "CLEAR";
push @args, "--outfile", "-";
push @args, "--append_file", "";

$out_str = $conv->process_para($test_str);
ok($out_str, 'converted sample string with list');

# compare the result
is($out_str, $ok_str, 'compare converted list string with OK list string');

# test the file with XHTML on
$conv = undef;
$conv = new HTML::TextToHTML();

@args = ();
#push @args, "--debug";
#push @args, "--dict_debug", "15";
push @args, "--system_link_dict", "TextToHTML.dict";
push @args, "--default_link_dict", "";
#push @args, "--link", "section.dict";
push @args, "--file", "sample.txt";
push @args, "--xhtml"; 
push @args, "--outfile", "xhtml_sample.html";
push @args, "--append_file", "sample.foot2";
push @args, "-tf", "--mail";
push @args, "-H", '^ *--[\w\s]+-- *$';
push @args, "--make_tables";
push @args, "--make_anchors";

$result = $conv->txt2html(\@args);
ok($result, 'converted lower-case sample.txt');

# compare the files
$result = compare('good_xhtml_sample.html', 'xhtml_sample.html');
ok($result, 'test file xhtml_sample.html matches original good_xhtml_sample.html exactly');

unlink('xhtml_sample.html');
