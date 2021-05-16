#!/usr/bin/plackup
use strict;
use warnings;
use Prometheus::Tiny;
use Plack::Builder;

my $prom = Prometheus::Tiny->new;

sub collect {
    my $df   = `df`;
    my $skip = 1;
    foreach my $line ( split( "\n", $df ) ) {
        if ($skip) {

            # skip the first line since it's the header
            $skip = 0;
            next;
        }
        my @fields          = split( / {1,}/, $line );
        my $filesystem      = $fields[0];
        my $size            = $fields[1];
        my $used            = $fields[2];
        my $available       = $fields[3];
        my $used_percentage = $fields[4];
        my $mountpath       = $fields[5];

        # remove the percentage symbol
        $used_percentage =~ s/%//;

        $prom->set( 'disk_size', $size,
            { "filesystem" => $filesystem, "mountpath" => $mountpath } );
        $prom->set( 'disk_used', $used,
            { "filesystem" => $filesystem, "mountpath" => $mountpath } );
        $prom->set( 'disk_available', $available,
            { "filesystem" => $filesystem, "mountpath" => $mountpath } );
        $prom->set( 'disk_used_percentage', $used_percentage,
            { "filesystem" => $filesystem, "mountpath" => $mountpath } );
    }
}

builder {
    # collect stats when metrics is requested
    mount "/metrics" => sub {
        collect();
        return [ 200, [ 'Content-Type' => 'text/plain' ], [ $prom->format ] ];
    }
};
