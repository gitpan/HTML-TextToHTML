use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

# add another target to the installation;
# copy the link dictionary to a known global spot.
sub MY::install {
	package MY;
	my $dest_dir = '/usr/share/txt2html';
	my $link_dict = 'TextToHTML.dict';
	my $script = shift->SUPER::install(@_);
	$script =~ s/install :: (.*)$/install :: $1 install_link_dictionary/m;
	$script .= <<"INSTALL";

install_link_dictionary :
	\$(MKPATH) $dest_dir
	\$(PERL) -I\$(PERL_ARCHLIB) -I\$(PERL_LIB) -MExtUtils::Command -e cp $link_dict $dest_dir


INSTALL

	return $script;
}

WriteMakefile(
    'NAME'		=> 'HTML::TextToHTML',
    'VERSION_FROM'	=> 'TextToHTML.pm', # finds $VERSION
    'PREREQ_PM'		=> {
		'ExtUtils::configPL' => 0,
		'Getopt::Long' => 0,
		'File::Basename' => 0,
		'Pod::Usage' => 0,
		'Data::Dumper' => 0,
		'Test::More' => 0
    	},
    'PL_FILES' => { 'texthyper.PL' => 'texthyper'},
    'EXE_FILES' => ['texthyper'],
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'TextToHTML.pm', # retrieve abstract from module
       AUTHOR     => 'Kathryn Andersen <rubykat@katspace.com>') : ()),
);
