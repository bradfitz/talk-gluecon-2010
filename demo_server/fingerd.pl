#!/usr/bin/perl

use strict;
$SIG{ALRM} = sub { exit(2); };
alarm 10;
my $line;
while (defined(my $c = getc)) {
    last if $c eq "\n";
    $line .= $c;
    die "Line too long.\n" if length($line) >= 80;
}

my $user;
my $http = 0;
if ($line =~ m!^GET /webfinger\?q=(?:acct(?::|%3[aA]))?(\w+)(?:\@|%40)danga.com\b!) {
    $user = $1;
    $http = 1;
    while (<STDIN>) {
	last unless /\S/;
    }
} else {
    unless ($line =~ /^(\w+)\s*$/) {
	print "Bogus line: [$line]\n";
    }
    $user = $1;
}

exit 0 unless $user eq "brad";

if (!$http) {   # old-skool
    print "Name: Brad Fitzpatrick\n";
    print "URL: http://bradfitz.com/\n";
    print "OpenID: http://bradfitz.com/\n";
    print "City: San Francisco, California, USA\n";
    print "Photo: http://bradfitz.com/pics/brad-belize-small.jpg\n";
    print "Phone: +1 (415) 366-6169\n";
    print "Email: brad\@danga.com\n";
    print "SMTP: brad\@danga.com\n";
    print "XMPP: brad\@fitzpat.com\n";
    print "Service-URL: http://brad.livejournal.com/\n";
    print "Service-URL: http://www.facebook.com/bradfitz\n";
    print "Service-URL: http://twitter.com/bradfitz\n";
    print "Service-URL: http://www.flickr.com/photos/15738836\@N00/\n";
    print "Service-URL: http://www.youtube.com/profile?user=bradfitztube\n";
    print "Service-URL: http://www.google.com/profiles/bradfitz\n";
    print "Service-URL: http://reddit.com/user/bradfitz/\n";
    print "Service-URL: http://www.yelp.com/user_details?userid=oBWvYxHrbjVHZGRu17VG2g\n";
    exit 0;
}

# WebFinger...
print <<'END'
HTTP/1.0 200 OK
Content-Type: application/xrd+xml

<?xml version='1.0'?>
<XRD xmlns='http://docs.oasis-open.org/ns/xri/xrd-1.0'>
    <Subject>acct:brad@danga.com</Subject>
    <Alias>http://bradfitz.com/</Alias>
    <Link rel='http://webfinger.net/rel/profile-page' href='http://bradfitz.com/' type='text/html'/>
    <Link rel='http://webfinger.net/rel/user-photo' href='http://bradfitz.com/pics/brad-belize-small.jpg' type='text/html'/>
    <Link rel='http://gmpg.org/xfn/11' href='http://bradfitz.com/' type='text/html'/>
    <Link rel='http://specs.openid.net/auth/1.1/provider' href='http://bradfitz.com/'/>
    <Link rel='describedby' href='http://bradfitz.com/' type='text/html'/>
</XRD>
END



