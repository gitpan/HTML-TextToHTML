#! /usr/bin/perl
#------------------------------------------------------------------------

=head1 HTML::TextToHTML

HTML::TextToHTML - convert plain text file to HTML

=head1 SYNOPSIS

  From the command line:

    perl -MHTML::TextToHTML -e run_txt2html -- I<arguments>;
    (calls the txt2html method with the given arguments)

  From Scripts:

    use HTML::TextToHTML;
 
    # create a new object
    my $conv = new HTML::TextToHTML();

    # convert a file
    $conv->txt2html(infile=>[$text_file],
                     outfile=>$html_file,
		     title=>"Wonderful Things",
		     mail=>1,
      ]);

    # reset arguments
    $conv->args(infile=>[], mail=>0);

    # convert a string
    $newstring = $conv->process_para($mystring)

=head1 DESCRIPTION

HTML::TextToHTML converts plain text files to HTML.

It supports headings, tables, lists, simple character markup, and
hyperlinking, and is highly customizable. It recognizes some of the
apparent structure of the source document (mostly whitespace and
typographic layout), and attempts to mark that structure explicitly
using HTML. The purpose for this tool is to provide an easier way of
converting existing text documents to HTML format.

There are two ways to use this module:
    (1) called from a perl script
    (2) call run_txt2html from the command line

The first usage requires one to create a HTML::TextToHTML object, and
then call the txt2html or process_para method with suitable arguments.
One can also pass arguments in when creating the object, or call the
args method to pass arguments in.

The second usage allows one to pass arguments in from the command line, by
calling perl and executing the module, and calling run_txt2html which
creates an object for you and parses the command line.

Either way, the arguments are the same.  See L<OPTIONS> for the
arguments; see L<METHODS> for the methods of the HTML::TextToHTML object.

The following are the exported functions of this module:

=over 4

=item run_txt2html

    run_txt2html()

This is what is used to run this module from the command-line.  It creates
a HTML::TextToHTML object and parses the command-line arguments, and passes
them to the object, and runs the txt2html method.  It takes no arguments.

=back 4

=head1 OPTIONS

All arguments can be set when the object is created, and further options
can be set when calling the actual txt2html method. Arguments
to methods can take either a hash of arguments, or a reference to an
array (which will then be processed as if it were a command-line, which
makes this easy to use from scripts even if you don't wish to use
the commonly used Getopt::Long module in your script).

Note that all option-names must match exactly -- no abbreviations are
allowed.

The arguments get treated differently depending on whether they are
given in a hash or a reference to an array.  When the arguments are
in a hash, the argument-keys are expected to have values matching
those required for that argument -- whether that be a boolean, a string,
a reference to an array or a reference to a hash.  These will replace
any value for that argument that might have been there before.

When the arguments are in a reference to an array, it is treated
somewhat as if it were a command-line: option names are expected to
start with '--' or '-', boolean options are set to true as soon as the
option is given (no value is expected to follow),  boolean options with
the word "no" prepended set the option to false, string options are
expected to have a string value following, and those options which are
internally arrays or hashes are treated as cumulative; that is, the
value following the --option is added to the current set for that
option,  to add more, one just repeats the --option with the next value,
and in order to reset that option to empty, the special value of "CLEAR"
must be added to the list.

=over 8

=item append_file

    append_file=>I<filename>

If you want something appended by default, put the filename here.
The appended text will not be processed at all, so make sure it's
plain text or decent HTML.  i.e. do not have things like:
    Mary Andersen E<lt>kitty@example.comE<gt>
but instead, have:
    Mary Andersen &lt;kitty@example.com&gt;

(default: nothing)

=item append_head

    append_head=>I<filename>

If you want something appended to the head by default, put the filename here.
The appended text will not be processed at all, so make sure it's
plain text or decent HTML.  i.e. do not have things like:
    Mary Andersen E<lt>kitty@example.comE<gt>
but instead, have:
    Mary Andersen &lt;kitty@example.com&gt;

(default: nothing)

=item caps_tag

    caps_tag=>I<tag>

Tag to put around all-caps lines
(default: STRONG)

=item custom_heading_regexp

    custom_heading_regexp=>I<regexp>

Add a regexp for headings.  Header levels are assigned by regexp
in order seen When a line matches a custom header regexp, it is tagged as
a header.  If it's the first time that particular regexp has matched,
the next available header level is associated with it and applied to
the line.  Any later matches of that regexp will use the same header level.
Therefore, if you want to match numbered header lines, you could use
something like this:
    -H '^ *\d+\. \w+' -H '^ *\d+\.\d+\. \w+' -H '^ *\d+\.\d+\.\d+\. \w+'

Then lines like
                " 1. Examples "
                " 1.1 Things"
            and " 4.2.5 Cold Fusion"
Would be marked as H1, H2, and H3 (assuming they were found in that
order, and that no other header styles were encountered).
If you prefer that the first one specified always be H1, the second
always be H2, the third H3, etc, then use the -EH/--explicit-headings
option.

This is a multi-valued option.

(default: none)

=item debug
    
    debug=>1

Enable copious script debugging output (don't bother, this is for the
developer) (default: false)

=item default_link_dict

    default_link_dict=>I<filename>

The name of the default "user" link dictionary.
(default: "$ENV{'HOME'}/.txt2html.dict" -- this is the same as for
the txt2html script)

=item dict_debug

    dict_debug=>I<n>

Debug mode for link dictionaries Bitwise-Or what you want to see:
          1: The parsing of the dictionary
          2: The code that will make the links
          4: When each rule matches something
          8: When each tag is created

(default: 0)

=item doctype

    doctype=>I<doctype>

This gets put in the DOCTYPE field at the top of the document, unless it's
empty.  (default : "-//W3C//DTD HTML 3.2 Final//EN")
If --xhtml is true, the contents of this is ignored, unless it's
empty, in which case no DOCTYPE declaration is output.

=item eight_bit_clean

    eight_bit_clean=>1

disable Latin-1 character entity naming
(default: false)

=item escape_HTML_chars

    escape_HTML_chars=>1

turn & E<lt> E<gt> into &amp; &gt; &lt;
(default: true)

=item explicit_headings

    explicit_headings=>1

Don't try to find any headings except the ones specified in the
--custom_heading_regexp option.
Also, the custom headings will not be assigned levels in the order they
are encountered in the document, but in the order they are specified on
the command line.
(default: false)

=item extract

    extract=>1

