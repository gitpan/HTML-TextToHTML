#! /usr/bin/perl
#------------------------------------------------------------------------

=head1 HTML::TextToHTML

HTML::TextToHTML - convert plain text file to HTML

=head1 SYNOPSIS

  From the command line:

    perl -MHTML::TextToHTML -e run_txt2html -- --help;
    (prints this synopsis)

    perl -MHTML::TextToHTML -e run_txt2html -- --man;
    (prints this manpage)

    perl -MHTML::TextToHTML -e run_txt2html -- <arguments>;
    (calls the txt2html method with the given arguments)

  From Scripts:

    use HTML::TextToHTML;
 
    # create a new object
    my $conv = new HTML::TextToHTML();

    my $conv = new HTML::TextToHTML(["--title", "Wonderful Things",
			    "--system_link_dict", $my_link_file,
      ]);

    my $conv = new HTML::TextToHTML(\@ARGV);

    # add further arguments
    $conv->args(["--short_line_length", 60,
	       "--prebegin", 4,
	       "--caps_tag", "strong",
      ]);

    # convert a file
    $conv->txt2html(["--file", $text_file,
                     "--outfile", $html_file,
		     "--title", "Wonderful Things",
			 "--mail"
      ]);

=head1 DESCRIPTION

HTML::TextToHTML converts plain text files to HTML.

It supports headings, lists, simple character markup, and
hyperlinking, and is highly customizable. It recognizes some of the
apparent structure of the source document (mostly whitespace and
typographic layout), and attempts to mark that structure explicitly
using HTML. The purpose for this tool is to provide an easier way of
converting existing text documents to HTML format.

There are two ways to use this module:
    (1) called from a perl script
    (2) call run_txt2html from the command line

The first usage requires one to create a HTML::TextToHTML object,
and then call the txt2html method with suitable arguments.
One can also pass arguments in when creating the object, or call the args
method to pass arguments in.

The second usage allows one to pass arguments in from the command line, by
calling perl and executing the module, and calling run_txt2html which
creates an object for you and parses the command line.

Either way, the arguments are the same.

=head1 ARGUMENTS

=head2 A Note about Arguments

Because this object is a subclass of AppConfig, one can use all the power of
AppConfig for defining and parsing options/arguments.

All arguments can be set when the object is created, and further options
can be set when calling the txt2html method.  This expects a reference to
an array (which will then be processed as if it were a command-line, which
makes this very easy to use from scripts).

Options can start with '--' or '-'.  If it is a yes/no option, that is the
only part of the option (and such an option can be prefaced with "no" to
negate it).  If the option takes a value, then the list must be
("--option", "value").

Order does matter.  For options which are yes/no options, a later
argument overrides an earlier one.  For arguments which are single values,
a later value replaces an earlier one.  For arguments which are
cumulative, a later argument is added on to the list.  For such arguments,
if you want to clear the old value and start afresh, give it the
special value of CLEAR.

=over 8

=item --infile I<filename> | --file I<filename>

The name of the input file.
This is a cumulative list argument.  If you want to process
more than one file, just add another --file I<file> to the list of
arguments.  If you want to process a different file, you need to CLEAR this
argument before you call txt2html.
(def:undefined)

=item --outfile I<filename>

The name of the output file.  If it is "-" then the output goes
to Standard Output.
(default: - )

=item --config I<file>

A file containing options, which is read in, and the options from the file
are treated as if they were in the argument list at the point at which the
--config option was.  See L<Config File> for more information.

=item --short_line_length I<n> | --shortline I<n> | -s I<n>

Lines this short (or shorter) must be intentionally broken and are kept
that short.
(default: 40)

=item --preformat_whitespace_min I<n> | --prewhite I<n> | -p I<n>

Minimum number of consecutive whitespace characters to trigger
preformatting. 
NOTE: Tabs are now expanded to spaces before this check is made.
That means if B<tab_width> is 8 and this is 5, then one tab may be
expanded to 8 spaces, which is enough to trigger preformatting.
(default: 5)

=item --par_indent I<n>

Minumum number of spaces indented in first lines of paragraphs.
  Only used when there's no blank line
preceding the new paragraph.
(default: 2)

=item --preformat_trigger_lines I<n> | --prebegin I<n> | -pb I<n>

How many lines of preformatted-looking text are needed to switch to <PRE>
          <= 0 : Preformat entire document
             1 : one line triggers
          >= 2 : two lines trigger

(default: 2)

=item --endpreformat_trigger_lines I<n> | --preend I<n> | -pe I<n>

How many lines of unpreformatted-looking text are needed to switch from <PRE>
           <= 0 : Never preformat within document
              1 : one line triggers
           >= 2 : two lines trigger
(default: 2)

NOTE for --prebegin and --preend:
A zero takes precedence.  If one is zero, the other is ignored.
If both are zero, entire document is preformatted.

=item --hrule_min I<n> | --hrule I<n> | -r I<n>

Min number of ---s for an HRule.
(default: 4)

=item --min_caps_length I<n> | --caps I<n> | -c I<n>

min sequential CAPS for an all-caps line
(default: 3)

=item --caps_tag I<tag> | --capstag I<tag> | -ct I<tag>

Tag to put around all-caps lines
(default: STRONG)

=item --mailmode | --mail | -m

Deal with mail headers & quoted text
(default: false)

=item --unhyphenation | --unhypnenate | -u

Enables unhyphenation of text.
(default: true)

=item --append_file I<filename> | --append I<filename> | --append_body I<filename>

If you want something appended by default, put the filename here.
The appended text will not be processed at all, so make sure it's
plain text or decent HTML.  i.e. do not have things like:
    Kathryn Andersen E<lt>rubykat@katspace.comE<gt>
but instead, have:
    Kathryn Andersen &lt;rubykat@katspace.com&gt;

(default: nothing)

=item --prepend_file I<filename> | --prepend_body I<filename> | --pp I<filename>

Same sort of thing, but goes before the processed body text,
rather than after.
(default: nothing)

=item --append_head I<filename> | -ah I<filename>

If you want something appended to the head by default, put the filename here.
The appended text will not be processed at all, so make sure it's
plain text or decent HTML.  i.e. do not have things like:
    Kathryn Andersen E<lt>rubykat@katspace.comE<gt>
but instead, have:
    Kathryn Andersen &lt;rubykat@katspace.com&gt;

(default: nothing)

=item --title I<title> | -t I<title>

You can specify a title.  Otherwise it will use a blank one.
(default: nothing)

=item --titlefirst | -tf

Use the first non-blank line as the title.

=item --doctype I<doctype> | --dt I<doctype>

This gets put in the DOCTYPE field at the
top of the document, unless it's empty.
(default : "-//W3C//DTD HTML 3.2 Final//EN")

