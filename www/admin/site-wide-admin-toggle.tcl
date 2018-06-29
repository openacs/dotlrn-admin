#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date Jan 12, 2002
    @cvs-id $Id$
} -query {
    user_id
    value
    {referer "users"}
}

if { ![acs_user::site_wide_admin_p] } {
    ns_log notice "user has tried to site-wide-admin-toggle  without permission"
    ad_return_forbidden \
        "Permission Denied" \
        "<blockquote>You don't have permission to see this page.</blockquote>"
    ad_script_abort
}

if {$value eq "grant"} {
    ad_permission_grant $user_id [acs_magic_object "security_context_root"] "admin"
} elseif {$value eq "revoke"} {
    ad_permission_revoke $user_id [acs_magic_object "security_context_root"] "admin"
}

#
# Flush all permission checks pertaining to this user.
#
permission::cache_flush -party_id $user_id

ad_returnredirect $referer
ad_script_abort

#
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
