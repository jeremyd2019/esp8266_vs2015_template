#!/usr/bin/perl

use strict;
use warnings;

use File::Basename;
use File::Copy;
use File::Spec::Functions qw(rel2abs);
use Win32;

my $templatepath = rel2abs(dirname($0));
my ($target, $project) = @ARGV;
my $projectguid = Win32::GuidGen();

sub filterfile
{
	my ($infile, $outfile) = @_;
	open(my $ifh, "<", $infile);
	open(my $ofh, ">", $outfile);
	while (<$ifh>)
	{
		s/project/$project/g;
		s/\{7B5712D5-FF35-4041-B3F2-4BD004B2D679\}/$projectguid/g;
		print $ofh $_;
	}
	close ($ifh);
	close ($ofh);
}

copy("$templatepath/espmissingincludes.h", "$target/espmissingincludes.h");
copy("$templatepath/intellisense.h", "$target/intellisense.h");
copy("$templatepath/user_config.h", "$target/user_config.h");
copy("$templatepath/project.c", "$target/$project.c");

filterfile("$templatepath/Makefile", "$target/Makefile");
filterfile("$templatepath/.gitignore", "$target/.gitignore");
filterfile("$templatepath/project.sln", "$target/$project.sln");
filterfile("$templatepath/project.vcxproj", "$target/$project.vcxproj");
filterfile("$templatepath/project.vcxproj.filters", "$target/$project.vcxproj.filters");

