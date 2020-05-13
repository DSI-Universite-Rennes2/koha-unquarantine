use strict;
use DateTime;

# Get arguments, first is NotForLoan code for quarantine status, second is duration in days of the quarantine
my $quarantinecode = $ARGV[0];
my $quarantinetime = $ARGV[1] // 10;

# Test the arguments and die with usage if they are not valids
if ( !defined $quarantinecode || $quarantinecode !~ /^\-?\d+$/ || $quarantinetime =~ /\D/ ) {
    die "USAGE:\tperl unquarantine.pl [qc] [qd]\n\nARGUMENTS:\n  qc\tCode of the quarantine status, must be a possible value of items.notforloan (integer)\n  qd\tDuration of the quarantine in days (positive integer)\n";
}

# Importing Koha package only after testing arguments to faster usage display
eval {
    require C4::Items;
    require Koha::Items;
    C4::Items->import();
    Koha::Items->import();
};
if ($@) {
    warn "Error including Koha's package: $@";
}

# Get a DateTime objet of X days before now
my $olderthan = DateTime->now()->add(days => 0-$quarantinetime);
# Get items having the quarantine status on NotForLoan and who doesn't been touched since X days
my %conditions = (
    notforloan => $quarantinecode,
    datelastseen => {
        '<=' => $olderthan->strftime('%Y-%m-%d')
    }
);
my $items = Koha::Items->search( \%conditions );
# Modify selected items to put them back the available NotForLoan status
while ( my $i = $items->next ) {
    my $item = GetItem( $i->itemnumber );
    $item->{'notforloan'} = 0;
    ModItem( $item, undef, $i->itemnumber);
}
