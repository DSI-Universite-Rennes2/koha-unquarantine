use strict;
use warnings;
use utf8;
use DateTime;
use DateTime::TimeZone;

# Get arguments, first is NotForLoan code for quarantine status, second is duration in days of the quarantine
my $quarantinecode = $ARGV[0];
my $quarantinetime = $ARGV[1] // 10;
my $quarantinebranch = $ARGV[2];


# Test the arguments and die with usage if they are not valids
if ( !defined $quarantinecode || $quarantinecode !~ /^\-?\d+$/ || $quarantinetime =~ /\D/ ) {
    die "USAGE:\tperl unquarantine.pl [qc] [qd] [qb]\n\nARGUMENTS:\n  qc\tCode of the quarantine status, must be a possible value of items.notforloan (integer)\n  qd\tDuration of the quarantine in days (positive integer)\n  qb\tcode of the holding branch (optional)\n";
}

# Importing Koha package only after testing arguments to faster usage display
eval {
    require Koha::DateUtils;
    require Koha::Items;
    require Koha::Old::Checkouts;
    require C4::Circulation;
    Koha::DateUtils->import();
    Koha::Items->import();
    Koha::Old::Checkouts->import();
    C4::Circulation->import();
};
if ($@) {
    warn "Error including Koha's package: $@";
}

# Get a DateTime objet of X days before now
my $referencedate = DateTime->now()->set_time_zone(C4::Context->tz)->truncate( to => 'day' )->add(days => 0-$quarantinetime);
# Get items having the quarantine status on NotForLoan and who doesn't been touched since X days
my $params = {
	        notforloan	=> $quarantinecode
	    };
#if branch code is given, we filter items by holding branch
if ( defined $quarantinebranch && length $quarantinebranch ){
	$params->{holdingbranch} = $quarantinebranch;
}

my $items = Koha::Items->search($params);
# Modify selected items to put them back the available NotForLoan status
while ( my $i = $items->next ) {
    my $isupdated = 0;
    # Get the last returned issue of each items
    my $checkouts = Koha::Old::Checkouts->search({
            itemnumber => $i->itemnumber
        },{
            order_by => {
                -desc => 'returndate'
            },
            limit => 1
        }
    );
    if ( my $c = $checkouts->next ) {
        # Compare return date of the last checkout and date X days ago
        my $returndate = dt_from_string($c->returndate)->truncate( to => 'day' );
        if (DateTime->compare($returndate, $referencedate) == 0) {
            $i->notforloan(0)->store;
            #DeleteTransfer($i->itemnumber);
            $isupdated = 1;
        }
    }
	# If no oldissues found or if last returndate is not X days old, test lastseendate
    if ($isupdated == 0) {
		my $datelastseen = dt_from_string($i->datelastseen);
		if (DateTime->compare($datelastseen, $referencedate) == 0) {
			$i->notforloan(0)->store;
			#DeleteTransfer($i->itemnumber);
		}
	}
}