=item --underline_length_tolerance I<n> | --ulength I<n> | -ul I<n>

How much longer or shorter can underlines be and still be underlines?
(default: 1)

=item --underline_offset_tolerance I<n> | --uoffset I<n> | -uo I<n>

How far offset can underlines be and still be underlines?
(default: 1)

=item --tab_width I<n> | --tabwidth I<n> | -tw I<n>

How many spaces equal a tab?
(default: 8)

=item --indent_width I<n> | --indent I<n> | -iw I<n>

Indents this many spaces for each level of a list.
(default: 2)

=item --extract

Extract Mode; don't put HTML headers or footers on the result, just
the plain HTML (thus making the result suitable for inserting into
another document (or as part of the output of a CGI script).
(default: false)

=item --make_links

Should we try to build links?
(default: true)

=item --links_dictionaries I<filename> | --link I<filename> | -l I<filename>

File to use as a link-dictionary.  There can be more than one of these.
These are in addition to the System Link Dictionary and the User Link
Dictionary.

=item --system_link_dict I<filename>

The name of the default "system" link dictionary.
(default: "/usr/share/txt2html/txt2html.dict" -- this is the same as for
the txt2html script)

=item --default_link_dict I<filename>

The name of the default "user" link dictionary.
(default: "$ENV{'HOME'}/.txt2html.dict" -- this is the same as for
the txt2html script)

=item --escape_HTML_chars | --escape_chars | -ec

turn & E<lt> E<gt> into &amp; &gt; &lt;
(default: true)

=item --eight_bit_clean | --eight_bit

disable Latin-1 character entity naming
(default: false)

=item --link_only | --linkonly | -LO

Do no escaping or marking up at all, except for processing the links
dictionary file and applying it.  This is useful if you want to use
txt2html's linking feature on an HTML document.  If the HTML is a
complete document (includes HTML,HEAD,BODY tags, etc) then you'll
probably want to use the --extract option also.
(default: false)

=item --custom_heading_regexp I<regexp> | --heading I<regexp> | -H I<regexp>

Add a regexp for headings.  Header levels are assigned by regexp
in order seen When a line matches a custom header regexp, it is tagged as
a header.  If it's the first time that particular regexp has matched,
the next available header level is associated with it and applied to
the line.  Any later matches of that regexp will use the same header level.
Therefore, if you want to match numbered header lines, you could use
something like this:
    -H '^ *\d+\. \w+' -H '^ *\d+\.\d+\. \w+' -H '^ *\d+\.\d+\.\d+\. \w+'

Then lines like " 1. Examples "
                " 1.1 Things"
            and " 4.2.5 Cold Fusion"
Would be marked as H1, H2, and H3 (assuming they were found in that
order, and that no other header styles were encountered).
If you prefer that the first one specified always be H1, the second
always be H2, the third H3, etc, then use the -EH/--explicit-headings
option.

This is a multi-valued option.

(default: none)

=item --explicit_headings | -EH

Don't try to find any headings except the custom one(s) specified.
Also, the custom headings will not be assigned levels in the order they
are encountered in the document, but in the order they are specified on
the command line.
(default: false)

=item --custom_tags I<tagname>=I<regexp> | --tag I<tagname>=I<regexp> | -T I<t>=I<r>

Similar to --heading, this lets you specify arbitrary patterns to tag. 
The first subexpression, if one is present, will replace the entire
matched text.  Example: "em:\*(\w+)\*" will match any word
surrounded by asterisks and mark it as emphasized, removing the
asterisks.

Not implemented yet.

=item --dict_debug I<n> | -db I<n>

Debug mode for link dictionaries Bitwise-Or what you want to see:
          1: The parsing of the dictionary
          2: The code that will make the links
          4: When each rule matches something

(default: 0)

=item --debug

Enable copious script debugging output (don't bother, this is for the
developer)

=item --use_preformat_marker | --preformat_marker | -pm

Turn on preformatting when encountering
"<PRE>" on a line by itself, and turn it
off when there's a line containing only "</PRE>".
(default: off)

=item --preformat_start_marker I<regexp>

What flags the start of a preformatted section.

(default: "^(:?(:?&lt;)|<)PRE(:?(:?&gt;)|>)\$")

=item --preformat_end_marker I<regexp>

What flags the end of a preformatted section.

(default: "^(:?(:?&lt;)|<)/PRE(:?(:?&gt;)|>)\$")

=item --use_mosaic_header | --mosaic | -mh

Use this option if you want to force the heading styles to match what Mosaic
outputs.  (Underlined with "***"s is H1,
with "==="s is H2, with "+++" is H3, with "---" is H4, with "~~~" is H5
and with "..." is H6)
This was the behavior of txt2html up to version 1.10.
(default: false)

=head2 Config File

The Config file is a way of specifying default options in a file instead of
having to do it when you call txt2html or on the command line.

The file may contain blank lines and comments (prefixed by
'#') which are ignored.  Continutation lines may be marked
by ending the line with a '\'.

    # this is a comment
    title = Page of Wonderful and Inexplicably Joyous \
    Things You Want To Know About

Options that are simple flags and do not expect an argument can be
specified without any value.  They will be set with the value 1, with any
value explicitly specified (except "0" and "off") being ignored.  The
option may also be specified with a "no" prefix to implicitly set the
variable to 0.

    mail                                 # on (1)
    mail = 1                             # on (1)
    mail = 0                             # off (0)
    mail off                             # off (0)
    mail on                              # on (1)
    mail mumble                          # on (1)
    nomail                               # off (0)

Options that expect an argument (but are not cumulative) will
be set to whatever follows the variable name, up to the end of the
current line.  An equals sign may be inserted between the option
and value for clarity.

    tab_width = 8
    tab_width   4

Each subsequent re-definition of the option value overwites
the previous value.  From the above example, the value of the tab
width would now be 4.

Some options are simple cumulative options, with each subsequent
definition of the option adding to the list of previously set values
for that option.

    heading = '^ *\d+\. \w+'
    heading = '^ *\d+\.\d+\. \w+'
    heading = '^ *\d+\.\d+\.\d+\. \w+'

If you want to clear the list and start again, give the CLEAR option.

    heading = CLEAR

Some options are "hash" cumulative options, building up a hash
of key=value pairs.  Each subsequent definition creates a new
key and value in the hash array of that option.

    custom_tags em=\*(\w+)\*
    tag strong=\^(\w+)\^

If you want to clear the hash and start again, give the CLEAR option.

    tag CLEAR

The '-' prefix can be used to reset a variable to its
default value and the '+' prefix can be used to set it to 1.

    -mail
    +debug

Option values may contain references to other options, environment
variables and/or users' home directories.

    link = ~/.link_dict	# expand '~' to home directory

    mail = ${TXT_MAIL}   # expand TXT_MAIL environment variable

The configuration file may have options arranged in blocks.  A block
header, consisting of the block name in square brackets, introduces a
configuration block.  The block name and an underscore are then prefixed to
the names of all options subsequently referenced in that block.  The
block continues until the next block definition or to the end of the
current file.

    [underline]
    length_tolerance = 8    # underline_length_tolerance = 8
    offset_tolerance = 4    # underline_offset_tolerance = 4

See AppConfig for more information.

=head2 Link Dictionary

(To be done)

=back

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

It also requires AppConfig, 
Data::Dumper (only for debugging purposes)
and Pod::Usage.

=head1 EXPORT

run_txt2html

=head1 AUTHOR

Kathryn Andersen, E<lt>rubykat@katspace.comE<gt>

=head1 SEE ALSO

L<perl>.
L<txt2html>.
AppConfig
Pod::Usage
Data::Dumper

=cut

#------------------------------------------------------------------------
package HTML::TextToHTML;

use 5.005_03;
use strict;
use warnings;
use diagnostics;

require Exporter;
use vars qw($VERSION $PROG @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

BEGIN {
    @ISA = qw(Exporter AppConfig);
    require Exporter;
    use AppConfig qw(:argcount);
    use Data::Dumper;
    use HTML::SimpleParse;
    use Pod::Usage;
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
$VERSION = '0.02';

#------------------------------------------------------------------------
use constant TEXT_TO_HTML => "TEXT_TO_HTML";

########################################
# Definitions  (Don't change these)
#

# These are just constants I use for making bit vectors to keep track
# of what modes I'm in and what actions I've taken on the current and
# previous lines.  
use vars qw($NONE $LIST $HRULE $PAR $PRE $END $BREAK $HEADER
  $MAILHEADER $MAILQUOTE $CAPS $LINK $PRE_EXPLICIT $TABLE);

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

#---------------------------------------------------------------#
# Object interface
#---------------------------------------------------------------#

# Name: new
# Creates a new instance of a Toc
# Args:
#   $invocant
#   \@args (array of command-line arguments in Args style)
sub new {
    my $invocant = shift;
    my $args_ref = (@_ ? shift: 0);

    my $class = ref($invocant) || $invocant;    # Object or class name
    my $self = AppConfig->new(
        {
            CASE   => 1,
            CREATE => 0,
            GLOBAL => {
                ARGCOUNT => ARGCOUNT_NONE,
                EXPAND   => AppConfig::EXPAND_ALL,
                ACTION   => \&do_var_action,
            }
        }
    );

    init_our_data($self);

    # re-bless self
    bless($self, $class);

    # and set with the passed-in args
    if ($args_ref && @{$args_ref}) {
        if (!$self->args($args_ref)) {
            pod2usage(
                {
                    -message => "Unrecognised option",
                    -exitval => "NOEXIT",
                    -verbose => 0,
                }
            );
            return 0;
        }
    }

    return $self;
}    # new

#---------------------------------------------------------------#
# AppConfig-related subroutines

#--------------------------------#
# Name: do_var_action
#   ACTION function for hash AppConfig variables
# Args:
#   $state_ref -- reference to AppConfig::State
#   $name -- variable name
#   $value -- new value
sub do_var_action($$$) {
    my $state_ref = shift;
    my $name      = shift;
    my $value     = shift;

    my $parent = $state_ref->get(TEXT_TO_HTML);

    if ($name eq TEXT_TO_HTML) {

        # do nothing!
    }

    # clear the variable if given the value CLEAR
    elsif ($value eq "CLEAR") {
        if (ref($state_ref->get($name)) eq "HASH") {
            %{$state_ref->get($name)} = ();
        }
        elsif (ref($state_ref->get($name)) eq "ARRAY") {
            @{$state_ref->get($name)} = ();
        }
    }

    # if this is config, read in the given config file
    elsif ($name eq "config") {
        if ($state_ref->get('debug')) {
            print STDERR ">>> reading in config file $value\n";
        }
        $parent->file($value);
        if ($state_ref->get('debug')) {
            print STDERR "<<< read in config file $value\n";
        }
    }

    # if this is man, print man
    elsif ($name =~ /^man/) {
        pod2usage(
            {
                -message  => "HTML::TextToHTML",
                -exitval  => 0,
                -verbose  => 2,
                -input    => "HTML/TextToHTML.pm",
                -pathlist => \@INC,
            }
        );
    }

    # if this is help, print help
    elsif ($name eq "help") {
        pod2usage(
            {
                -message  => "HTML::TextToHTML",
                -exitval  => 0,
                -verbose  => 0,
                -input    => "HTML/TextToHTML.pm",
                -pathlist => \@INC,
            }
        );
    }
    if ($state_ref->get('debug')) {
        print STDERR "=========\n changed $name to $value\n =========\n";
        if (ref($state_ref->get($name)) eq "HASH") {
            print STDERR Dumper($state_ref->get($name));
        }
        elsif (ref($state_ref->get($name)) eq "ARRAY") {
            print STDERR Dumper($state_ref->get($name));
        }
    }
}    # do_var_action

#--------------------------------#
# Name: define_vars
#   define the variables which AppConfig will recognise
# Args:
#   $self
sub define_vars {
    my $self = shift;

    # since debug is checked in the action, set it first
    $self->define(
        "debug",
        {
            DEFAULT => 0,
        }
    );

    # reference to self!  (do not change!)
    $self->define(
        "TEXT_TO_HTML",
        {
            ARGCOUNT => ARGCOUNT_ONE,
        }
    );
    $self->set(TEXT_TO_HTML, $self);

    #
    # All the options
    #
    # name of a config file -- parsed immediately
    $self->define("config=s");

    $self->define("man_help|manpage|man");
    $self->define("help");

    $self->define(
        "short_line_length|shortline|s=n",
        {
            DEFAULT => 40,
        }
    );
    $self->define(
        "preformat_whitespace_min|prewhite|p=n",
        {
            DEFAULT => 5,
        }
    );
    $self->define(
        "par_indent=n",
        {
            DEFAULT => 2,
        }
    );
    $self->define(
        "preformat_trigger_lines|prebegin|pb=n",
        {
            DEFAULT => 2,
        }
    );
    $self->define(
        "endpreformat_trigger_lines|preend|pe=n",
        {
            DEFAULT => 2,
        }
    );
    $self->define(
        "hrule_min|hrule|r=n",
        {
            DEFAULT => 4,
        }
    );
    $self->define(
        "min_caps_length|caps|c=n",
        {
            DEFAULT => 3,
        }
    );
    $self->define(
        "caps_tag|capstag|ct=s",
        {
            DEFAULT => "STRONG",
        }
    );
    $self->define(
        "mailmode|mail",
        {
            DEFAULT => 0,
        }
    );
    $self->define(
        "unhyphenation|unhyphenate",
        {
            DEFAULT => 1,
        }
    );
    $self->define(
        "append_file|append|append_body|a|ab=s",
        {
            DEFAULT => "",
        }
    );
    $self->define(
        "prepend_file|prepend_body|pp=s",
        {
            DEFAULT => "",
        }
    );
    $self->define(
        "append_head|ah=s",
        {
            DEFAULT => "",
        }
    );
    $self->define(
        "title|t=s",
        {
            DEFAULT => "",
        }
    );
    $self->define(
        "titlefirst|tf",
        {
            DEFAULT => 0,
        }
    );
    $self->define(
        "doctype|dt=s",
        {
            DEFAULT => "-//W3C//DTD HTML 3.2 Final//EN",
        }
    );
    $self->define(
        "underline_length_tolerance|ulength|ul=n",
        {
            DEFAULT => 1,
        }
    );
    $self->define(
        "underline_offset_tolerance|uoffset|uo=n",
        {
            DEFAULT => 1,
        }
    );
    $self->define(
        "tab_width|tabwidth|tw=n",
        {
            DEFAULT => 8,
        }
    );
    $self->define(
        "indent_width|indent|iw=n",
        {
            DEFAULT => 2,
        }
    );
    $self->define(
        "extract",
        {
            DEFAULT => 0,
        }
    );
    $self->define(
        "make_links",
        {
            DEFAULT => 1,
        }
    );
    $self->define("links_dictionaries|link|l=s@");
    $self->define(
        "escape_HTML_chars|escapechars|ec",
        {
            DEFAULT => 1,
        }
    );
    $self->define(
        "eight_bit_clean|eight_bit|eight|8",
        {
            DEFAULT => 0,
        }
    );
    $self->define(
        "link_only|linkonly|LO",
        {
            DEFAULT => 0,
        }
    );
    $self->define("custom_heading_regexp|heading|H=s@");
    $self->define(
        "explicit_headings|EH",
        {
            DEFAULT => 0,
        }
    );
    $self->define("custom_tags|tag|T=s@");
    $self->define(
        "dict_debug|db=n",
        {
            DEFAULT => 0,
        }
    );
    $self->define("system_link_dict|sysdict=s");
    $self->define(
        "default_link_dict|dict=s",
        {
            DEFAULT => "$ENV{HOME}/.txt2html.dict",
        }
    );
    $self->define(
        "use_preformat_marker|preformat_marker|pm",
        {
            DEFAULT => 0,
        }
    );
    $self->define(
        "preformat_start_marker=s",
        {
            DEFAULT => "^(:?(:?&lt;)|<)PRE(:?(:?&gt;)|>)\$",
        }
    );
    $self->define(
        "preformat_end_marker=s",
        {
            DEFAULT => "^(:?(:?&lt;)|<)/PRE(:?(:?&gt;)|>)\$",
        }
    );
    $self->define(
        "use_mosaic_header|mosaic|mh",
        {
            DEFAULT => 0,
        }
    );

    $self->define("infile|file=s@");    # names of files to be processed
    $self->define(
        "outfile|out|o=s",
        {
            DEFAULT => "-",
        }
    );

}    # define_vars

#--------------------------------#
# Name: init_our_data
# Args:
#   $self
sub init_our_data ($) {
    my $self = shift;

    define_vars($self);

    # read in from the __DATA__ section
    $self->file(\*DATA);

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

    if ($self->links_dictionaries()) {
        foreach my $ld (@{$self->links_dictionaries()}) {
            if (-r $ld) {
                $self->set('make_links' => 1);
            }
            else {
                print STDERR "Can't find or read link-file $ld\n";
            }
        }
    }
    if (!$self->make_links()) {
        $self->set('links_dictionaries' => 0);
        $self->set('system_link_dict'   => "");
    }
    if ($self->custom_tags()) {
        foreach my $ct (@{$self->custom_tags()}) {
            print STDERR "Sorry.  $ct isn't supported yet.\n";
        }
    }
    if ($self->append_file()) {
        if (!-r $self->append_file()) {
            print STDERR "Can't find or read ", $self->append_file(), "\n";
        }
    }
    if ($self->prepend_file()) {
        if (!-r $self->prepend_file()) {
            print STDERR "Can't find or read ", $self->prepend_file(), "\n";
        }
    }
    if ($self->append_head()) {
        if (!-r $self->append_head()) {
            print STDERR "Can't find or read ", $self->append_head(), "\n";
        }
    }

    # set the input files
    if ($self->infile()) {
        push @ARGV, @{$self->infile()};
    }
    if (!$self->outfile()) {
        $self->set('outfile' => "-");
    }

    $self->set('preformat_trigger_lines' => 0)
      if ($self->preformat_trigger_lines() < 0);
    $self->set('preformat_trigger_lines' => 2)
      if ($self->preformat_trigger_lines() > 2);

    $self->set('endpreformat_trigger_lines' => 1)
      if ($self->preformat_trigger_lines() == 0);
    $self->set('endpreformat_trigger_lines' => 0)
      if ($self->endpreformat_trigger_lines() < 0);
    $self->set('endpreformat_trigger_lines' => 2)
      if ($self->endpreformat_trigger_lines() > 2);

    $self->{__preformat_enabled} =
      (($self->endpreformat_trigger_lines() != 0)
      || $self->use_preformat_marker());

    if ($self->use_mosaic_header()) {
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

sub hrule ($) {
    my $self = shift;

    my $hrmin = $self->hrule_min();
    if ($self->{__line} =~ /^\s*([-_~=\*]\s*){$hrmin,}$/) {
        $self->{__line} = "<HR>\n";
        $self->{__prev} =~ s/<P>//;
        $self->{__line_action} |= $HRULE;
    }
    elsif ($self->{__line} =~ /\014/) {
        $self->{__line_action} |= $HRULE;
        $self->{__line} =~
          s/\014/\n<HR>\n/g;    # Linefeeds become horizontal rules
    }
}

sub shortline ($) {
    my $self = shift;

    # Short lines should be broken even on list item lines iff the
    # following line is more text.  I haven't figured out how to do
    # that yet.  For now, I'll just not break on short lines in lists.
    # (sorry)

    if (!($self->{__mode} & ($PRE | $LIST))
        && !is_blank($self->{__line})
        && !is_blank($self->{__prev})
        && ($self->{__prev_line_length} < $self->short_line_length())
        && !($self->{__line_action} & ($END | $HEADER | $HRULE | $LIST | $PAR))
        && !($self->{__prev_action} & ($HEADER | $HRULE | $BREAK)))
    {
        $self->{__prev} .= "<BR>" . chop($self->{__prev});
        $self->{__prev_action} |= $BREAK;
    }
}

sub mailstuff ($) {
    my $self = shift;

    if ((($self->{__line} =~ /^\w*&gt/)    # Handle "FF> Werewolves."
        || ($self->{__line} =~ /^\w*\|/))    # Handle "Igor| There wolves."
        && !is_blank($self->{__nextline})
      )
    {
        $self->{__line} =~ s/$/<BR>/;
        $self->{__line_action} |= ($BREAK | $MAILQUOTE);
        if (!($self->{__prev_action} & ($BREAK | $PAR))) {
            $self->{__prev} .= "<P>\n";
            $self->{__line_action} |= $PAR;
        }
    }
    elsif (($self->{__line} =~ /^(From:?)|(Newsgroups:) /)
        && is_blank($self->{__prev}))
    {
        $self->anchor_mail(\$self->{__line})
	    if !($self->{__prev_action} & $MAILHEADER);
        chomp $self->{__line};
        $self->{__line} =
          "<!-- New Message -->\n<p>\n" . $self->{__line} . "<BR>\n";
        $self->{__line_action} |= ($BREAK | $MAILHEADER | $PAR);
    }
    elsif (($self->{__line} =~ /^[\w\-]*:/)    # Handle "Some-Header: blah"
        && ($self->{__prev_action} & $MAILHEADER)
        && !is_blank($self->{__nextline})
      )
    {
        $self->{__line} =~ s/$/<BR>/;
        $self->{__line_action} |= ($BREAK | $MAILHEADER);
    }
    elsif (($self->{__line} =~ /^\s+\S/) &&    # Handle multi-line mail headers
        ($self->{__prev_action} & $MAILHEADER) && !is_blank($self->{__nextline})
      )
    {
        $self->{__line} =~ s/$/<BR>/;
        $self->{__line_action} |= ($BREAK | $MAILHEADER);
    }
}

# Subtracts modes listed in $mask from $vector.
sub subtract_modes ($$) {
    my ($vector, $mask) = @_;
    return ($vector | $mask) - $mask;
}

sub paragraph ($) {
    my $self = shift;

    if (!is_blank($self->{__line})
        && !($self->{__mode} & $PRE)
        && !subtract_modes($self->{__line_action},
            $END | $MAILQUOTE | $CAPS | $BREAK)
        && (is_blank($self->{__prev})
            || ($self->{__line_action} & $END)
            || ($self->{__line_indent} >
                $self->{__prev_indent} + $self->par_indent())))
    {
        $self->{__prev} .= "<P>\n";
        $self->{__line_action} |= $PAR;
    }
}

# If the line is blank, return the second argument.  Otherwise,
# return the number of spaces before any nonspaces on the line.
sub count_indent ($$) {
    my ($line, $prev_length) = @_;

    if (is_blank($line)) {
        return $prev_length;
    }
    my $ws = $line =~ /^( *)[^ ]/;
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

sub startlist ($$$$$) {
    my $self = shift;
    my $prefix = shift;
    my $number = shift;
    my $rawprefix = shift;
    my $prev_ref = shift;

    $self->{__listprefix}->[$self->{__listnum}] = $prefix;
    if ($number) {

        # It doesn't start with 1,a,A.  Let's not screw with it.
        if (($number ne "1") && ($number ne "a") && ($number ne "A")) {
            return 0;
        }
        ${$prev_ref} .= $self->{__list_indent} . "<OL>\n";
        $self->{__list}->[$self->{__listnum}] = $OL;
    }
    else {
        ${$prev_ref} .= $self->{__list_indent} . "<UL>\n";
        $self->{__list}->[$self->{__listnum}] = $UL;
    }

    $self->{__listnum}++;
    $self->{__list_indent} = " " x $self->{__listnum} x $self->indent_width();
    $self->{__line_action} |= $LIST;
    $self->{__mode} |= $LIST;
    1;
}

# End N lists
sub endlist ($$$) {
    my $self = shift;
    my $n = shift;
    my $prev_ref = shift;

    for (; $n > 0 ; $n--, $self->{__listnum}--) {
        $self->{__list_indent} =
          " " x ($self->{__listnum} - 1) x $self->indent_width();
        if ($self->{__list}->[$self->{__listnum} - 1] == $UL) {
            ${$prev_ref} .= $self->{__list_indent} . "</UL>\n";
        }
        elsif ($self->{__list}->[$self->{__listnum} - 1] == $OL) {
            ${$prev_ref} .= $self->{__list_indent} . "</OL>\n";
        }
        else {
            print STDERR "Encountered list of unknown type\n";
        }
    }
    $self->{__line_action} |= $END;
    $self->{__mode} ^= $LIST if (!$self->{__listnum});
}

sub continuelist ($$$) {
    my $self = shift;
    my $line_ref = shift;
    my $line_action_ref = shift;

    my $list_indent = $self->{__list_indent};
    ${$line_ref} =~ s/^\s*[-=o\*\267]+\s*/$list_indent<LI>/
      if $self->{__list}->[$self->{__listnum} - 1] == $UL;
    ${$line_ref} =~ s/^\s*(\d+|[^\W\d_]).\s*/$list_indent<LI>/
      if $self->{__list}->[$self->{__listnum} - 1] == $OL;
    ${$line_action_ref} |= $LIST;
}

sub liststuff ($) {
    my $self = shift;
    my $line_ref = \$self->{__line};
    my $line_action_ref = \$self->{__line_action};
    my $prev_ref = \$self->{__prev};
    my $prev_action_ref = \$self->{__prev_action};

    my $i;

    my ($prefix, $number, $rawprefix) = listprefix(${$line_ref});

    if (!$prefix) {
        return if !is_blank(${$prev_ref});    # inside a list item
             # This ain't no list.  We'll want to end all of them.
        $self->endlist($self->{__listnum}, $prev_ref) if $self->{__listnum};
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
    my ($total_prefix) = ${$line_ref} =~ /^(\s*[\w=o\*-]+.\s*)/;

    # Of course, we only use it if it really turns out to be a list.

    $islist = 1;
    $i++;
    if (($i > 0) && ($i != $self->{__listnum})) {
        $self->endlist($self->{__listnum} - $i, $prev_ref);
        $islist = 0;
    }
    elsif (!$self->{__listnum} || ($i != $self->{__listnum})) {
        if (($self->{__line_indent} > 0)
            || is_blank(${$prev_ref})
            || (${$prev_action_ref} & ($BREAK | $HEADER | $CAPS)))
        {
            $islist = $self->startlist($prefix, $number, $rawprefix, $prev_ref);
        }
        else {

            # We have something like this: "- foo" which usually
            # turns out not to be a list.
            return;
        }
    }

    $self->continuelist($line_ref, $line_action_ref)
      if ($self->{__mode} & $LIST);
    $self->{__line_indent} = length($total_prefix) if $islist;
}

# Returns true if the passed string is considered to be preformatted
sub is_preformatted ($$) {
    my $self = shift;

    my $pre_white_min = $self->preformat_whitespace_min();
    (($_[0] =~ /\s{$pre_white_min,}\S+/o)    # whitespaces
      || ($_[0] =~ /\.{$pre_white_min,}\S+/o));    # dots
}

sub endpreformat ($) {
    my $self = shift;

    if ($self->{__mode} & $PRE_EXPLICIT) {
        if ($self->{__line} =~ /$self->preformat_end_marker()/io) {
            $self->{__prev} .= "</PRE>\n";
            $self->{__line} = "";
            $self->{__mode} ^= (($PRE | $PRE_EXPLICIT) & $self->{__mode});
            $self->{__line_action} |= $END;
        }
        return;
    }

    if (!$self->is_preformatted($self->{__line})
        && ($self->endpreformat_trigger_lines() == 1
            || !$self->is_preformatted($self->{__nextline})))
    {
        $self->{__prev} .= "</PRE>\n";
        $self->{__mode} ^= ($PRE & $self->{__mode});
        $self->{__line_action} |= $END;
    }
}

sub preformat ($) {
    my $self = shift;

    if ($self->use_preformat_marker()) {
        if ($self->{__line} =~ /$self->preformat_start_marker()/io) {
            $self->{__line} = "<PRE>\n";
            $self->{__prev} =~ s/<P>//;
            $self->{__mode} |= $PRE | $PRE_EXPLICIT;
            $self->{__line_action} |= $PRE;
            return;
        }
    }

    if ($self->preformat_trigger_lines() == 0
        || ($self->is_preformatted($self->{__line})
            && ($self->preformat_trigger_lines() == 1
                || $self->is_preformatted($self->{__nextline}))))
    {
        $self->{__line} =~ s/^/<PRE>\n/;
        $self->{__prev} =~ s/<P>//;
        $self->{__mode} |= $PRE;
        $self->{__line_action} |= $PRE;
    }
}

sub make_new_anchor ($$) {
    my $self = shift;
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
    my $self = shift;
    my $line_ref = shift;

    my ($anchor) = $self->make_new_anchor(0);
    ${$line_ref} =~ s/([^ ]*)/<A NAME="$anchor">$1<\/A>/;
}

sub anchor_heading ($$$) {
    my $self = shift;
    my $level = shift;
    my $line_ref = shift;

    my ($anchor) = $self->make_new_anchor($level);
    ${$line_ref} =~ s/(<H.>)(.*)(<\/H.>)/$1<A NAME="$anchor">$2<\/A>$3/;
}

sub heading_level ($$) {
    my $self = shift;

    my ($style) = @_;
    $self->{__heading_styles}->{$style} = ++$self->{__num_heading_styles}
      if !$self->{__heading_styles}->{$style};
    $self->{__heading_styles}->{$style};
}

sub heading ($$$$) {
    my $self = shift;
    my $line_ref = shift;
    my $line_action_ref = shift;
    my $next_ref = shift;

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
        || ($lendiff > $self->underline_length_tolerance())
        || ($offsetdiff > $self->underline_offset_tolerance()))
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

sub custom_heading ($$$) {
    my $self = shift;
    my $line_ref = shift;
    my $line_action_ref = shift;

    my ($i, $level);
    for ($i = 0 ; $i < @{$self->custom_heading_regexp()} ; $i++) {
        my $reg = ${$self->custom_heading_regexp()}[$i];
        if (${$line_ref} =~ /$reg/) {
            if ($self->explicit_headings()) {
                $level = $i + 1;
            }
            else {
                $level = $self->heading_level("Cust" . $i);
            }
            $self->tagline("H" . $level, $line_ref);
            $self->anchor_heading($level, $line_ref);
            ${$line_action_ref} |= $HEADER;
            last;
        }
    }
}

sub unhyphenate ($) {
    my $self = shift;

    my $second;

    # This looks hairy because of all the quoted characters.
    # All I'm doing is pulling out the word that begins the next line.
    # Along with it, I pull out any punctuation that follows.
    # Preceding whitespace is preserved.  We don't want to screw up
    # our own guessing systems that rely on indentation.
    ($second) =
      $self->{__nextline} =~ /^\s*([^\W\d_]+[\)\}\]\.,:;\'\"\>]*\s*)/;       # "
    $self->{__nextline}   =~ s/^(\s*)[^\W\d_]+[\)\}\]\.,:;\'\"\>]*\s*/$1/;   # "
         # (The silly comments are for my less-than-perfect code hilighter)

    $self->{__nextline} = $self->getline() if $self->{__nextline} eq "";
    $self->{__line} =~ s/\-\s*$/$second/;
    $self->{__line} .= "\n";
}

sub untabify ($$) {
    my $self = shift;
    my $line = shift;

    while ($line =~ /\011/) {
        $line =~ s/\011/" " x ($self->tab_width() - (length($`) %
	    $self->tab_width()))/e;
    }
    $line;
}

sub tagline ($$$) {
    my $self = shift;
    my $tag = shift;
    my $line_ref = shift;

    chomp ${$line_ref};    # Drop newline
    ${$line_ref} =~ s/^\s*(.*)$/<$tag>$1<\/$tag>\n/;
}

sub iscaps {
    my $self = shift;
    local ($_) = @_;

    my $min_caps_len = $self->min_caps_length();

    # This is ugly, but I don't know a better way to do it.
    # (And, yes, I could use the literal characters instead of the 
    # numeric codes, but this keeps the script 8-bit clean, which will
    # save someone a big headache when they transfer via ASCII ftp.
/^[^a-z\341\343\344\352\353\354\363\370\337\373\375\342\345\347\350\355\357\364\365\376\371\377\340\346\351\360\356\361\362\366\372\374<]*[A-Z\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317\320\321\322\323\324\325\326\330\331\332\333\334\335\336]{$min_caps_len,}[^a-z\341\343\344\352\353\354\363\370\337\373\375\342\345\347\350\355\357\364\365\376\371\377\340\346\351\360\356\361\362\366\372\374<]*$/;
}

sub caps {
    my $self = shift;
    my $line_ref = shift;
    my $line_action_ref = shift;

    if ($self->iscaps(${$line_ref})) {
        $self->tagline($self->caps_tag(), $line_ref);
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
        print STDERR " (", @{$self->{__links_table_order}},
          ")\tKEY: $key\n\tVALUE: $URL\n\tSWITCHES: $switches\n\n"
          if ($self->dict_debug() & 1);
    }
    else {
        if ($self->dict_debug() & 1) {
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
      if ($self->dict_debug() & 1);

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
    while ($dict =~ /\s*(.+)\s+\-+([ieho]+\-+)?\>\s*(.*\S+)\s*\n/ig) {
        $key      = $1;
        $options  = $2;
        $options  = "" unless defined($options);
        $URL      = $3;
        $switches = 0;
        $switches += 1 if $options =~ /i/i;    # Case insensitivity
        $switches += 2 if $options =~ /e/i;    # Evaluate as Perl code
        $switches += 4 if $options =~ /h/i;    # provides HTML, not just URL
        $switches += 8 if $options =~ /o/i;    # Only do this link once

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
    my ($key, $URL, $switches, $options);
    my ($pattern, $href, $i, $r_sw, $code, $code_ref);
    for ($i = 1 ; $i < @{$self->{__links_table_order}} ; $i++) {
        $pattern  = $self->{__links_table_order}->[$i];
        $key      = $pattern;
        $switches = $self->{__links_switch_table}->{$key};

        $href = $self->{__links_table}->{$key};

        $href =~ s@/@\\/@g;
        $href = '<A HREF="' . $href . '">$&<\\/A>'
          if !($switches & 4);

        $r_sw = "s";    # Options for replacing
        $r_sw .= "i" if ($switches & 1);
        $r_sw .= "e" if ($switches & 2);

        # Generate code for replacements.
        # Create a subroutine for each replacement, named after the current
        # index.
        # We need to do an "eval" to create these because we need to
        # be able to treat the *contents* of the $href variable
        # as if it were perl code, because sometimes the $href
        # contains things which need to be evaluated, such as $& or $1,
        # not just those cases where we have a "e" switch.
        $code =
"sub __replace$i (\$) {\nmy \$al = shift;\n\$al =~ s/$pattern/$href/$r_sw;\nreturn \$al; }\n";
        print STDERR "$code" if ($self->dict_debug() & 2);
        eval "$code";

        # compile searching pattern
        if ($switches & 1)    # i
        {
            $self->{__search_patterns}->[$i] = qr/$pattern/si;
        }
        else {
            $self->{__search_patterns}->[$i] = qr/$pattern/s;
        }
    }
}

sub in_link_context ($$) {
    my ($match, $before) = @_;
    return 1 if $match =~ m@</?A>@i;    # No links allowed inside match

    my ($final_open, $final_close);
    $final_open  = rindex($before, "<A ") - $[;
    $final_close = rindex($before, "</A>") - $[;

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

# Check (and alter if need be) the bits in this line matching
# the patterns in the link dictionary.
sub check_dictionary_links ($$$) {
    my $self = shift;
    my $line_ref = shift;
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
        if ($switches & 8)    # Do link only once
        {
            $line_with_links = "";
            while (!$self->{__done_with_link}->[$i]
                && ${$line_ref} =~ $self->{__search_patterns}->[$i])
            {
                $self->{__done_with_link}->[$i] = 1;
                $line_link = $LINK if (!$line_link);
                $before = $`;
                $linkme = $&;

                ${$line_ref} =
                  substr(${$line_ref}, length($before) + length($linkme));
                if (!in_link_context($linkme, $line_with_links . $before)) {
                    no strict 'refs';
                    print STDERR "Link rule $i matches $linkme\n"
                      if ($self->dict_debug() & 4);

                    # call the special subroutine already created to do
                    # this replacement
                    $repl_func = "__replace$i";
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
                $before = $`;
                $linkme = $&;

                ${$line_ref} =
                  substr(${$line_ref}, length($before) + length($linkme));
                if (!in_link_context($linkme, $line_with_links . $before)) {
                    no strict 'refs';
                    print STDERR "Link rule $i matches $linkme\n"
                      if ($self->dict_debug() & 4);

                    # call the special subroutine already created to do
                    # this replacement
                    $repl_func = "__replace$i";
                    $linkme    = &$repl_func($linkme);
                }
                $line_with_links .= $before . $linkme;
            }
            ${$line_ref} = $line_with_links . ${$line_ref};
        }
    }
    ${$line_action_ref} |= $line_link;  # Cheaper only to do bitwise OR once.
}

sub load_dictionary_links ($) {
    my $self = shift;
    my ($dict, $contents);
    @{$self->{__links_table_order}} = 0;
    %{$self->{__links_table}}       = ();

    foreach $dict (@{$self->links_dictionaries()}) {
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
    my $self = shift;
    my $line_ref = shift;
    my $line_action_ref = shift;

    $self->check_dictionary_links($line_ref, $line_action_ref);
    warn $@ if $@;
}

sub getline ($) {
    my $self = shift;

    my ($line);
    $line = <>;
    $line = "" unless defined($line);
    $line =~ s/[ \011]*\015$//;    # Chop trailing whitespace and DOS CRs
    $line = $self->untabify($line);    # Change all tabs to spaces
    $line;
}

sub process_para ($$) {
    my $self = shift;
    my $para = shift;
}

sub txt2html ($;$) {
    my $self     = shift;
    my $args_ref = (@_ ? shift: 0);

    # and set with the passed-in args
    if ($args_ref && @{$args_ref}) {
        if (!$self->args($args_ref)) {
            pod2usage(
                {
                    -message => "Unrecognised option",
                    -exitval => "NOEXIT",
                    -verbose => 0,
                }
            );
            return 0;
        }
    }

    push (@{$self->links_dictionaries()}, ($self->default_link_dict()))
      if ($self->make_links() && (-f $self->default_link_dict()));
    $self->deal_with_options();
    if ($self->make_links()) {
        push (@{$self->links_dictionaries()}, ($self->system_link_dict()))
          if -f $self->system_link_dict();
        $self->load_dictionary_links();
    }

    my $outhandle;
    my $not_to_stdout;

    # open the output
    if ($self->outfile() eq "-") {
        $outhandle     = *STDOUT;
        $not_to_stdout = 0;
    }
    else {
        open(HOUT, "> " . $self->outfile()) || die "Error: unable to open ",
          $self->outfile(), ": $!\n";
        $outhandle     = *HOUT;
        $not_to_stdout = 1;
    }

    $self->{__non_header_anchor} = 0;

    # Moved this way up here so we can grab the first line and use it
    # as the title (if --titlefirst is set)
    $self->{__mode}             = 0;
    $self->{__listnum}          = 0;
    $self->{__list_indent}      = "";
    $self->{__line_action}      = $NONE;
    $self->{__prev_action}      = $NONE;
    $self->{__prev_line_length} = 0;
    $self->{__prev_indent}      = 0;
    $self->{__prev}             = "";
    $self->{__line}             = $self->getline();
    $self->{__nextline}         = 0;
    $self->{__nextline}         = $self->getline() if $self->{__line};

    # Skip leading blank lines
    while (is_blank($self->{__line}) && $self->{__line}) {
        $self->{__prev}     = $self->{__line};
        $self->{__line}     = $self->{__nextline};
        $self->{__nextline} = $self->getline() if $self->{__nextline};
    }

    if (!$self->extract()) {
        print $outhandle '<!DOCTYPE HTML PUBLIC "' . $self->doctype() . "\">\n"
          unless !$self->doctype();
        print $outhandle "<HTML>\n";
        print $outhandle "<HEAD>\n";

        # if --titlefirst is set and --title isn't, use the first line
        # as the title.
        if ($self->titlefirst() && !$self->title()) {
            my ($tit) = $self->{__line} =~ /^ *(.*)/;    # grab first line
            $tit =~ s/ *$//;    # strip trailing whitespace
            $tit = escape($tit) if $self->escape_HTML_chars();
            $self->set('title' => $tit);
        }
        if (!$self->title()) {
            $self->set('title' => "");
        }
        print $outhandle "<TITLE>", $self->title(), "</TITLE>\n";

        if ($self->append_head()) {
            open(APPEND, $self->append_head())
              || die "Failed to open $self->append_head()\n";
            while (<APPEND>) {
                print $outhandle $_;
            }
            close(APPEND);
        }

        print $outhandle
          "<META NAME=\"generator\" CONTENT=\"$PROG v$VERSION\">\n";
        print $outhandle "</HEAD>\n";
        print $outhandle "<BODY>\n";
    }

    if ($self->prepend_file()) {
        if (-r $self->prepend_file()) {
            open(PREPEND, $self->prepend_file());
            while (<PREPEND>) {
                print $outhandle $_;
            }
            close(PREPEND);
        }
        else {
            print STDERR "Can't find or read file ", $self->prepend_file(),
              " to prepend.\n";
        }
    }

    do {

        if (!$self->link_only()) {

            ###############
            # Need to move this stuff into getline
            #
            $self->{__line_length} =
              length($self->{__line});    # Do this before tags go in
            $self->{__line_indent} =
              count_indent($self->{__line}, $self->{__prev_indent});

            #
            $self->{__line} = escape($self->{__line})
              if $self->escape_HTML_chars();

            #
            ###############

            $self->endpreformat()
              if (($self->{__mode} & $PRE)
                && ($self->preformat_trigger_lines() != 0));

            $self->hrule() if !($self->{__mode} & $PRE);

            $self->custom_heading(\$self->{__line}, \$self->{__line_action})
              if (@{$self->custom_heading_regexp()}
                && !($self->{__mode} & $PRE));

            $self->liststuff()
              if (!($self->{__mode} & $PRE) && !is_blank($self->{__line}));

            $self->heading(\$self->{__line}, \$self->{__line_action},
			    \$self->{__nextline})
              if (!$self->explicit_headings()
                && !($self->{__mode} & ($PRE | $HEADER))
                && $self->{__nextline} =~ /^\s*[=\-\*\.~\+]+\s*$/);

            #        $self->custom_tag()
            #	    if ((@{$self->custom_tags()})
            #                        && !($self->{__mode} & $PRE)
            #                        && !($self->{__line_action} & $HEADER));

            $self->mailstuff()
              if ($self->mailmode()
                && !($self->{__mode} & $PRE)
                && !($self->{__line_action} & $HEADER));

            $self->preformat()
              if (!($self->{__line_action} & ($HEADER | $LIST | $MAILHEADER))
                && !($self->{__mode} & ($LIST | $PRE))
                && $self->{__preformat_enabled});

            $self->paragraph();
            $self->shortline();

            $self->unhyphenate()
              if ($self->unhyphenation()
                && ($self->{__line} =~ /[^\W\d_]\-$/)
                &&    # ends in hyphen
                      # next line starts w/letters
                ($self->{__nextline} =~ /^\s*[^\W\d_]/)
                && !($self->{__mode} & ($PRE | $HEADER | $MAILHEADER | $BREAK))
            );

            $self->caps(\$self->{__line}, \$self->{__line_action})
	      if !($self->{__mode} & $PRE);

        }

        $self->make_dictionary_links(\$self->{__line}, \$self->{__line_action})
          if ($self->make_links()
            && !is_blank($self->{__line})
            && @{$self->{__links_table_order}});

        # All the matching and formatting is done.  Now we can 
        # replace non-ASCII characters with character entities.
        if (!$self->eight_bit_clean()) {
            my @chars = split (//, $self->{__line});
            foreach $_ (@chars) {
                $_ = $char_entities{$_} if defined($char_entities{$_});
            }
            $self->{__line} = join ("", @chars);
        }

        # Print it out and move on.

        print $outhandle $self->{__prev};

        if (!is_blank($self->{__nextline})) {
            $self->{__prev_action}      = $self->{__line_action};
            $self->{__line_action}      = $NONE;
            $self->{__prev_line_length} = $self->{__line_length};
            $self->{__prev_indent}      = $self->{__line_indent};
        }

        $self->{__line} =
          join ("",
            map { $char_entities2{$_} || $_ } split (//, $self->{__line}))
          unless $self->eight_bit_clean();
        $self->{__prev}     = $self->{__line};
        $self->{__line}     = $self->{__nextline};
        $self->{__nextline} = $self->getline() if $self->{__nextline};
    } until (!$self->{__nextline} && !$self->{__line} && !$self->{__prev});

    $self->{__prev} = "";
    $self->endlist($self->{__listnum}, \$self->{__prev})
      if ($self->{__mode} & $LIST);    # End all lists
    print $outhandle $self->{__prev};

    print $outhandle "\n";

    print $outhandle "</PRE>\n" if ($self->{__mode} & $PRE);

    if ($self->append_file()) {
        if (-r $self->append_file()) {
            open(APPEND, $self->append_file());
            while (<APPEND>) {
                print $outhandle $_;
            }
            close(APPEND);
        }
        else {
            print STDERR "Can't find or read file ", $self->append_file(),
              " to append.\n";
        }
    }

    if (!$self->extract()) {
        print $outhandle "</BODY>\n";
        print $outhandle "</HTML>\n";
    }
    if ($not_to_stdout) {
        close($outhandle);
    }
    return 1;
}

# run this from the command line
sub run_txt2html {
    my ($caller) = @_;  # ignore all passed in arguments,
			# because this only should look at ARGV

    my $conv = new HTML::TextToHTML(\@ARGV);
    my @args = ();

    # now the remainder must be input-files
    #    foreach my $df (@ARGV)
    #    {
    #	push @args, "--infile", $df;
    #    }
    $conv->txt2html(\@args);
}

#------------------------------------------------------------------------
1;

# These are the default settings
__DATA__
system_link_dict = /usr/share/txt2html/txt2html.dict
