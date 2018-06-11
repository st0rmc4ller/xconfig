#!/usr/bin/perl

use Tkx;
use Mtik;
use Net::Ping;
use LWP;



use Data::Dumper;
$Data::Dumper::Indent = 1;

my $pass;
my $default;
my $dev_hostname;
my $ssid;
my $channel;
my $wifi_password;
my $fname;
my $lname;
my $description;	

my @channels = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
my @frequencies = ("2412","2417","2422","2427","2432","2437","2442","2447","2452","2457","2462","2467","2472","2484");

my $mw = Tkx::widget->new('.');
$mw->g_wm_minsize(600, 500);
$mw->g_wm_title('Mikrotik Router Configuration');


my $font = 'TkDefaultFont';
#my $font = '-*-lucida-medium-r-*-*-11-*-100-100-*-*-*-*'; 
my $current_ip_label = $mw->new_label(-font => $font, -text => 'Current IP:', -width => 15);
$current_ip_label->g_place(-anchor => 'nw', -x => 2, -y => 20);
my $current_ip = '';
my $current_ip_input = $mw->new_entry(-width => 12, -textvariable => \$current_ip);
$current_ip_input->g_place(-anchor => 'nw', -x => 125, -y => 20);

my $current_user_label = $mw->new_label(-font => $font, -text => 'Current Username:', -width => 15, -anchor => 'e');
$current_user_label->g_place(-anchor => 'nw', -x => 2, -y => 40);
#my $font = $current_user_label->cget('-font');
#print STDERR "$font\n";
#my $w = Tkx::font_measure($font, 'Current Username:');
#print STDERR "$w\n";
my $current_user = '';
my $current_user_input = $mw->new_entry(-width => 20, -textvariable => \$current_user);
$current_user_input->g_place(-anchor => 'nw', -x => 125, -y => 40);

my $current_pass_label = $mw->new_label(-text => 'Current Password:', -width => 15, -anchor => 'e');
$current_pass_label->g_place(-anchor => 'nw', -x => 2, -y => 60);
my $current_pass = '';
my $current_pass_input = $mw->new_entry(-width => 20, -textvariable => \$current_pass);
$current_pass_input->g_place(-anchor => 'nw', -x => 125, -y => 60);

my $first_name_label = $mw->new_label(-text => 'First Name:', -width => 15, -anchor => 'e');
$first_name_label->g_place(-anchor => 'nw', -x => 2, -y => 80);
my $first_name_input = $mw->new_entry(-width => 20, -textvariable => \$fname);
$first_name_input->g_place(-anchor => 'nw', -x => 125, -y => 80);

my $last_name_label = $mw->new_label(-text => 'Last Name:', -width => 15, -anchor => 'e');
$last_name_label->g_place(-anchor => 'nw', -x => 2, -y => 100);
my $last_name_input = $mw->new_entry(-width => 20, -textvariable => \$lname);
$last_name_input->g_place(-anchor => 'nw', -x => 125, -y => 100);

my $description_label = $mw->new_label(-text => 'Description:', -width => 15, -anchor => 'e');
$description_label->g_place(-anchor => 'nw', -x => 2, -y => 120);
my $description_input = $mw->new_entry(-width => 40, -textvariable => \$description);
$description_input->g_place(-anchor => 'nw', -x => 125, -y => 120);

my $hostname_label = $mw->new_label(-text => 'Hostname:', -width => 15, -anchor => 'e');
$hostname_label->g_place(-anchor => 'nw', -x => 2, -y => 140);
my $hostname_input = $mw->new_entry(-width => 20, -textvariable => \$dev_hostname);
$hostname_input->g_place(-anchor => 'nw', -x => 125, -y => 140);

my $channel_label = $mw->new_label(-text => 'Channel:', -width => 15, -anchor => 'e');
$channel_label->g_place(-anchor => 'nw', -x => 2, -y => 160);
my $channel_input = $mw->new_ttk__combobox(-width => 3, -textvariable => \$channel);
$channel_input->g_place(-anchor => 'nw', -x => 125, -y => 160);
$channel_input->configure(-values => "1 2 3 4 5 6 7 8 9 10 11 12 13 14");

