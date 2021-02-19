#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use Data::Dumper;
use Soapbox;

my $soapbox = Soapbox->load($ARGV[0]);
my @episodes = @{ $soapbox->episodes };
my $episode = $episodes[0];
my $encoder = Soapbox::Encoder->new(master => { source => $ARGV[1], episode => $episode });

my @to_encode = (
    'author-bar.spx' => 'speexenc-ultra-wideband',
    # 'author-bar.mp3' => 'lame-vbr-5',
    # 'foo-bar.flac' => 'flac',
    # 'author-bar.x264.mp4' => 'ffmpeg-avc',
    # 'author-bar.x265.mp4' => 'ffmpeg-hevc',
);

$encoder->encode(@to_encode);
