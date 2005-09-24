namespace eval dotlrn_admin {
    ad_proc -public mount_point {} {} {
	return dotlrn-admin
    }
    ad_proc -public get_admin_url {} {} {
	return [dotlrn::get_url]/[mount_point]/admin
    }
}