Extract Mode; don't put HTML headers or footers on the result, just
the plain HTML (thus making the result suitable for inserting into
another document (or as part of the output of a CGI script).
(default: false)

=item hrule_min

    hrule_min=>I<n>

Min number of ---s for an HRule.
(default: 4)

=item indent_width

    indent_width=>I<n>

Indents this many spaces for each level of a list.
(default: 2)

=item indent_par_break

    indent_par_break=>1

Treat paragraphs marked solely by indents as breaks with indents.
That is, instead of taking a three-space indent as a new paragraph,
put in a <BR> and three non-breaking spaces instead.
(see also --preserve_indent)
(default: false)

=item infile

    infile=>\@my_files
    infile=>['chapter1.txt', 'chapter2.txt']
    "--infile", "chapter1.txt", "--infile", "chapter2.txt"

The name of the input file(s).  When the arguments are given as a hash,
this expects a reference to an array of filenames.  When the arguments
are given as a reference to an array, then the "--infile" option must
be repeated for each new file added to the list.  If you want to reset
the list to be empty, give the special value of "CLEAR".

(default:undefined)

=item links_dictionaries

    links_dictionaries=>\@my_link_dicts
    links_dictionaries=>['url_links.dict', 'format_links.dict']
    "--links_dictionaries", "url_links.dict", "--links_dictionaries", "format_links.dict"

File(s) to use as a link-dictionary.  There can be more than one of
these.  These are in addition to the System Link Dictionary and the User
Link Dictionary.  When the arguments are given as a hash, this expects a
reference to an array of filenames.  When the arguments are given as a
reference to an array, then the "--links_dictionaries" option must be
repeated for each new file added to the list.  If you want to reset the
list to be empty, give the special value of "CLEAR".

=item link_only

    link_only=>1

Do no escaping or marking up at all, except for processing the links
dictionary file and applying it.  This is useful if you want to use
the linking feature on an HTML document.  If the HTML is a
complete document (includes HTML,HEAD,BODY tags, etc) then you'll
probably want to use the --extract option also.
(default: false)

=item mailmode

    mailmode=>1

Deal with mail headers & quoted text
(default: false)

=item make_anchors

    make_anchors=>0

Should we try to make anchors in headings?
(default: true)

=item make_links

    make_links=>0

Should we try to build links?  If this is false, then the links
dictionaries are not consulted and only structural text-to-HTML
conversion is done.  (default: true)

=item make_tables

    make_tables=>1

Should we try to build tables?  If true, spots tables and marks them up
appropriately.  See L<Input File Format> for information on how tables
should be formatted.

This overrides the detection of lists; if something looks like a table,
it is taken as a table, and list-checking is not done for that
paragraph.

(default: false)

=item min_caps_length

    min_caps_length=>I<n>

min sequential CAPS for an all-caps line
(default: 3)

=item outfile

    outfile=>I<filename>

The name of the output file.  If it is "-" then the output goes
to Standard Output.
(default: - )

=item par_indent

    par_indent=>I<n>

Minumum number of spaces indented in first lines of paragraphs.
  Only used when there's no blank line
preceding the new paragraph.
(default: 2)

=item preformat_trigger_lines

    preformat_trigger_lines=>I<n>

How many lines of preformatted-looking text are needed to switch to <PRE>
          <= 0 : Preformat entire document
             1 : one line triggers
          >= 2 : two lines trigger

(default: 2)

=item endpreformat_trigger_lines

    endpreformat_trigger_lines=>I<n>

How many lines of unpreformatted-looking text are needed to switch from <PRE>
           <= 0 : Never preformat within document
              1 : one line triggers
           >= 2 : two lines trigger
(default: 2)

NOTE for preformat_trigger_lines and endpreformat_trigger_lines:
A zero takes precedence.  If one is zero, the other is ignored.
If both are zero, entire document is preformatted.

=item preformat_start_marker

    preformat_start_marker=>I<regexp>

What flags the start of a preformatted section if --use_preformat_marker
is true.

(default: "^(:?(:?&lt;)|<)PRE(:?(:?&gt;)|>)\$")

=item preformat_end_marker

    preformat_end_marker=>I<regexp>

What flags the end of a preformatted section if --use_preformat_marker
is true.

(default: "^(:?(:?&lt;)|<)/PRE(:?(:?&gt;)|>)\$")

=item preformat_whitespace_min

    preformat_whitespace_min=>I<n>

Minimum number of consecutive whitespace characters to trigger
normal preformatting. 
NOTE: Tabs are expanded to spaces before this check is made.
That means if B<tab_width> is 8 and this is 5, then one tab may be
expanded to 8 spaces, which is enough to trigger preformatting.
(default: 5)

=item prepend_file

    prepend_file=>I<filename>

If you want something prepended to the processed body text, put the
filename here.  The prepended text will not be processed at all, so make
sure it's plain text or decent HTML.

(default: nothing)

=item preserve_indent

    preserve_indent=>1

Preserve the first-line indentation of paragraphs marked with indents
by replacing the spaces of the first line with non-breaking spaces.
(default: false)

=item short_line_length

    short_line_length=>I<n>

Lines this short (or shorter) must be intentionally broken and are kept
that short.
(default: 40)

=item system_link_dict

    system_link_dict=>I<filename>

The name of the default "system" link dictionary.
(default: "/usr/share/txt2html/TextToHTML.dict")

=item tab_width

    tab_width=>I<n>

How many spaces equal a tab?
(default: 8)

=item title

    title=>I<title>

You can specify a title.  Otherwise it will use a blank one.
(default: nothing)

=item titlefirst

    titlefirst=>1

Use the first non-blank line as the title.

=item underline_length_tolerance

    underline_length_tolerance=>I<n>

How much longer or shorter can underlines be and still be underlines?
(default: 1)

=item underline_offset_tolerance

    underline_offset_tolerance=>I<n>

How far offset can underlines be and still be underlines?
(default: 1)

=item unhyphenation

    unhyphenation=>0

Enables unhyphenation of text.
(default: true)

=item use_mosaic_header

    use_mosaic_header=>1

Use this option if you want to force the heading styles to match what Mosaic
outputs.  (Underlined with "***"s is H1,
with "==="s is H2, with "+++" is H3, with "---" is H4, with "~~~" is H5
and with "..." is H6)
This was the behavior of txt2html up to version 1.10.
(default: false)

=item use_preformat_marker

    use_preformat_marker=>1

Turn on preformatting when encountering
"<PRE>" on a line by itself, and turn it
off when there's a line containing only "</PRE>".
(default: off)

=item xhtml

    xhtml=>1

Try to make the output conform to the XHTML standard, including
closing all open tags and marking empty tags correctly.  This
turns on --lower_case_tags and overrides the --doctype option.
Note that if you add a header or a footer file, it is up to you
to make it conform; the header/footer isn't touched by this.
Likewise, if you make link-dictionary entries that break XHTML,
then this won't fix them, except to the degree of putting all tags
into lower-case.

=back 8

=head1 METHODS

=cut

#------------------------------------------------------------------------
package HTML::TextToHTML;

use 5.005_03;
use strict;

require Exporter;
use vars qw($VERSION $PROG @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

BEGIN {
    @ISA = qw(Exporter);
    require Exporter;
    use Data::Dumper;
}

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use HTML::TextToHTML ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
%EXPORT_TAGS = (
    'all' => [
        qw(

        )
    ]
);

@EXPORT_OK = (@{$EXPORT_TAGS{'all'}});

@EXPORT = qw(
  run_txt2html
);
$PROG = 'HTML::TextToHTML';
$VERSION = '1.12';

#------------------------------------------------------------------------
use constant TEXT_TO_HTML => "TEXT_TO_HTML";

########################################
# Definitions  (Don't change these)
#

# These are just constants I use for making bit vectors to keep track
# of what modes I'm in and what actions I've taken on the current and
# previous lines.  
use vars qw($NONE $LIST $HRULE $PAR $PRE $END $BREAK $HEADER
  $MAILHEADER $MAILQUOTE $CAPS $LINK $PRE_EXPLICIT $TABLE
  $IND_BREAK $LIST_START $LIST_ITEM);

$NONE         = 0;
$LIST         = 1;
$HRULE        = 2;
$PAR          = 4;
$PRE          = 8;
$END          = 16;
$BREAK        = 32;
$HEADER       = 64;
$MAILHEADER   = 128;
$MAILQUOTE    = 256;
$CAPS         = 512;
$LINK         = 1024;
$PRE_EXPLICIT = 2048;
$TABLE        = 4096;
$IND_BREAK    = 8192;
$LIST_START   = 16384;
$LIST_ITEM    = 32768;

# Constants for Link-processing
# bit-vectors for what to do with a particular link-dictionary entry
use vars qw($LINK_NOCASE $LINK_EVAL $LINK_HTML $LINK_ONCE $LINK_SECT_ONCE);
$LINK_NOCASE    = 1;
$LINK_EVAL      = 2;
$LINK_HTML      = 4;
$LINK_ONCE      = 8;
$LINK_SECT_ONCE = 16;

# Constants for Ordered Lists and Unordered Lists.  
# I use this in the list stack to keep track of what's what.

use vars qw($OL $UL);
$OL = 1;
$UL = 2;

# Character entity names
use vars qw(%char_entities %char_entities2);

# characters to replace *before* processing a line
%char_entities = (
    "\241", "&iexcl;",  "\242", "&cent;",   "\243", "&pound;",
    "\244", "&curren;", "\245", "&yen;",    "\246", "&brvbar;",
    "\247", "&sect;",   "\250", "&uml;",    "\251", "&copy;",
    "\252", "&ordf;",   "\253", "&laquo;",  "\254", "&not;",
    "\255", "&shy;",    "\256", "&reg;",    "\257", "&hibar;",
    "\260", "&deg;",    "\261", "&plusmn;", "\262", "&sup2;",
    "\263", "&sup3;",   "\264", "&acute;",  "\265", "&micro;",
    "\266", "&para;",   "\270", "&cedil;",  "\271", "&sup1;",
    "\272", "&ordm;",   "\273", "&raquo;",  "\274", "&fraq14;",
    "\275", "&fraq12;", "\276", "&fraq34;", "\277", "&iquest;",
    "\300", "&Agrave;", "\301", "&Aacute;", "\302", "&Acirc;",
    "\303", "&Atilde;", "\304", "&Auml;",   "\305", "&Aring;",
    "\306", "&AElig;",  "\307", "&Ccedil;", "\310", "&Egrave;",
    "\311", "&Eacute;", "\312", "&Ecirc;",  "\313", "&Euml;",
    "\314", "&Igrave;", "\315", "&Iacute;", "\316", "&Icirc;",
    "\317", "&Iuml;",   "\320", "&ETH;",    "\321", "&Ntilde;",
    "\322", "&Ograve;", "\323", "&Oacute;", "\324", "&Ocirc;",
    "\325", "&Otilde;", "\326", "&Ouml;",   "\327", "&times;",
    "\330", "&Oslash;", "\331", "&Ugrave;", "\332", "&Uacute;",
    "\333", "&Ucirc;",  "\334", "&Uuml;",   "\335", "&Yacute;",
    "\336", "&THORN;",  "\337", "&szlig;",  "\340", "&agrave;",
    "\341", "&aacute;", "\342", "&acirc;",  "\343", "&atilde;",
    "\344", "&auml;",   "\345", "&aring;",  "\346", "&aelig;",
    "\347", "&ccedil;", "\350", "&egrave;", "\351", "&eacute;",
    "\352", "&ecirc;",  "\353", "&euml;",   "\354", "&igrave;",
    "\355", "&iacute;", "\356", "&icirc;",  "\357", "&iuml;",
    "\360", "&eth;",    "\361", "&ntilde;", "\362", "&ograve;",
    "\363", "&oacute;", "\364", "&ocirc;",  "\365", "&otilde;",
    "\366", "&ouml;",   "\367", "&divide;", "\370", "&oslash;",
    "\371", "&ugrave;", "\372", "&uacute;", "\373", "&ucirc;",
    "\374", "&uuml;",   "\375", "&yacute;", "\376", "&thorn;",
    "\377", "&yuml;",
);

# characters to replace *after* processing a line
%char_entities2 = ("\267", "&middot;",);

# alignments for tables
use vars qw(@alignments @lc_alignments @xhtml_alignments);
@alignments = ('', '', ' ALIGN="RIGHT"', ' ALIGN="CENTER"');
@lc_alignments = ('', '', ' align="right"', ' align="center"');
@xhtml_alignments = ('', '', ' style="text-align: right;"', ' style="text-align: center;"');

#---------------------------------------------------------------#
# Object interface
#---------------------------------------------------------------#

=head2 new

    $conv = new HTML::TextToHTML()

    $conv = new HTML::TextToHTML(\@args)

    $conv = new HTML::TextToHTML(titlefirst=>1,
	...
    );

Create a new object with new.  If one argument is given, it is assumed
to be a reference to an array of arguments.  If more than one argument
is given, it is assumed to be a hash of arguments.  These arguments will
be used in invocations of other methods.

See L<OPTIONS> for the possible values of the arguments.

=cut

sub new {
    my $invocant = shift;
    my $self = {};

    my $class = ref($invocant) || $invocant;    # Object or class name
    init_our_data($self);

    # bless self
    bless($self, $class);

    $self->args(@_);

    return $self;
}    # new

=head2 args

    $conv->args(\@args)

    $conv->args(short_line_length=>60,
	titlefirst=>1,
	....
    );

Updates the current arguments/options of the HTML::TextToHTML object.
Takes either a hash, or a reference to an array of arguments, which will
be used in invocations of other methods.
See L<OPTIONS> for the possible values of the arguments.

=cut

sub args {
    my $self     = shift;
    my %args = ();
    my @arg_array = ();
    if (@_ && @_ == 1)
    {
	# assume this is a reference to an array -- use the old style args
	my $aref = shift;
	@arg_array = @{$aref};
    }
    elsif (@_)
    {
	%args = @_;
    }

    if (%args) {
	if ($self->{debug}) {
	    print STDERR "========args(hash)========\n";
	    print STDERR Dumper(%args);
	}
	foreach my $arg (keys %args) {
	    if (defined $args{$arg}) {
		if ($arg =~ /^-/) {
		    $arg =~ s/^-//; # get rid of first dash
		    $arg =~ s/^-//; # get rid of possible second dash
		}
		if ($self->{debug}) {
		    print STDERR "--", $arg;
		}
		$self->{$arg} = $args{$arg};
		if ($self->{debug}) {
		    print STDERR " ", $args{$arg}, "\n";
		}
	    }
	}
    } elsif (@arg_array) {
	if ($self->{debug}) {
	    print STDERR "========args(array)========\n";
	    print STDERR Dumper(@arg_array);
	}
	# the arg array may have filenames at the end of it,
	# so don't consume them
	my $look_at_args = 1;
	while (@arg_array && $look_at_args) {
	    my $arg = shift @arg_array;
	    # check for arguments which are bools,
	    # and thus have no companion value
	    if ($arg =~ /^-/) {
		$arg =~ s/^-//; # get rid of first dash
		$arg =~ s/^-//; # get rid of possible second dash
		if ($self->{debug}) {
		    print STDERR "--", $arg;
		}
		if ($arg eq 'debug'
		    || $arg eq 'eight_bit_clean'
		    || $arg eq 'escape_HTML_chars'
		    || $arg eq 'explicit_headings'
		    || $arg eq 'extract'
		    || $arg eq 'link_only'
		    || $arg eq 'lower_case_tags'
		    || $arg eq 'mailmode'
		    || $arg eq 'make_anchors'
		    || $arg eq 'make_links'
		    || $arg eq 'make_tables'
		    || $arg eq 'preserve_indent'
		    || $arg eq 'titlefirst'
		    || $arg eq 'unhyphenation'
		    || $arg eq 'use_mosaic_header'
		    || $arg eq 'use_preformat_marker'
		    || $arg eq 'verbose'
		    || $arg eq 'xhtml'
		) {
		    $self->{$arg} = 1;
		    if ($self->{debug}) {
			print STDERR "=true\n";
		    }
		} elsif ($arg eq 'nodebug'
		    || $arg eq 'noeight_bit_clean'
		    || $arg eq 'noescape_HTML_chars'
		    || $arg eq 'noexplicit_headings'
		    || $arg eq 'noextract'
		    || $arg eq 'nolink_only'
		    || $arg eq 'nolower_case_tags'
		    || $arg eq 'nomailmode'
		    || $arg eq 'nomake_anchors'
		    || $arg eq 'nomake_links'
		    || $arg eq 'nomake_tables'
		    || $arg eq 'nopreserve_indent'
		    || $arg eq 'notitlefirst'
		    || $arg eq 'nounhyphenation'
		    || $arg eq 'nouse_mosaic_header'
		    || $arg eq 'nouse_preformat_marker'
		    || $arg eq 'noverbose'
		    || $arg eq 'noxhtml'
		) {
		    $arg =~ s/^no//;
		    $self->{$arg} = 0;
		    if ($self->{debug}) {
			print STDERR " $arg=false\n";
		    }
		} else {
		    my $val = shift @arg_array;
		    if ($self->{debug}) {
			print STDERR "=", $val, "\n";
		    }
		    # check the types
		    if (defined $arg && defined $val) {
			if ($arg eq 'infile' 
			    || $arg eq 'custom_heading_regexp'
			    || $arg eq 'links_dictionaries'
			) {	# arrays
			    if ($val eq 'CLEAR') {
				$self->{$arg} = [];
			    } else {
				push @{$self->{$arg}}, $val;
			    }
			} elsif ($arg eq 'file') {	# alternate for 'infile'
			    if ($val eq 'CLEAR') {
				$self->{infile} = [];
			    } else {
				push @{$self->{infile}}, $val;
			    }
			} else {
			    $self->{$arg} = $val;
			}
		    }
		}
	    } else {
		# if an option don't start with - then we've
		# come to the end of the options
		$look_at_args = 0;
	    }
	}
    }
    if ($self->{debug})
    {
    	print STDERR Dumper($self);
    }

    return 1;
}    # args

=head2 process_para

$newstring = $conv->process_para($mystring)

Convert a string to a HTML fragment.  This assumes that this string is at
the least, a single paragraph.  This returns the processed string.  If you
want to pass arguments to alter the behaviour of this conversion, you need
to do that earlier, either when you create the object, or with the L<args>
method.

    $newstring = $conv->process_para($mystring,
			    close_tags=>0)

If there are open tags (such as lists) in the input string, process_para will
now automatically close them, unless you specify not to, with the close_tags
option.

=cut
sub process_para ($$;%) {
    my $self = shift;
    my $para = shift;
    my %args = (
	close_tags=>1,
	@_
    );

    # if this is an external call, do certain initializations
    $self->do_init_call();

    my $para_action = $NONE;

    # tables don't carry over from one para to the next
    if ($self->{__mode} & $TABLE) {
        $self->{__mode} ^= $TABLE;
    }
    if (!$self->{link_only}) {

        my $para_len         = length($para);
        my @para_lines       = split (/^/, $para);
        my @para_line_len    = ();
        my @para_line_indent = ();
        my @para_line_action = ();
        my $line;
        for (my $i = 0 ; $i < @para_lines ; $i++) {
            $line = $para_lines[$i];
	    my $ind;

            # Chop trailing whitespace and DOS CRs
            $line =~ s/[ \011]*\015$//;
            $line = $self->untabify($line);    # Change all tabs to spaces
            push @para_line_len, length($line);
            if ($i > 0) {
                $ind = count_indent($line, $para_line_indent[$i - 1]);
                push @para_line_indent, $ind;
            }
            else {
                $ind = count_indent($line, 0);
                push @para_line_indent, $ind;
            }
            push @para_line_action, 0;
            $para_lines[$i] = $line;
        }

        # do the table stuff on the array of lines
        if ($self->{make_tables}) {
            $self->tablestuff(\@para_lines, $para_len);
        }

        my $prev        = '';
        my $next        = '';
        my $prev_action = $self->{__prev_para_action};
        for (my $i = 0 ; $i < @para_lines ; $i++) {
            my $prev_ref;
            my $prev_action_ref;
            my $prev_line_indent;
            my $prev_line_len;
            if ($i == 0) {
                $prev_ref         = \$prev;
                $prev_action_ref  = \$prev_action;
                $prev_line_indent = 0;
                $prev_line_len    = 0;
            }
            else {
                $prev_ref         = \$para_lines[$i - 1];
                $prev_action_ref  = \$para_line_action[$i - 1];
                $prev_line_indent = $para_line_indent[$i - 1];
                $prev_line_len    = $para_line_len[$i - 1];
            }
            my $next_ref;
            if ($i == @para_lines - 1) {
                $next_ref = \$next;
            }
            else {
                $next_ref = \$para_lines[$i + 1];
            }

            # Don't escape HTML chars if we're in a table, because
            # it's already been done in tablestuff above
            # and we don't actually want to escape the table code!
            if ($self->{escape_HTML_chars} && !($self->{__mode} & $TABLE)) {
                $para_lines[$i] = escape($para_lines[$i]);
            }
            if (($self->{__mode} & $PRE)
                && ($self->{preformat_trigger_lines} != 0))
            {
                $self->endpreformat(\$self->{__mode},
		    \@para_lines, \@para_line_action, $i, $prev_ref);
            }
            if (!($self->{__mode} & $PRE)) {
                $self->hrule(\@para_lines, \@para_line_action, $i);
            }
            if (@{$self->{custom_heading_regexp}} && !($self->{__mode} & $PRE))
            {
                $self->custom_heading(\@para_lines, \@para_line_action, $i);
            }
            if (!($self->{__mode} & ($PRE | $TABLE))
                && !is_blank($para_lines[$i]))
            {
                $self->liststuff(
                    \@para_lines,       \@para_line_action,
                    \@para_line_indent, $i, $prev_ref);
            }
            if (!$self->{explicit_headings}
                && !($self->{__mode} & ($PRE | $HEADER | $TABLE))
                && ${$next_ref} =~ /^\s*[=\-\*\.~\+]+\s*$/)
            {
                $self->heading(\$para_lines[$i], \$para_line_action[$i],
                    $next_ref);
            }
            if ($self->{mailmode}
                && !($self->{__mode} & ($PRE | $TABLE))
                && !($para_line_action[$i] & $HEADER))
            {
                $self->mailstuff(
                    \$para_lines[$i], \$para_line_action[$i],
                    $prev_ref,        $prev_action_ref,
                    $next_ref
                );
            }
            if (
                !($para_line_action[$i] &
                    ($HEADER | $LIST | $MAILHEADER | $TABLE))
                && !($self->{__mode} & ($LIST | $PRE))
                && $self->{__preformat_enabled})
            {
                $self->preformat(
                    \$self->{__mode},       \$para_lines[$i],
                    \$para_line_action[$i], $prev_ref,
                    $next_ref
                );
            }
            $self->paragraph(
                \$self->{__mode},       \$para_lines[$i],
                \$para_line_action[$i], $prev_ref, $prev_action_ref,
                $para_line_indent[$i],  $prev_line_indent
            );
            $self->shortline(
                \$self->{__mode},       \$para_lines[$i],
                \$para_line_action[$i], $prev_ref,
                $prev_action_ref,       $prev_line_len
            );
            if (!($self->{__mode} & ($PRE | $TABLE))) {
                $self->caps(\$para_lines[$i], \$para_line_action[$i]);
            }

            if ($i == 0 && !is_blank($prev))

              # put the "prev" line in front of the first line
            {
                $line = $para_lines[$i];
                $para_lines[$i] = $prev . $line;
            }
            if ($i == @para_lines - 1 && !is_blank($next))

              # put the "next" at the end of the last line
            {
                $para_lines[$i] .= $next;
            }
        }

        # para action is the action of the last line of the para
        $para_action = $para_line_action[$#para_line_action];

        # now put the para back together as one string
        $para = join ("", @para_lines);

	# if this is a paragraph, and we are in XHTML mode,
	# close an open paragraph.
	if ($self->{xhtml})
	{
	    my $open_tag = @{$self->{__tags}}[$#{$self->{__tags}}];
	    if ($open_tag eq 'P')
	    {
		$para .= $self->close_tag('P');
	    }
	}

        if ($self->{unhyphenation}

            # ends in hyphen & next line starts w/letters
            && ($para =~ /[^\W\d_]\-\n\s*[^\W\d_]/s)
            && !($self->{__mode} &
                ($PRE | $HEADER | $MAILHEADER | $TABLE | $BREAK))
          )
        {
            $self->unhyphenate_para(\$para);
        }

    }

    if ($self->{make_links}
        && !is_blank($para)
        && @{$self->{__links_table_order}})
    {
        $self->make_dictionary_links(\$para, \$para_action);
    }

    # close any open lists if required to
    if ($args{close_tags}
	&& $self->{__mode} & $LIST)    # End all lists
    {
	$self->endlist($self->{__listnum},
			\$para, \$para_action);
    }
    # close any open tags
    if ($args{close_tags} && $self->{xhtml})
    {
	while (@{$self->{__tags}})
	{
	    $para .= $self->close_tag('');
	}
    }

    # All the matching and formatting is done.  Now we can 
    # replace non-ASCII characters with character entities.
    if (!$self->{eight_bit_clean}) {
        my @chars = split (//, $para);
        foreach $_ (@chars) {
            $_ = $char_entities{$_} if defined($char_entities{$_});
        }
        $para = join ("", @chars);
    }


    $self->{__prev_para_action} = $para_action;

    return $para;
}

=head2 txt2html

    $conv->txt2html(\@args);

    $conv->txt2html(%args);

Convert a text file to HTML.  Takes a hash of arguments, or a reference
to an array of arguments to customize the conversion; (this includes
saying what file to convert!) See L<OPTIONS> for the possible values of
the arguments.  Arguments which have already been set with B<new> or
B<args> will remain as they are, unless they are overridden.

=cut
sub txt2html ($;$) {
    my $self     = shift;

    if (@_) {
	$self->args(@_);
    }

    $self->do_init_call();

    my $outhandle;
    my $not_to_stdout;

    # open the output
    if ($self->{outfile} eq "-") {
        $outhandle     = *STDOUT;
        $not_to_stdout = 0;
    }
    else {
        open(HOUT, "> " . $self->{outfile}) || die "Error: unable to open ",
          $self->{outfile}, ": $!\n";
        $outhandle     = *HOUT;
        $not_to_stdout = 1;
    }


    # slurp up a paragraph at a time
    local $/ = "";
    my $para  = '';
    my $count = 0;
    foreach my $file (@{$self->{infile}}) {
        if (-f $file && open(IN, $file)) {
            while (<IN>) {
                $para = $_;
                $para =~ s/\n$//;    # trim the endline
                if ($count == 0) {
                    $self->do_file_start($outhandle, $para);
                }
		$self->clear_section_links();
                $para = $self->process_para($para, 
		    close_tags=>0);
                print $outhandle $para, "\n";
                $count++;
            }
        }
    }

    $self->{__prev} = "";
    if ($self->{__mode} & $LIST)    # End all lists
    {
	$self->endlist($self->{__listnum},
			\$self->{__prev}, \$self->{__line_action})
    }
    print $outhandle $self->{__prev};
    if ($self->{xhtml})
    {
	# close any open tags (until we get to the body)
	my $open_tag = @{$self->{__tags}}[$#{$self->{__tags}}];
	while (@{$self->{__tags}}
	    && $open_tag ne 'BODY'
	    && $open_tag ne 'HTML')
	{
	    print $outhandle $self->close_tag('');
	    $open_tag = @{$self->{__tags}}[$#{$self->{__tags}}];
	}
	print $outhandle "\n";
    }

    if ($self->{append_file}) {
        if (-r $self->{append_file}) {
            open(APPEND, $self->{append_file});
            while (<APPEND>) {
                print $outhandle $_;
            }
            close(APPEND);
        }
        else {
            print STDERR "Can't find or read file ", $self->{append_file},
              " to append.\n";
        }
    }

    if (!$self->{extract}) {
        print $outhandle $self->get_tag('BODY', tag_type=>'end'), "\n";
        print $outhandle $self->get_tag('HTML', tag_type=>'end'), "\n";
    }
    if ($not_to_stdout) {
        close($outhandle);
    }
    return 1;
}

#---------------------------------------------------------------#
# Init-related subroutines

#--------------------------------#
# Name: init_our_data
# Args:
#   $self
sub init_our_data ($) {
    my $self = shift;

    $self->{debug} = 0;

    #
    # All the options, in alphabetical order
    #
    $self->{append_file} = '';
    $self->{append_head} = '';
    $self->{caps_tag} = 'STRONG';
    $self->{custom_heading_regexp} = [];
    $self->{default_link_dict} = "$ENV{HOME}/.txt2html.dict";
    $self->{dict_debug} = 0;
    $self->{doctype} = "-//W3C//DTD HTML 3.2 Final//EN";
    $self->{eight_bit_clean} = 0;
    $self->{escape_HTML_chars} = 1;
    $self->{explicit_headings} = 0;
    $self->{extract} = 0;
    $self->{hrule_min} = 4;
    $self->{indent_width} = 2;
    $self->{indent_par_break} = 0;
    $self->{infile} = [];
    $self->{links_dictionaries} = [];
    $self->{link_only} = 0;
    $self->{lower_case_tags} = 0;
    $self->{mailmode} = 0;
    $self->{make_anchors} = 1;
    $self->{make_links} = 1;
    $self->{make_tables} = 0;
    $self->{min_caps_length} = 3;
    $self->{outfile} = '-';
    $self->{par_indent} = 2;
    $self->{preformat_trigger_lines} = 2;
    $self->{endpreformat_trigger_lines} = 2;
    $self->{preformat_start_marker} = "^(:?(:?&lt;)|<)PRE(:?(:?&gt;)|>)\$";
    $self->{preformat_end_marker} = "^(:?(:?&lt;)|<)/PRE(:?(:?&gt;)|>)\$";
    $self->{preformat_whitespace_min} = 5;
    $self->{prepend_file} = '';
    $self->{preserve_indent} = 0;
    $self->{short_line_length} = 40;
    $self->{system_link_dict} = '/usr/share/txt2html/TextToHTML.dict';
    $self->{tab_width} = 8;
    $self->{title} = '';
    $self->{titlefirst} = 0;
    $self->{underline_length_tolerance} = 1;
    $self->{underline_offset_tolerance} = 1;
    $self->{unhyphenation} = 1;
    $self->{use_mosaic_header} = 0;
    $self->{use_preformat_marker} = 0;
    $self->{xhtml} = 0;

    # accumulation variables
    $self->{__file} = "";    # Current file being processed
    my %heading_styles = ();
    $self->{__heading_styles}     = \%heading_styles;
    $self->{__num_heading_styles} = 0;
    my %links_table = ();
    $self->{__links_table} = \%links_table;
    my @links_table_order = ();
    $self->{__links_table_order} = \@links_table_order;
    my @search_patterns = ();
    $self->{__search_patterns} = \@search_patterns;
    my @repl_code = ();
    $self->{__repl_code}        = \@repl_code;
    $self->{__prev_para_action} = 0;
    $self->{__non_header_anchor} = 0;
    $self->{__mode}              = 0;
    $self->{__listnum}           = 0;
    $self->{__list_indent}       = "";

    $self->{__call_init_done}    = 0;

}    # init_our_data

#---------------------------------------------------------------#
# txt2html-related subroutines

#--------------------------------#
# Name: init_our_data
#   do extra processing related to particular options
# Args:
#   $self
sub deal_with_options ($) {
    my $self = shift;

    if ($self->{links_dictionaries}) {
	# only put into the links dictionaries files which are readable
	my @dict_files = @{$self->{links_dictionaries}};
	$self->args(links_dictionaries=>[]);

        foreach my $ld (@dict_files) {
            if (-r $ld) {
                $self->{'make_links'} = 1;
		$self->args(['--links_dictionaries', $ld]);
            }
            else {
                print STDERR "Can't find or read link-file $ld\n";
            }
        }
    }
    if (!$self->{make_links}) {
        $self->{'links_dictionaries'} = 0;
        $self->{'system_link_dict'}  = "";
    }
    if ($self->{append_file}) {
        if (!-r $self->{append_file}) {
            print STDERR "Can't find or read ", $self->{append_file}, "\n";
	    $self->{append_file} = '';
        }
    }
    if ($self->{prepend_file}) {
        if (!-r $self->{prepend_file}) {
            print STDERR "Can't find or read ", $self->{prepend_file}, "\n";
	    $self->{'prepend_file'} = '';
        }
    }
    if ($self->{append_head}) {
        if (!-r $self->{append_head}) {
            print STDERR "Can't find or read ", $self->{append_head}, "\n";
	    $self->{'append_head'} = '';
        }
    }

    if (!$self->{outfile}) {
        $self->{'outfile'} = "-";
    }

    $self->{'preformat_trigger_lines'} = 0
      if ($self->{preformat_trigger_lines} < 0);
    $self->{'preformat_trigger_lines'} = 2
      if ($self->{preformat_trigger_lines} > 2);

    $self->{'endpreformat_trigger_lines'} = 1
      if ($self->{preformat_trigger_lines} == 0);
    $self->{'endpreformat_trigger_lines'} = 0
      if ($self->{endpreformat_trigger_lines} < 0);
    $self->{'endpreformat_trigger_lines'} = 2
      if ($self->{endpreformat_trigger_lines} > 2);

    $self->{__preformat_enabled} =
      (($self->{endpreformat_trigger_lines} != 0)
      || $self->{use_preformat_marker});

    if ($self->{use_mosaic_header}) {
        my $num_heading_styles = 0;
        my %heading_styles     = ();
        $heading_styles{"*"} = ++$num_heading_styles;
        $heading_styles{"="} = ++$num_heading_styles;
        $heading_styles{"+"} = ++$num_heading_styles;
        $heading_styles{"-"} = ++$num_heading_styles;
        $heading_styles{"~"} = ++$num_heading_styles;
        $heading_styles{"."} = ++$num_heading_styles;
        $self->{__heading_styles}     = \%heading_styles;
        $self->{__num_heading_styles} = $num_heading_styles;
    }
    if ($self->{xhtml}) # XHTML implies lower case
    {
	$self->{'lower_case_tags'} = 1;
    }
}

sub is_blank ($) {

    return $_[0] =~ /^\s*$/;
}

sub escape ($) {
    my ($text) = @_;
    $text =~ s/&/&amp;/g;
    $text =~ s/>/&gt;/g;
    $text =~ s/</&lt;/g;
    return $text;
}

# output the tag wanted (add the <> and the / if necessary)
# - output in lower or upper case
# - do tag-related processing
# options:
#   tag_type=>'start' | tag_type=>'end' | tag_type=>'empty'
#   (default start)
#   inside_tag=>string (default empty)
sub get_tag ($$;%) {
    my $self	    = shift;
    my $in_tag	    = shift;
    my %args = (
	tag_type=>'start',
	inside_tag=>'',
	@_
    );
    my $inside_tag  = $args{inside_tag};

    my $open_tag = @{$self->{__tags}}[$#{$self->{__tags}}];
    if (!defined $open_tag)
    {
	$open_tag = '';
    }
    # close any open tags that need closing
    # Note that we only have to check for the structural tags we make,
    # not every possible HTML tag
    my $tag_prefix = '';
    if ($self->{xhtml})
    {
	if ($open_tag eq 'P' and $in_tag eq 'P'
	    and $args{tag_type} ne 'end')
	{
	    $tag_prefix = $self->close_tag('P');
	}
	elsif ($open_tag eq 'P' and $in_tag =~ /(HR|UL|OL|PRE|TABLE|^H)/)
	{
	    $tag_prefix = $self->close_tag('P');
	}
	elsif ($open_tag eq 'LI' and $in_tag eq 'LI'
	    and $args{tag_type} ne 'end')
	{
	    # close a LI before the next LI
	    $tag_prefix = $self->close_tag('LI');
	}
	elsif ($open_tag eq 'LI' and $in_tag =~ /(UL|OL)/
	    and $args{tag_type} eq 'end')
	{
	    # close the LI before the list closes
	    $tag_prefix = $self->close_tag('LI');
	}
    }

    my $out_tag = $in_tag;
    if ($args{tag_type} eq 'end')
    {
	$out_tag = $self->close_tag($in_tag);
    }
    else
    {
	if ($self->{lower_case_tags})
	{
	    $out_tag =~ s/($in_tag)/\L$1/;
	}
	else # upper case
	{
	    $out_tag =~ s/($in_tag)/\U$1/;
	}
	if ($args{tag_type} eq 'empty')
	{
	    if ($self->{xhtml})
	    {
		$out_tag = "<${out_tag}${inside_tag}/>";
	    }
	    else
	    {
		$out_tag = "<${out_tag}${inside_tag}>";
	    }
	}
	else
	{
	    push @{$self->{__tags}}, $in_tag;
	    $out_tag = "<${out_tag}${inside_tag}>";
	}
    }
    $out_tag = $tag_prefix . $out_tag;
    if ($self->{dict_debug} & 8)
    {
	print STDERR "open_tag = '${open_tag}', in_tag = '${in_tag}', tag_type = ", $args{tag_type}, ", inside_tag = '${inside_tag}', out_tag = '$out_tag'\n";
    }

    return $out_tag;
}

# close the open tag
sub close_tag ($$) {
    my $self	    = shift;
    my $in_tag	    = shift;

    my $open_tag = @{$self->{__tags}}[$#{$self->{__tags}}];
    if (!$in_tag)
    {
	$in_tag = $open_tag;
    }
    my $out_tag = $in_tag;
    if ($self->{lower_case_tags})
    {
	$out_tag =~ s/($in_tag)/\L$1/;
    }
    else # upper case
    {
	$out_tag =~ s/($in_tag)/\U$1/;
    }
    $out_tag = "<\/${out_tag}>";
    if ($open_tag eq $in_tag)
    {
	pop @{$self->{__tags}};
    }
    if ($self->{dict_debug} & 8)
    {
	print STDERR "close_tag: open_tag = '${open_tag}', in_tag = '${in_tag}', out_tag = '$out_tag'\n";
    }

    return $out_tag;
}

sub hrule ($$$$) {
    my $self            = shift;
    my $para_lines_ref  = shift;
    my $para_action_ref = shift;
    my $ind		= shift;

    my $hrmin = $self->{hrule_min};
    if ($para_lines_ref->[$ind] =~ /^\s*([-_~=\*]\s*){$hrmin,}$/) {
	my $tag = $self->get_tag("HR", tag_type=>'empty');
        $para_lines_ref->[$ind] = "$tag\n";
	$para_action_ref->[$ind] |= $HRULE;
    }
    elsif ($para_lines_ref->[$ind] =~ /\014/) {
	# Linefeeds become horizontal rules
	$para_action_ref->[$ind] |= $HRULE;
	my $tag = $self->get_tag("HR", tag_type=>'empty');
        $para_lines_ref->[$ind] =~ s/\014/\n${tag}\n/g;
    }
}

sub shortline ($$$$$$$) {
    my $self            = shift;
    my $mode_ref        = shift;
    my $line_ref        = shift;
    my $line_action_ref = shift;
    my $prev_ref        = shift;
    my $prev_action_ref = shift;
    my $prev_line_len   = shift;

    # Short lines should be broken even on list item lines iff the
    # following line is more text.  I haven't figured out how to do
    # that yet.  For now, I'll just not break on short lines in lists.
    # (sorry)

    my $tag = $self->get_tag('BR', tag_type=>'empty');
    if (!(${$mode_ref} & ($PRE | $LIST | $TABLE))
        && !is_blank(${$line_ref})
        && !is_blank(${$prev_ref})
        && ($prev_line_len < $self->{short_line_length})
        && !(${$line_action_ref} & ($END | $HEADER | $HRULE | $LIST | $IND_BREAK| $PAR))
        && !(${$prev_action_ref} & ($HEADER | $HRULE | $BREAK | $IND_BREAK)))
    {
        ${$prev_ref} .= $tag . chop(${$prev_ref});
        ${$prev_action_ref} |= $BREAK;
    }
}

sub mailstuff ($$$$$$) {
    my $self            = shift;
    my $line_ref        = shift;
    my $line_action_ref = shift;
    my $prev_ref        = shift;
    my $prev_action_ref = shift;
    my $next_ref        = shift;

    my $tag = '';
    if (((${$line_ref} =~ /^\w*&gt/)    # Handle "FF> Werewolves."
        || (${$line_ref} =~ /^\w*\|/))    # Handle "Igor| There wolves."
        && !is_blank(${$next_ref})
      )
    {
	$tag = $self->get_tag('BR', tag_type=>'empty');
        ${$line_ref} =~ s/$/${tag}/;
        ${$line_action_ref} |= ($BREAK | $MAILQUOTE);
        if (!(${$prev_action_ref} & ($BREAK | $PAR))) {
	    $tag = $self->get_tag('P');
            ${$prev_ref} .= $tag;
            ${$line_action_ref} |= $PAR;
        }
    }
    elsif ((${$line_ref} =~ /^(From:?)|(Newsgroups:) /)
        && is_blank(${$prev_ref}))
    {
        $self->anchor_mail($line_ref)
          if !(${$prev_action_ref} & $MAILHEADER);
        chomp ${$line_ref};
	$tag = $self->get_tag('P');
	my $tag2 = $self->get_tag('BR', tag_type=>'empty');
        ${$line_ref} = "<!-- New Message -->\n$tag" . ${$line_ref} . "${tag2}\n";
        ${$line_action_ref} |= ($BREAK | $MAILHEADER | $PAR);
    }
    elsif ((${$line_ref} =~ /^[\w\-]*:/)    # Handle "Some-Header: blah"
        && (${$prev_action_ref} & $MAILHEADER) && !is_blank(${$next_ref})
      )
    {
	$tag = $self->get_tag('BR', tag_type=>'empty');
        ${$line_ref} =~ s/$/${tag}/;
        ${$line_action_ref} |= ($BREAK | $MAILHEADER);
    }
    elsif ((${$line_ref} =~ /^\s+\S/) &&    # Handle multi-line mail headers
        (${$prev_action_ref} & $MAILHEADER) && !is_blank(${$next_ref})
      )
    {
	$tag = $self->get_tag('BR', tag_type=>'empty');
        ${$line_ref} =~ s/$/${tag}/;
        ${$line_action_ref} |= ($BREAK | $MAILHEADER);
    }
}

# Subtracts modes listed in $mask from $vector.
sub subtract_modes ($$) {
    my ($vector, $mask) = @_;
    return ($vector | $mask) - $mask;
}

sub paragraph ($$$$$$) {
    my $self            = shift;
    my $mode_ref        = shift;
    my $line_ref        = shift;
    my $line_action_ref = shift;
    my $prev_ref        = shift;
    my $prev_action_ref = shift;
    my $line_indent     = shift;
    my $prev_indent     = shift;

    my $tag = '';
    if (!is_blank(${$line_ref})
        && !(${$mode_ref} & ($PRE | $TABLE))
        && !subtract_modes(${$line_action_ref},
            $END | $MAILQUOTE | $CAPS | $BREAK)
        && (is_blank(${$prev_ref})
            || (${$line_action_ref} & $END)
            || ($line_indent > $prev_indent + $self->{par_indent})))
    {
	if ($self->{indent_par_break}
	    && !is_blank(${$prev_ref})
	    && !(${$line_action_ref} & $END)
	    && ($line_indent > $prev_indent + $self->{par_indent}))
	{
	    $tag = $self->get_tag('BR', tag_type=>'empty');
	    ${$prev_ref} .= $tag;
	    ${$prev_ref} .= "&nbsp;" x $line_indent;
	    ${$line_ref} =~ s/^ {$line_indent}//;
	    ${$prev_action_ref} |= $BREAK;
	    ${$line_action_ref} |= $IND_BREAK;
	}
	elsif ($self->{preserve_indent})
	{
	    $tag = $self->get_tag('P');
	    ${$prev_ref} .= $tag;
	    ${$prev_ref} .= "&nbsp;" x $line_indent;
	    ${$line_ref} =~ s/^ {$line_indent}//;
	    ${$line_action_ref} |= $PAR;
	}
	else
	{
	    $tag = $self->get_tag('P');
	    ${$prev_ref} .= $tag;
	    ${$line_action_ref} |= $PAR;
	}
    }
    # detect also a continuing indentation at the same level
    elsif ($self->{indent_par_break}
        && !(${$mode_ref} & ($PRE | $TABLE | $LIST))
	&& !is_blank(${$prev_ref})
	&& !(${$line_action_ref} & $END)
	&& (${$prev_action_ref} & ($IND_BREAK | $PAR))
        && !subtract_modes(${$line_action_ref},
            $END | $MAILQUOTE | $CAPS)
        && ($line_indent > $self->{par_indent})
	&& ($line_indent == $prev_indent)
	)
    {
	$tag = $self->get_tag('BR', tag_type=>'empty');
	${$prev_ref} .= $tag;
	${$prev_ref} .= "&nbsp;" x $line_indent;
	${$line_ref} =~ s/^ {$line_indent}//;
	${$prev_action_ref} |= $BREAK;
	${$line_action_ref} |= $IND_BREAK;
    }
}

# If the line is blank, return the second argument.  Otherwise,
# return the number of spaces before any nonspaces on the line.
sub count_indent ($$) {
    my ($line, $prev_length) = @_;

    if (is_blank($line)) {
        return $prev_length;
    }
    my ($ws) = $line =~ /^( *)[^ ]/;
    return length($ws);
}

sub listprefix ($) {
    my $line = shift;

    my ($prefix, $number, $rawprefix);

    return (0, 0, 0)
      if (!($line =~ /^\s*[-=o\*\267]+\s+\S/)
        && !($line =~ /^\s*(\d+|[^\W\d_])[\.\)\]:]\s+\S/));

    ($number) = $line =~ /^\s*(\d+|[^\W\d_])/;
    $number = 0 unless defined($number);

    # That slippery exception of "o" as a bullet
    # (This ought to be determined using the context of what lists
    #  we have in progress, but this will probably work well enough.)
    if ($line =~ /^\s*o\s/) {
        $number = 0;
    }

    if ($number) {
        ($rawprefix) = $line =~ /^(\s*(\d+|[^\W\d_]).)/;
        $prefix = $rawprefix;
        $prefix =~ s/(\d+|[^\W\d_])//;    # Take the number out
    }
    else {
        ($rawprefix) = $line =~ /^(\s*[-=o\*\267]+.)/;
        $prefix = $rawprefix;
    }
    ($prefix, $number, $rawprefix);
}

sub startlist ($$$$$$$$) {
    my $self		= shift;
    my $prefix		= shift;
    my $number		= shift;
    my $rawprefix	= shift;
    my $para_lines_ref	= shift;
    my $para_action_ref	= shift;
    my $ind		= shift;
    my $prev_ref  = shift;

    my $tag = '';
    $self->{__listprefix}->[$self->{__listnum}] = $prefix;
    if ($number) {

        # It doesn't start with 1,a,A.  Let's not screw with it.
        if (($number ne "1") && ($number ne "a") && ($number ne "A")) {
            return 0;
        }
	$tag = $self->get_tag('OL');
        ${$prev_ref} .= $self->{__list_indent} . "${tag}\n";
        $self->{__list}->[$self->{__listnum}] = $OL;
    }
    else {
	$tag = $self->get_tag('UL');
        ${$prev_ref} .= $self->{__list_indent} . "${tag}\n";
        $self->{__list}->[$self->{__listnum}] = $UL;
    }

    $self->{__listnum}++;
    $self->{__list_indent} = " " x $self->{__listnum} x $self->{indent_width};
    $para_action_ref->[$ind] |= $LIST;
    $para_action_ref->[$ind] |= $LIST_START;
    $self->{__mode} |= $LIST;
    1;
}

# End N lists
sub endlist ($$$$) {
    my $self            = shift;
    my $n               = shift;
    my $prev_ref        = shift;
    my $line_action_ref = shift;

    my $tag = '';
    for (; $n > 0 ; $n--, $self->{__listnum}--) {
        $self->{__list_indent} =
          " " x ($self->{__listnum} - 1) x $self->{indent_width};
        if ($self->{__list}->[$self->{__listnum} - 1] == $UL) {
	    $tag = $self->get_tag('UL', tag_type=>'end');
            ${$prev_ref} .= $self->{__list_indent} . "${tag}\n";
#	    if ($self->{__listnum} > 1)
#	    {
#		$tag = $self->get_tag('LI', tag_type=>'end');
#		${$prev_ref} .= $self->{__list_indent} . "${tag}\n";
#	    }
        }
        elsif ($self->{__list}->[$self->{__listnum} - 1] == $OL) {
	    $tag = $self->get_tag('OL', tag_type=>'end');
            ${$prev_ref} .= $self->{__list_indent} . "${tag}\n";
#	    if ($self->{__listnum} > 1)
#	    {
#		$tag = $self->get_tag('LI', tag_type=>'end');
#		${$prev_ref} .= $self->{__list_indent} . "${tag}\n";
#	    }
        }
        else {
            print STDERR "Encountered list of unknown type\n";
        }
    }
    ${$line_action_ref} |= $END;
    $self->{__mode} ^= $LIST if (!$self->{__listnum});
}

sub continuelist ($$$$) {
    my $self            = shift;
    my $para_lines_ref	= shift;
    my $para_action_ref	= shift;
    my $ind		= shift;

    my $list_indent = $self->{__list_indent};
    my $tag = '';
    if ($self->{__list}->[$self->{__listnum} - 1] == $UL
	&& $para_lines_ref->[$ind] =~ /^\s*[-=o\*\267]+\s*/)
    {
#	if ($ind > 0
#	    && ($para_action_ref->[$ind - 1] & $LIST_ITEM))
#	{
#	    $tag = $self->get_tag('LI', tag_type=>'end');
#	    $para_lines_ref->[$ind - 1] .= $tag;
#	}
	$tag = $self->get_tag('LI');
	$para_lines_ref->[$ind] =~ s/^\s*[-=o\*\267]+\s*/${list_indent}${tag}/;
	$para_action_ref->[$ind] |= $LIST_ITEM;
    }
    if ($self->{__list}->[$self->{__listnum} - 1] == $OL)
    {
#	if ($ind > 0
#	    && ($para_action_ref->[$ind - 1] & $LIST_ITEM))
#	{
#	    $tag = $self->get_tag('LI', tag_type=>'end');
#	    $para_lines_ref->[$ind - 1] .= $tag;
#	}
	$tag = $self->get_tag('LI');
	$para_lines_ref->[$ind] =~ s/^\s*(\d+|[^\W\d_]).\s*/${list_indent}${tag}/;
	$para_action_ref->[$ind] |= $LIST_ITEM;
    }
    $para_action_ref->[$ind] |= $LIST;
}

sub liststuff ($$$$$$) {
    my $self            = shift;
    my $para_lines_ref	= shift;
    my $para_action_ref	= shift;
    my $para_line_indent_ref = shift;
    my $ind		= shift;
    my $prev_ref	= shift;

    my $i;

    my ($prefix, $number, $rawprefix) = listprefix($para_lines_ref->[$ind]);

    if (!$prefix) {
	# if the previous line is not blank
	if ($ind > 0 && !is_blank($para_lines_ref->[$ind - 1]))
	{
	    # inside a list item
	    return;
	}
             # This ain't no list.  We'll want to end all of them.
        if ($self->{__listnum}) {
            $self->endlist($self->{__listnum}, $prev_ref,
		\$para_action_ref->[$ind]);
        }
        return;
    }

    # If numbers with more than one digit grow to the left instead of
    # to the right, the prefix will shrink and we'll fail to match the
    # right list.  We need to account for this.
    my $prefix_alternate;
    if (length("" . $number) > 1) {
        $prefix_alternate = (" " x (length("" . $number) - 1)) . $prefix;
    }

    # Maybe we're going back up to a previous list
    for ($i = $self->{__listnum} - 1 ;
        ($i >= 0) && ($prefix ne $self->{__listprefix}->[$i]) ; $i--
      )
    {
        if (length("" . $number) > 1) {
            last if $prefix_alternate eq $self->{__listprefix}->[$i];
        }
    }

    my $islist;

    # Measure the indent from where the text starts, not where the
    # prefix starts.  This won't screw anything up, and if we don't do
    # it, the next line might appear to be indented relative to this
    # line, and get tagged as a new paragraph.
    my ($total_prefix) = $para_lines_ref->[$ind] =~ /^(\s*[\w=o\*-]+.\s*)/;

    # Of course, we only use it if it really turns out to be a list.

    $islist = 1;
    $i++;
    if (($i > 0) && ($i != $self->{__listnum})) {
        $self->endlist($self->{__listnum} - $i, $prev_ref,
		\$para_action_ref->[$ind]);
        $islist = 0;
    }
    elsif (!$self->{__listnum} || ($i != $self->{__listnum})) {
        if (($para_line_indent_ref->[$ind] > 0)
	    || $ind == 0
            || ($ind > 0 && is_blank($para_lines_ref->[$ind - 1]))
            || ($ind > 0
		&& $para_action_ref->[$ind - 1] & ($BREAK | $HEADER | $CAPS))
	    )
        {
            $islist = $self->startlist($prefix, $number, $rawprefix,
		$para_lines_ref, $para_action_ref, $ind,
		$prev_ref);
        }
        else {

            # We have something like this: "- foo" which usually
            # turns out not to be a list.
            return;
        }
    }

    $self->continuelist($para_lines_ref, $para_action_ref, $ind)
      if ($self->{__mode} & $LIST);
    $para_line_indent_ref->[$ind] = length($total_prefix) if $islist;
}

sub tablestuff ($$$) {
    my $self     = shift;
    my $rows_ref = shift;
    my $para_len = shift;

    # TABLES: spot and mark up tables.  We combine the lines of the
    # paragraph using the string bitwise or (|) operator, the result
    # being in $spaces.  A character in $spaces is a space only if
    # there was a space at that position in every line of the
    # paragraph.  $space can be used to search for contiguous spaces
    # that occur on all lines of the paragraph.  If this results in at
    # least two columns, the paragraph is identified as a table.

    # Note that this sub must be called before checking for preformatted
    # lines because a table may well have whitespace to the left, in
    # which case it must not be incorrectly recognised as a preformat.
    my @rows = @{$rows_ref};
    my @starts;
    my @ends;
    my $spaces;
    my $max = 0;
    my $min = $para_len;
    foreach my $row (@rows) {
        ($spaces |= $row) =~ tr/ /\xff/c;
        $min = length $row if length $row < $min;
        $max = length $row if $max < length $row;
    }
    $spaces = substr $spaces, 0, $min;
    push (@starts, 0) unless $spaces =~ /^ /;
    while ($spaces =~ /((?:^| ) +)(?=[^ ])/g) {
        push @ends,   pos($spaces) - length $1;
        push @starts, pos($spaces);
    }
    shift (@ends) if $spaces =~ /^ /;
    push (@ends, $max);

    # Two or more rows and two or more columns indicate a table.
    if (2 <= @rows and 2 <= @starts) {
        $self->{__mode} |= $TABLE;

        # For each column, guess whether it should be left, centre or
        # right aligned by examining all cells in that column for space
        # to the left or the right.  A simple majority among those cells
        # that actually have space to one side or another decides (if no
        # alignment gets a majority, left alignment wins by default).
        my @align;
        my $cell = '';
        foreach my $col (0 .. $#starts) {
            my @count = (0, 0, 0, 0);
            foreach my $row (@rows) {
                my $width = $ends[$col] - $starts[$col];
                $cell = substr $row, $starts[$col], $width;
                ++$count[($cell =~ /^ / ? 2 : 0) +
                  ($cell =~ / $/ || length($cell) < $width ? 1 : 0)];
            }
            $align[$col] = 0;
            my $population = $count[1] + $count[2] + $count[3];
            foreach (1 .. 3) {
                if ($count[$_] * 2 > $population) {
                    $align[$col] = $_;
                    last;
                }
            }
        }

        foreach my $row (@rows) {
            $row = join '', $self->get_tag('TR'), (
              map {
                  $cell = substr $row, $starts[$_], $ends[$_] - $starts[$_];
                  $cell =~ s/^ +//;
                  $cell =~ s/ +$//;

                  if ($self->{escape_HTML_chars}) {
                      $cell = escape($cell);
                  }

                  ($self->get_tag('TD', 
		    inside_tag=>($self->{xhtml}
			? $xhtml_alignments[$align[$_]]
			: ($self->{lower_case_tags}
			    ? $lc_alignments[$align[$_]]
			    : $alignments[$align[$_]]))),
		    $cell, $self->close_tag('TD'));
              } 0 .. $#starts),
              $self->close_tag('TR');
        }

        # put the <TABLE> around the rows
	my $tag;
	if ($self->{xhtml})
	{
	    $tag = $self->get_tag('TABLE', inside_tag=>' summary=""');
	}
	else
	{
	    $tag = $self->get_tag('TABLE');
	}
        $rows[0] = "${tag}\n" . $rows[0];
	$tag = $self->get_tag('TABLE', tag_type=>'end');
        $rows[$#rows] .= "\n${tag}";
        @{$rows_ref} = @rows;
        return 1;
    }
    else {
        return 0;
    }
}

# Returns true if the passed string is considered to be preformatted
sub is_preformatted ($$) {
    my $self = shift;
    my $line = shift;

    my $pre_white_min = $self->{preformat_whitespace_min};
    my $result = (($line =~ /\s{$pre_white_min,}\S+/o)    # whitespaces
      || ($line =~ /\.{$pre_white_min,}\S+/o));    # dots
    return $result;
}

sub endpreformat ($$$$$) {
    my $self            = shift;
    my $mode_ref        = shift;
    my $para_lines_ref  = shift;
    my $para_action_ref = shift;
    my $ind		= shift;
    my $prev_ref        = shift;

    my $tag = '';
    if (${$mode_ref} & $PRE_EXPLICIT) {
	my $pe_mark = $self->{preformat_end_marker};
        if ($para_lines_ref->[$ind] =~ /$pe_mark/io) {
	    if ($ind == 0)
	    {
		$tag = $self->get_tag('PRE', tag_type=>'end');
		$para_lines_ref->[$ind] = "${tag}\n";
	    }
	    else
	    {
		$tag = $self->get_tag('PRE', tag_type=>'end');
		$para_lines_ref->[$ind - 1] .= "${tag}\n";
		$para_lines_ref->[$ind] = "";
	    }
            ${$mode_ref} ^= (($PRE | $PRE_EXPLICIT) & ${$mode_ref});
	    $para_action_ref->[$ind] |= $END;
        }
        return;
    }

    if (!$self->is_preformatted($para_lines_ref->[$ind])
        && ($self->{endpreformat_trigger_lines} == 1
            || ($ind + 1 < @{$para_lines_ref}
		&& !$self->is_preformatted($para_lines_ref->[$ind + 1]))
	    || $ind + 1 >= @{$para_lines_ref} # last line of para
		)
	)
    {
	if ($ind == 0)
	{
	    $tag = $self->get_tag('PRE', tag_type=>'end');
	    ${$prev_ref} = "${tag}\n";
	}
	else
	{
	    $tag = $self->get_tag('PRE', tag_type=>'end');
	    $para_lines_ref->[$ind - 1] .= "${tag}\n";
	}
        ${$mode_ref} ^= ($PRE & ${$mode_ref});
	$para_action_ref->[$ind] |= $END;
    }
}

sub preformat ($$$$$$) {
    my $self            = shift;
    my $mode_ref        = shift;
    my $line_ref        = shift;
    my $line_action_ref = shift;
    my $prev_ref        = shift;
    my $next_ref        = shift;

    my $tag = '';
    if ($self->{use_preformat_marker}) {
        my $pstart = $self->{preformat_start_marker};
        if (${$line_ref} =~ /$pstart/io) {
            if (${$prev_ref} =~ s/<P>$//)
	    {
		pop @{$self->{__tags}};
	    }
	    $tag = $self->get_tag('PRE');
            ${$line_ref} = "${tag}\n";
            ${$mode_ref} |= $PRE | $PRE_EXPLICIT;
            ${$line_action_ref} |= $PRE;
            return;
        }
    }

    if ($self->{preformat_trigger_lines} == 0
        || ($self->is_preformatted(${$line_ref})
            && ($self->{preformat_trigger_lines} == 1
                || $self->is_preformatted(${$next_ref}))))
    {
	if (${$prev_ref} =~ s/<P>$//)
	{
	    pop @{$self->{__tags}};
	}
	$tag = $self->get_tag('PRE');
        ${$line_ref} =~ s/^/${tag}\n/;
        ${$mode_ref} |= $PRE;
        ${$line_action_ref} |= $PRE;
    }
}

sub make_new_anchor ($$) {
    my $self          = shift;
    my $heading_level = shift;

    my ($anchor, $i);

    return sprintf("%d", $self->{__non_header_anchor}++) if (!$heading_level);

    $anchor = "section-";
    $self->{__heading_count}->[$heading_level - 1]++;

    # Reset lower order counters
    for ($i = @{$self->{__heading_count}} ; $i > $heading_level ; $i--) {
        $self->{__heading_count}->[$i - 1] = 0;
    }

    for ($i = 0 ; $i < $heading_level ; $i++) {
        $self->{__heading_count}->[$i] = 1
          if !$self->{__heading_count}->[$i];    # In case they skip any
        $anchor .= sprintf("%d.", $self->{__heading_count}->[$i]);
    }
    chomp($anchor);
    $anchor;
}

sub anchor_mail ($$) {
    my $self     = shift;
    my $line_ref = shift;

    if ($self->{make_anchors}) {
        my ($anchor) = $self->make_new_anchor(0);
	if ($self->{lower_case_tags}) {
	    ${$line_ref} =~ s/([^ ]*)/<a name="$anchor">$1<\/a>/;
	} else {
	    ${$line_ref} =~ s/([^ ]*)/<A NAME="$anchor">$1<\/A>/;
	}
    }
}

sub anchor_heading ($$$) {
    my $self     = shift;
    my $level    = shift;
    my $line_ref = shift;

    if ($self->{dict_debug} & 8) {
	print STDERR "anchor_heading: ", ${$line_ref}, "\n";
    }
    if ($self->{make_anchors}) {
        my ($anchor) = $self->make_new_anchor($level);
	if ($self->{lower_case_tags}) {
	    ${$line_ref} =~ s/(<h.>)(.*)(<\/h.>)/$1<a name="$anchor">$2<\/a>$3/;
	} else {
	    ${$line_ref} =~ s/(<H.>)(.*)(<\/H.>)/$1<A NAME="$anchor">$2<\/A>$3/;
	}
    }
    if ($self->{dict_debug} & 8) {
	print STDERR "anchor_heading(after): ", ${$line_ref}, "\n";
    }
}

sub heading_level ($$) {
    my $self = shift;

    my ($style) = @_;
    $self->{__heading_styles}->{$style} = ++$self->{__num_heading_styles}
      if !$self->{__heading_styles}->{$style};
    $self->{__heading_styles}->{$style};
}

sub heading ($$$$) {
    my $self            = shift;
    my $line_ref        = shift;
    my $line_action_ref = shift;
    my $next_ref        = shift;

    my ($hoffset, $heading) = ${$line_ref} =~ /^(\s*)(.+)$/;
    $hoffset = "" unless defined($hoffset);
    $heading = "" unless defined($heading);
    $heading =~ s/&[^;]+;/X/g;    # Unescape chars so we get an accurate length
    my ($uoffset, $underline) = ${$next_ref} =~ /^(\s*)(\S+)\s*$/;
    $uoffset   = "" unless defined($uoffset);
    $underline = "" unless defined($underline);
    my ($lendiff, $offsetdiff);
    $lendiff = length($heading) - length($underline);
    $lendiff *= -1 if $lendiff < 0;

    $offsetdiff = length($hoffset) - length($uoffset);
    $offsetdiff *= -1 if $offsetdiff < 0;

    if (is_blank(${$line_ref})
        || ($lendiff > $self->{underline_length_tolerance})
        || ($offsetdiff > $self->{underline_offset_tolerance}))
    {
        return;
    }

    $underline = substr($underline, 0, 1);

    # Call it a different style if the heading is in all caps.
    $underline .= "C" if $self->iscaps(${$line_ref});
    ${$next_ref} = " ";    # Eat the underline
    $self->{__heading_level} = $self->heading_level($underline);
    $self->tagline("H" . $self->{__heading_level}, $line_ref);
    $self->anchor_heading($self->{__heading_level}, $line_ref);
    ${$line_action_ref} |= $HEADER;
}

sub custom_heading ($$$$) {
    my $self            = shift;
    my $para_lines_ref  = shift;
    my $para_action_ref = shift;
    my $ind		= shift;

    my $line_ref        = shift;
    my $line_action_ref = shift;

    my ($i, $level);
    for ($i = 0 ; $i < @{$self->{custom_heading_regexp}} ; $i++) {
        my $reg = ${$self->{custom_heading_regexp}}[$i];
        if ($para_lines_ref->[$ind] =~ /$reg/) {
            if ($self->{explicit_headings}) {
                $level = $i + 1;
            }
            else {
                $level = $self->heading_level("Cust" . $i);
            }
            $self->tagline("H" . $level, \$para_lines_ref->[$ind]);
            $self->anchor_heading($level, \$para_lines_ref->[$ind]);
            $para_action_ref->[$ind] |= $HEADER;
            last;
        }
    }
}

sub unhyphenate_para ($$) {
    my $self     = shift;
    my $para_ref = shift;

    # Treating this whole paragraph as one string, look for
    # 1 - whitespace
    # 2 - a word (ending in a hyphen, followed by a newline)
    # 3 - whitespace (starting on the next line)
    # 4 - a word with its punctuation
    # Substitute this with
    # 1-whitespace 2-word 4-word newline 3-whitespace
    # We preserve the 3-whitespace because we don't want to mess up
    # our existing indentation.
    ${$para_ref} =~
      /(\s*)([^\W\d_]*)\-\n(\s*)([^\W\d_]+[\)\}\]\.,:;\'\"\>]*\s*)/s;
    ${$para_ref} =~
s/(\s*)([^\W\d_]*)\-\n(\s*)([^\W\d_]+[\)\}\]\.,:;\'\"\>]*\s*)/$1$2$4\n$3/gs;
}

sub untabify ($$) {
    my $self = shift;
    my $line = shift;

    while ($line =~ /\011/) {
	my $tw = $self->{tab_width};
        $line =~ s/\011/" " x ($tw - (length($`) % $tw))/e;
    }
    $line;
}

sub tagline ($$$) {
    my $self     = shift;
    my $tag      = shift;
    my $line_ref = shift;

    chomp ${$line_ref};    # Drop newline
    my $tag1 = $self->get_tag($tag);
    my $tag2 = $self->get_tag($tag, tag_type=>'end');
    ${$line_ref} =~ s/^\s*(.*)$/${tag1}$1${tag2}\n/;
}

sub iscaps {
    my $self = shift;
    local ($_) = @_;

    my $min_caps_len = $self->{min_caps_length};

    # This is ugly, but I don't know a better way to do it.
    # (And, yes, I could use the literal characters instead of the 
    # numeric codes, but this keeps the script 8-bit clean, which will
    # save someone a big headache when they transfer via ASCII ftp.
/^[^a-z\341\343\344\352\353\354\363\370\337\373\375\342\345\347\350\355\357\364\365\376\371\377\340\346\351\360\356\361\362\366\372\374<]*[A-Z\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317\320\321\322\323\324\325\326\330\331\332\333\334\335\336]{$min_caps_len,}[^a-z\341\343\344\352\353\354\363\370\337\373\375\342\345\347\350\355\357\364\365\376\371\377\340\346\351\360\356\361\362\366\372\374<]*$/;
}

sub caps {
    my $self            = shift;
    my $line_ref        = shift;
    my $line_action_ref = shift;

    if ($self->iscaps(${$line_ref})) {
        $self->tagline($self->{caps_tag}, $line_ref);
        ${$line_action_ref} |= $CAPS;
    }
}

# Convert very simple globs to regexps
sub glob2regexp {
    my ($glob) = @_;

    # Escape funky chars
    $glob =~ s/[^\w\[\]\*\?\|\\]/\\$&/g;
    my ($regexp, $i, $len, $escaped) = ("", 0, length($glob), 0);

    for (; $i < $len ; $i++) {
        my $char = substr($glob, $i, 1);
        if ($escaped) {
            $escaped = 0;
            $regexp .= $char;
            next;
        }
        if ($char eq "\\") {
            $escaped = 1;
            next;
            $regexp .= $char;
        }
        if ($char eq "?") {
            $regexp .= ".";
            next;
        }
        if ($char eq "*") {
            $regexp .= ".*";
            next;
        }
        $regexp .= $char;    # Normal character
    }
    "\\b" . $regexp . "\\b";
}

sub add_regexp_to_links_table ($$$$) {
    my $self = shift;
    my ($key, $URL, $switches) = @_;

    # No sense adding a second one if it's already in there.
    # It would never get used.
    if (!$self->{__links_table}->{$key}) {

        # Keep track of the order they were added so we can
        # look for matches in the same order
        push (@{$self->{__links_table_order}}, ($key));

        $self->{__links_table}->{$key}        = $URL;      # Put it in The Table
        $self->{__links_switch_table}->{$key} = $switches;
	my $ind = @{$self->{__links_table_order}} - 1;
        print STDERR " (", $ind,
          ")\tKEY: $key\n\tVALUE: $URL\n\tSWITCHES: $switches\n\n"
          if ($self->{dict_debug} & 1);
    }
    else {
        if ($self->{dict_debug} & 1) {
            print STDERR " Skipping entry.  Key already in table.\n";
            print STDERR "\tKEY: $key\n\tVALUE: $URL\n\n";
        }
    }
}

sub add_literal_to_links_table ($$$$) {
    my $self = shift;
    my ($key, $URL, $switches) = @_;

    $key =~ s/(\W)/\\$1/g;    # Escape non-alphanumeric chars
    $key = "\\b$key\\b";      # Make a regexp out of it
    $self->add_regexp_to_links_table($key, $URL, $switches);
}

sub add_glob_to_links_table ($$$$) {
    my $self = shift;
    my ($key, $URL, $switches) = @_;

    $self->add_regexp_to_links_table(glob2regexp($key), $URL, $switches);
}

# This is the only function you should need to change if you want to
# use a different dictionary file format.
sub parse_dict ($$$) {
    my $self = shift;

    my ($dictfile, $dict) = @_;

    print STDERR "Parsing dictionary file $dictfile\n"
      if ($self->{dict_debug} & 1);

    $dict =~ s/^\#.*$//mg;           # Strip lines that start with '#'
    $dict =~ s/^.*[^\\]:\s*$//mg;    # Strip lines that end with unescaped ':'

    if ($dict =~ /->\s*->/) {
        my $message = "Two consecutive '->'s found in $dictfile\n";
        my $near;

        # Print out any useful context so they can find it.
        ($near) = $dict =~ /([\S ]*\s*->\s*->\s*\S*)/;
        $message .= "\n$near\n" if $near =~ /\S/;
        die $message;
    }

    my ($key, $URL, $switches, $options);
    while ($dict =~ /\s*(.+)\s+\-+([iehos]+\-+)?\>\s*(.*\S+)\s*\n/ig) {
        $key      = $1;
        $options  = $2;
        $options  = "" unless defined($options);
        $URL      = $3;
        $switches = 0;
	# Case insensitivity
        $switches += $LINK_NOCASE if $options =~ /i/i;
	# Evaluate as Perl code
        $switches += $LINK_EVAL if $options =~ /e/i;
	# provides HTML, not just URL
        $switches += $LINK_HTML if $options =~ /h/i;
	# Only do this link once
        $switches += $LINK_ONCE if $options =~ /o/i;
	# Only do this link once per section
        $switches += $LINK_SECT_ONCE if $options =~ /s/i;

        $key =~ s/\s*$//;                      # Chop trailing whitespace

        if ($key =~ m|^/|)                     # Regexp
        {
            $key = substr($key, 1);
            $key =~ s|/$||;    # Allow them to forget the closing /
            $self->add_regexp_to_links_table($key, $URL, $switches);
        }
        elsif ($key =~ /^\|/)    # alternate regexp format
        {
            $key = substr($key, 1);
            $key =~ s/\|$//;      # Allow them to forget the closing |
            $key =~ s|/|\\/|g;    # Escape all slashes
            $self->add_regexp_to_links_table($key, $URL, $switches);
        }
        elsif ($key =~ /\"/) {
            $key = substr($key, 1);
            $key =~ s/\"$//;    # Allow them to forget the closing "
            $self->add_literal_to_links_table($key, $URL, $switches);
        }
        else {
            $self->add_glob_to_links_table($key, $URL, $switches);
        }
    }

}

sub setup_dict_checking ($) {
    my $self = shift;

    # now create the replace funcs and precomile the regexes
    my ($key, $URL, $switches, $options, $tag1, $tag2);
    my ($pattern, $href, $i, $r_sw, $code, $code_ref);
    for ($i = 1 ; $i < @{$self->{__links_table_order}} ; $i++) {
        $pattern  = $self->{__links_table_order}->[$i];
        $key      = $pattern;
        $switches = $self->{__links_switch_table}->{$key};

        $href = $self->{__links_table}->{$key};

        if (!($switches & $LINK_HTML))
	{
	    $href =~ s#/#\\/#g;
	    if ($self->{lower_case_tags})
	    {
		$href = '<a href="' . $href . '">$&<\\/a>'
	    }
	    else
	    {
		$href = '<A HREF="' . $href . '">$&<\\/A>'
	    }
	}
	else
	{
	    # change the uppercase tags to lower case
	    if ($self->{lower_case_tags})
	    {
		$href =~ s#(</)([A-Z]*)(>)#${1}\L${2}${3}#g;
		$href =~ s/(<)([A-Z]*)(>)/${1}\L${2}${3}/g;
		# and the anchors
		$href =~ s/(<)(A\s*HREF)([^>]*>)/$1\L$2$3/g;
	    }
	    $href =~ s#/#\\/#g;
	}

        $r_sw = "s";    # Options for replacing
        $r_sw .= "i" if ($switches & $LINK_NOCASE);
        $r_sw .= "e" if ($switches & $LINK_EVAL);

        # Generate code for replacements.
        # Create an anonymous subroutine for each replacement,
        # and store its reference in an array.
        # We need to do an "eval" to create these because we need to
        # be able to treat the *contents* of the $href variable
        # as if it were perl code, because sometimes the $href
        # contains things which need to be evaluated, such as $& or $1,
        # not just those cases where we have a "e" switch.
        $code =
"\$self->{__repl_code}->[$i] = sub {\nmy \$al = shift;\n\$al =~ s/$pattern/$href/$r_sw;\nreturn \$al; }\n";
        print STDERR "$code" if ($self->{dict_debug} & 2);
        eval "$code";

        # compile searching pattern
        if ($switches & $LINK_NOCASE)    # i
        {
            $self->{__search_patterns}->[$i] = qr/$pattern/si;
        }
        else {
            $self->{__search_patterns}->[$i] = qr/$pattern/s;
        }
    }
}

sub in_link_context ($$$) {
    my $self		 = shift;
    my ($match, $before) = @_;
    return 1 if $match =~ m@</?A>@i;    # No links allowed inside match

    my ($final_open, $final_close);
    if ($self->{lower_case_tags}) {
	$final_open  = rindex($before, "<a ") - $[;
	$final_close = rindex($before, "</a>") - $[;
    }
    else {
	$final_open  = rindex($before, "<A ") - $[;
	$final_close = rindex($before, "</A>") - $[;
    }

    return 1 if ($final_open >= 0)      # Link opened
      && (($final_close < 0)            # and not closed    or
        || ($final_open > $final_close)
    );    # one opened after last close

    # Now check to see if we're inside a tag, matching a tag name, 
    # or attribute name or value
    $final_open  = rindex($before, "<") - $[;
    $final_close = rindex($before, ">") - $[;
    ($final_open >= 0)    # Tag opened
      && (($final_close < 0)    # and not closed    or
        || ($final_open > $final_close)
    );    # one opened after last close
}

# clear the section-links flags
sub clear_section_links ($) {
    my $self            = shift;

    $self->{__done_with_sect_link} = [];
}

# Check (and alter if need be) the bits in this line matching
# the patterns in the link dictionary.
sub check_dictionary_links ($$$) {
    my $self            = shift;
    my $line_ref        = shift;
    my $line_action_ref = shift;

    my ($i, $pattern, $switches, $options, $repl_func);
    my $key;
    my $s_sw;
    my $r_sw;
    my ($line_link) = (${$line_action_ref} | $LINK);
    my ($before, $linkme, $line_with_links);

    # for each pattern, check and alter the line
    for ($i = 1 ; $i < @{$self->{__links_table_order}} ; $i++) {
        $pattern  = $self->{__links_table_order}->[$i];
        $key      = $pattern;
        $switches = $self->{__links_switch_table}->{$key};

        # check the pattern
        if ($switches & $LINK_ONCE)    # Do link only once
        {
            $line_with_links = "";
            while (!$self->{__done_with_link}->[$i]
                && ${$line_ref} =~ $self->{__search_patterns}->[$i])
            {
                $self->{__done_with_link}->[$i] = 1;
                $line_link = $LINK if (!$line_link);
                $before    = $`;
                $linkme    = $&;

                ${$line_ref} =
                  substr(${$line_ref}, length($before) + length($linkme));
                if (!$self->in_link_context($linkme, $line_with_links . $before)) {
                    print STDERR "Link rule $i matches $linkme\n"
                      if ($self->{dict_debug} & 4);

                    # call the special subroutine already created to do
                    # this replacement
                    $repl_func = $self->{__repl_code}->[$i];
                    $linkme    = &$repl_func($linkme);
                }
                $line_with_links .= $before . $linkme;
            }
            ${$line_ref} = $line_with_links . ${$line_ref};
        }
        elsif ($switches & $LINK_SECT_ONCE)    # Do link only once per section
        {
            $line_with_links = "";
            while (!$self->{__done_with_sect_link}->[$i]
                && ${$line_ref} =~ $self->{__search_patterns}->[$i])
            {
                $self->{__done_with_sect_link}->[$i] = 1;
                $line_link = $LINK if (!$line_link);
                $before    = $`;
                $linkme    = $&;

                ${$line_ref} =
                  substr(${$line_ref}, length($before) + length($linkme));
                if (!$self->in_link_context($linkme, $line_with_links . $before)) {
                    print STDERR "Link rule $i matches $linkme\n"
                      if ($self->{dict_debug} & 4);

                    # call the special subroutine already created to do
                    # this replacement
                    $repl_func = $self->{__repl_code}->[$i];
                    $linkme    = &$repl_func($linkme);
                }
                $line_with_links .= $before . $linkme;
            }
            ${$line_ref} = $line_with_links . ${$line_ref};
        }
        else {
            $line_with_links = "";
            while (${$line_ref} =~ $self->{__search_patterns}->[$i]) {
                $line_link = $LINK if (!$line_link);
                $before    = $`;
                $linkme    = $&;

                ${$line_ref} =
                  substr(${$line_ref}, length($before) + length($linkme));
                if (!$self->in_link_context($linkme, $line_with_links . $before)) {
                    print STDERR "Link rule $i matches $linkme\n"
                      if ($self->{dict_debug} & 4);

                    # call the special subroutine already created to do
                    # this replacement
                    $repl_func = $self->{__repl_code}->[$i];
                    $linkme    = &$repl_func($linkme);
                }
                $line_with_links .= $before . $linkme;
            }
            ${$line_ref} = $line_with_links . ${$line_ref};
        }
    }
    ${$line_action_ref} |= $line_link;    # Cheaper only to do bitwise OR once.
}

sub load_dictionary_links ($) {
    my $self = shift;
    my ($dict, $contents);
    @{$self->{__links_table_order}} = 0;
    %{$self->{__links_table}}       = ();

    foreach $dict (@{$self->{links_dictionaries}}) {
        next unless $dict;
	    open(DICT, "$dict") || die "Can't open Dictionary file $dict\n";

	    $contents = "";
	    $contents .= $_ while (<DICT>);
	    close(DICT);
	    $self->parse_dict($dict, $contents);
    }
    $self->setup_dict_checking();
}

sub make_dictionary_links ($$$) {
    my $self            = shift;
    my $line_ref        = shift;
    my $line_action_ref = shift;

    $self->check_dictionary_links($line_ref, $line_action_ref);
    warn $@ if $@;
}

# do_file_start
#    extra stuff needed for the beginning
# Args:
#   $self
#   $para
# Return:
#   processed $para string
sub do_file_start ($$$) {
    my $self      = shift;
    my $outhandle = shift;
    my $para      = shift;

    if (!$self->{extract}) {
        my @para_lines = split (/\n/, $para);
        my $first_line = $para_lines[0];

	if ($self->{doctype})
	{
	    if ($self->{xhtml})
	    {
		print $outhandle '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"', "\n";
		print $outhandle '"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">', "\n";
	    }
	    else
	    {
		print $outhandle '<!DOCTYPE HTML PUBLIC "' . $self->{doctype} . "\">\n";
	    }
	}
        print $outhandle $self->get_tag('HTML'), "\n";
        print $outhandle $self->get_tag('HEAD'), "\n";

        # if --titlefirst is set and --title isn't, use the first line
        # as the title.
        if ($self->{titlefirst} && !$self->{title}) {
            my ($tit) = $first_line =~ /^ *(.*)/;    # grab first line
            $tit =~ s/ *$//;                         # strip trailing whitespace
            $tit = escape($tit) if $self->{escape_HTML_chars};
            $self->{'title'} = $tit;
        }
        if (!$self->{title}) {
            $self->{'title'} = "";
        }
        print $outhandle $self->get_tag('TITLE'), $self->{title},
	    $self->get_tag('TITLE', tag_type=>'end'), "\n";

        if ($self->{append_head}) {
            open(APPEND, $self->{append_head})
              || die "Failed to open ", $self->{append_head}, "\n";
            while (<APPEND>) {
                print $outhandle $_;
            }
            close(APPEND);
        }

	if ($self->{lower_case_tags})
	{
	    print $outhandle $self->get_tag('META', tag_type=>'empty',
		inside_tag=>" name=\"generator\" content=\"$PROG v$VERSION\""),
		"\n";
	}
	else
	{
	    print $outhandle $self->get_tag('META', tag_type=>'empty',
		inside_tag=>" NAME=\"generator\" CONTENT=\"$PROG v$VERSION\""),
		"\n";
	}
        print $outhandle $self->get_tag('HEAD', tag_type=>'end'), "\n";
        print $outhandle $self->get_tag('BODY'), "\n";
    }

    if ($self->{prepend_file}) {
        if (-r $self->{prepend_file}) {
            open(PREPEND, $self->{prepend_file});
            while (<PREPEND>) {
                print $outhandle $_;
            }
            close(PREPEND);
        }
        else {
            print STDERR "Can't find or read file ", $self->{prepend_file},
              " to prepend.\n";
        }
    }
}

# do_init_call
# certain things, like reading link dictionaries, need to be
# done once
sub do_init_call ($) {
    my $self     = shift;

    if (!$self->{__call_init_done}) {
	push (@{$self->{links_dictionaries}}, ($self->{default_link_dict}))
	  if ($self->{make_links} && (-f $self->{default_link_dict}));
	$self->deal_with_options();
	if ($self->{make_links}) {
	    push (@{$self->{links_dictionaries}}, ($self->{system_link_dict}))
	      if -f $self->{system_link_dict};
	    $self->load_dictionary_links();
	}
     
	# various initializations
	$self->{__non_header_anchor} = 0;
	$self->{__mode}              = 0;
	$self->{__listnum}           = 0;
	$self->{__list_indent}       = '';
	$self->{__tags}		     = [];

	$self->{__call_init_done} = 1;
    }
}

# run this from the command line
sub run_txt2html {
    my ($caller) = @_;    # ignore all passed in arguments,
                          # because this only should look at ARGV

    my $conv = new HTML::TextToHTML(\@ARGV);

    my @args = ();

    # now the remainder must be input-files
    foreach my $df (@ARGV) {
        push @args, "--infile", $df;
    }
    $conv->txt2html(\@args);
}

=head1 FILE FORMATS

There are two files which are used which can affect the outcome of the
conversion.  One is the link dictionary, which contains patterns (of how
to recognise http links and other things) and how to convert them. The
other is, naturally, the format of the input file itself.

=head2 Link Dictionary

A link dictionary file contains patterns to match, and what to convert
them to.  It is called a "link" dictionary because it was intended to be
something which defined what a href link was, but it can be used for
more than that.  However, if you wish to define your own links, it is
strongly advised to read up on regular expressions (regexes) because
this relies heavily on them.

The file consists of comments (which are lines starting with #)
and blank lines, and link entries.
Each entry consists of a regular expression, a -> separator (with
optional flags), and a link "result".

In the simplest case, with no flags, the regular expression
defines the pattern to look for, and the result says what part
of the regular expression is the actual link, and the link which
is generated has the href as the link, and the whole matched pattern
as the visible part of the link.  The first character of the regular
expression is taken to be the separator for the regex, so one
could either use the traditional / separator, or something else
such as | (which can be helpful with URLs which are full of / characters).

So, for example, an ftp URL might be defined as:

    |ftp:[\w/\.:+\-]+|      -> $&

This takes the whole pattern as the href, and the resultant link
has the same thing in the href as in the contents of the anchor.

But sometimes the href isn't the whole pattern.

    /&lt;URL:\s*(\S+?)\s*&gt;/ --> $1

With the above regex, a () grouping marks the first subexpression,
which is represented as $1 (rather than $& the whole expression).
This entry matches a URL which was marked explicity as a URL
with the pattern <URL:foo>  (note the &lt; is shown as the
entity, not the actual character.  This is because by the
time the links dictionary is checked, all such things have
already been converted to their HTML entity forms)
This would give us a link in the form
<A HREF="foo">&lt;URL:foo&gt;</A>

B<The h flag>

However, if we want more control over the way the link is constructed,
we can construct it ourself.  If one gives the h flag, then the
"result" part of the entry is taken not to contain the href part of
the link, but the whole link.

For example, the entry:

    /&lt;URL:\s*(\S+?)\s*&gt;/ -h-> <A HREF="$1">$1</A>

will take <URL:foo> and give us <A HREF="foo">foo</A>

However, this is a very powerful mechanism, because it
can be used to construct custom tags which aren't links at all.
For example, to flag *italicised words* the following
entry will surround the words with EM tags.

    /\B\*([a-z][a-z -]*[a-z])\*\B/ -hi-> <EM>$1</EM>

B<The i flag>

This turns on ignore case in the pattern matching.

B<The e flag>

This turns on execute in the pattern substitution.  This really
only makes sense if h is turned on too.  In that case, the "result"
part of the entry is taken as perl code to be executed, and the
result of that code is what replaces the pattern.

B<The o flag>

This marks the entry as a once-only link.  This will convert the
first instance of a matching pattern, and ignore any others
further on.

For example, the following pattern will take the first mention
of HTML::TextToHTML and convert it to a link to the module's home page.

    "HTML::TextToHTML"  -io-> http://www.katspace.com/tools/text_to_html/

=head2 Input File Format

For the most part, this module tries to use intuitive conventions for
determining the structure of the text input.  Unordered lists are
marked by bullets; ordered lists are marked by numbers or letters;
in either case, an increase in indentation marks a sub-list contained
in the outer list.

Headers (apart from custom headers) are distinguished by "underlines"
underneath them; headers in all-capitals are distinguished from
those in mixed case.

Tables require a more rigid convention.  A table must be marked as a
separate paragraph, that is, it must be surrounded by blank lines.
Columns must be separated by two or more spaces (this prevents
accidental incorrect recognition of a paragraph where interword spaces
happen to line up).  If there are two or more rows in a paragraph and
all rows share the same set of (two or more) columns, the paragraph is
assumed to be a table.  For example

    -e  File exists.
    -z  File has zero size.
    -s  File has nonzero size (returns size).

becomes

    <TABLE>
    <TR><TD>-e</TD><TD>File exists.</TD></TR>
    <TR><TD>-z</TD><TD>File has zero size.</TD></TR>
    <TR><TD>-s</TD><TD>File has nonzero size (returns size).</TD></TR>
    </TABLE>

This guesses for each column whether it is intended to be left,
centre or right aligned.

=head1 EXAMPLES

    use HTML::TextToHTML;
 
=head2 Create a new object

    my $conv = new HTML::TextToHTML();

    my $conv = new HTML::TextToHTML(title=>"Wonderful Things",
			    system_link_dict=>$my_link_file,
      );

    my $conv = new HTML::TextToHTML(\@ARGV);

=head2 Add further arguments

    $conv->args(short_line_length=>60,
	       preformat_trigger_lines=>4,
	       caps_tag=>"strong",
      );

=head2 Convert a file

    $conv->txt2html(infile=>[$text_file],
                     outfile=>$html_file,
		     title=>"Wonderful Things",
		     mail=>1
      );

    $conv->txt2html(["--file", $text_file,
                     "--outfile", $html_file,
		     "--title", "Wonderful Things",
			 "--mail"
      ]);

=head1 NOTES

=over 4

=item *

One cannot use "CLEAR" as a value for the cumulative arguments.

=item *

If the underline used to mark a header is off by more than 1, then 
that part of the text will not be picked up as a header unless you
change the value of --underline_length_tolerance and/or
--underline_offset_tolerance.  People tend to forget this.

=back 4

=head1 BUGS

Tell me about them.

=head1 PREREQUSITES

HTML::TextToHTML requires Perl 5.005_03 or later.

It also requires Data::Dumper (only for debugging purposes)

=head1 EXPORT

run_txt2html

=head1 AUTHOR

Kathryn Andersen, E<lt>http//www.katspace.comE<gt> 2002,2003
Original txt2html script copyright (C) 2000 Seth Golub <seth AT aigeek.com>

=head1 SEE ALSO

L<perl>.
L<txt2html>.
Data::Dumper

=cut

#------------------------------------------------------------------------
1;