my $SSID_label = $mw->new_label(-text => 'SSID', -width => 15, -anchor => 'e');
$SSID_label->g_place(-anchor => 'nw', -x => 2, -y => 180);
my $SSID_input = $mw->new_entry(-width => 20, -textvariable => \$ssid);
$SSID_input->g_place(-anchor => 'nw', -x => 125, -y => 180);

my $WiFi_password_label = $mw->new_label(-text => 'Wifi Password:', -width => 15, -anchor => 'e');
$WiFi_password_label->g_place(-anchor => 'nw', -x => 2, -y => 200);
my $WiFi_password_input = $mw->new_entry(-width => 20, -textvariable => \$wifi_password);
$WiFi_password_input->g_place(-anchor => 'nw', -x => 125, -y => 200);

my $end_button = $mw->new_button( -text => 'Exit', -width => 5, -command => sub {exit; });
$end_button->g_place( -x => 10, -y => 270);

my $clear_button = $mw->new_button( -text => 'Clear', -width => 5, -command => \&clear);
$clear_button->g_place( -x => 10, -y => 240);

my $read_button = $mw->new_button( -text => 'Read', -width => 5, -command => \&read_router);
$read_button->g_place( -x => 125, -y => 225);

my $write_button = $mw->new_button( -text => 'Write', -width => 5, -command => \&save_settings_to_router);
$write_button->g_place( -x => 175, -y => 225);

my $ran_pass_but = $mw->new_button( -text => 'New', -width => 5, -command => \&pas_gen);
$ran_pass_but->g_place( -x => 250, -y => 197);

my $gen_button = $mw->new_button( -text => 'Fill Fields', -width => 10, -command => \&geno);
$gen_button->g_place( -x => 125, -y => 255); 

my $print_button = $mw->new_button( -text => 'Print', -width => 5, -command => \&print_sheet);
$print_button->g_place(-x => 225, -y => 225);
Tkx::MainLoop();
exit;

sub clear {
	$ssid = '';
	$description = '';
	$fname = '';
	$lname = '';
	$dev_hostname = '';
	$wifi_password = '';
	$channel = '';
}

sub geno {

	if ( $fname eq '' || $lname eq '')
	{
	Tkx::tk___messageBox(
	-parent => $mw,
	-icon => error,
	-title => 'Enter Information',
	-message => 'Please fill the first and last name fields');	
	}
	else {
	$description = join(' ', $fname, $lname); 
	
	my $f_initial;
	my $l_16;
	
	$f_initial = substr $fname, 0, 1;
	$l_16 = substr $lname, 0, 16;
	
	$ssid = $f_initial . $l_16;
	$dev_hostname = $f_initial . $l_16 . 'Router';
	&pas_gen;
	}
}
sub pas_gen {
	my @nums;
	my $string2 = '';
	my $i;
	$wifi_password = '';
	for ($i = 0; $i < 5; ++$i)
	{
		@nums[i] = int(rand(10));
		$wifi_password = join('', @nums[i], $string2, $wifi_password);
	}
	$wifi_password = join('', 'SouthDakota', $wifi_password);			
}

sub read_router {
	if (&connect_router != 0)
		{
			return;
		}
	
	my %vals;
	my %query;
	my $security_profile;
	
	%vals = ('.proplist' => 'name,ssid,security-profile,frequency');
	my($rc, @rets) = Mtik::mtik_cmd('/interface/wireless/print', \%vals);
	
	foreach my $ret (@rets) {
		if($ret->{'name'} eq 'wlan1') {
			$wlan_if_name = $ret->{'name'};
			$ssid = $ret->{'ssid'};
			$security_profile = $ret->{'security-profile'};
            $frequency = $ret->{'frequency'};
		}
	}
	
	%query = ('name' => $security_profile);
	%vals = ('.proplist' => 'wpa-pre-shared-key,wpa2-pre-shared-key');
	($rc, @rets) = Mtik::mtik_query('/interface/wireless/security-profiles/print', \%vals, \%query);
	$wifi_password = $rets[0]->{'wpa2-pre-shared-key'};
		
	%vals = ();
	($rc, @rets) = Mtik::mtik_cmd('/system/identity/print', \%vals);
	$dev_hostname = $rets[0]->{'name'};

	for (my $i = 0; $i < 14; ++$i)
	{
		if ($frequency eq $frequencies[$i]) {
			
			$channel = $channels[$i];
			last;
		}
	}	
	
	%vals = ();
	%query = ();
	($rc, @rets) = Mtik::mtik_cmd('/snmp/print', \%vals, \%query);
	$description = $rets[0]->{'location'};

	$desc = $description;	
	($fname, $lname) = split(' ', $desc);
	
	&disconnect_router;
}

sub connect_router {
	my $ping = Net::Ping->new('tcp', 1);
	$ping->port_number('8728');
	if(!$ping->ping($current_ip)) {
		Tkx::tk___messageBox(
	-parent => $mw,
	-icon => error,
	-title => 'Error Connecting to Router',
	-message => 'xconfig was unable to establish a connection with the router');	
		return 1;
	}
	
	if (! Mtik::login( $current_ip, $current_user, $current_pass))
	{
		Tkx::tk___messageBox(
	-parent => $mw,
	-icon => error,
	-title => 'Error Connecting to Router',
	-message => 'xconfig was unable to establish a connection with the router');			
	return 1;
	}
	return 0;
}

sub disconnect_router {
	Mtik::logout;
	
}

sub save_settings_to_router {

	if (&connect_router != 0)
	{
		return;
	}

	
	if($wifi_password !~ /^[0-9a-zA-Z_\.\@\#\%\^\&\*\-]{8,40}$/) {
		## invalid password 
		Tkx::tk___messageBox(
			-parent => $mw,
			-icon => error,
			-title => 'Invalid Password',
			-message => 'Passwords must be between 8 and 40 characters and may only include the following special characters: .@#%^&*-');
		return;
	}

	my $i = 0;
	for ($i = 0; $i < 14; ++$i)
	{
		if ($channel == $channels[$i])
		{
			$frequency = $frequencies[$i];
		}
	}
	
	my $ch_width;
	
	if ( $channel <= 7) 
	{
		$ch_width = "20/40mhz-Ce";
	}
	else {
		$ch_width = "20/40mhz-eC";
	}	
	
	my %vals = ('.proplist' => '.id,security-profile');
	my %query = ('name' => 'wlan1');
	my ($rc, @rets) = Mtik::mtik_query('/interface/wireless/print', \%vals, \%query);
	my $interface_id = $rets[0]->{'.id'};
	my $profile_name = $rets[0]->{'security-profile'};

	## Save the WiFi SSID
	%vals = (
		'.id' => $interface_id,
		'channel-width' => $ch_width,
		'frequency' => $frequency,
		'ssid' => $ssid
	);
	($rc, @rets) = Mtik::mtik_cmd('/interface/wireless/set', \%vals);
	
	%vals = ( '.proplist' => '.id');
	%query = ('name' => $profile_name);
	($rc, @rets) = Mtik::mtik_query('/interface/wireless/security-profiles/print', \%vals, \%query);
	my $profile_id = $rets[0]->{'.id'};
	%vals = (
		'.id' => $profile_id,
		'wpa-pre-shared-key' => $wifi_password,
		'wpa2-pre-shared-key' => $wifi_password);
	($rc, @rets) = Mtik::mtik_cmd('/interface/wireless/security-profiles/set', \%vals);
	
	%vals = ('location' => $description);
	Mtik::mtik_cmd('/snmp/set', \%vals);
	
	%vals = ('name' => $dev_hostname);
	Mtik::mtik_cmd('/system/identity/set', \%vals);
	
	
	&disconnect_router;
}

sub print_sheet {

if ( $description eq '' || $ssid eq '' || $wifi_password eq '')
{
			Tkx::tk___messageBox(
			-parent => $mw,
			-icon => error,
			-title => 'Need More Information',
			-message => 'Please Generate/Fill in Description, SSID, and wifi password');
			
			return;
	}		
	my $filename = sprintf("%s%s", $fname, $lname);
	$filename =~ s/[^a-zA-Z0-9]+/_/g;
	$filename .= ".pdf";
	
%data = (
	'outfile'	=>  $filename,
	'type'		=> 'Router',
	'name'		=> ($description),
	'ssid'		=> ($ssid),
	'password'	=> ($wifi_password),
	'mac'		=> ('E4:8D:8C:51:B5:55'),
	'print'		=> 'yes'
);

my $lwp = LWP::UserAgent->new;
my $url = 'http://admin.datatruck.com/mtik/config_sheet.cgi';
my $response = $lwp->post($url, \%data);
}
