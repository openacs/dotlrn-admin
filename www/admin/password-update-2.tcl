ad_page_contract {
    Updates the users password if password_1 matches password_2
   
    @cvs-id $Id$
} {
    user_id:integer,notnull
    password_1:notnull
    password_2:notnull
    {return_url ""}

} -validate {
    confirm_password -requires {password_2:notnull} {
        if {$password_2 eq ""} {
            ad_complain "[_ dotlrn.lt_You_need_to_confirm_t]"
        }
    }
    new_password_match -requires {password_1:notnull password_2:notnull confirm_password} {
        if {$password_1 ne $password_2 } {
            ad_complain "[_ dotlrn.lt_Your_passwords_dont_m]"
        }
    }
}

ad_change_password $user_id $password_1


set system_owner [ad_system_owner]
set system_name [ad_system_name]

set subject "[_ dotlrn.lt_Your_password_on_syst]"
set change_password_url [export_vars -base [ad_url]/user/password-update {user_id {password_old $password_1}}]
set body "[_ dotlrn.lt_Please_follow_the_fol]"

set email [acs_user::get_element -user_id $user_id -element email]

# Send email
ad_try {
    acs_mail_lite::send \
	-to_addr $email \
	-from_addr $system_owner \
	-subject $subject \
	-body $body
} on error {errorMsg} {
    ns_log Error "[_ dotlrn.lt_Error_sending_email_t] $errorMsg"
    ad_return_error \
	"[_ dotlrn.Error_sending_mail]" \
	"[_ dotlrn.lt_There_was_an_error_se]"
    ad_script_abort
}

set system_name [ad_system_name]
set admin_subject [_ dotlrn.lt_The_following_email_w]
set admin_message [_ dotlrn.lt_The_following_email_w_1]

ad_try {
    acs_mail_lite::send \
	-to_addr $system_owner \
	-from_addr $system_owner \
	-subject $admin_subject \
	-body $admin_message
} on error {errorMsg} {
    ns_log Error "Error sending email from password-update-2.tcl $errorMsg"
    ad_return_error \
	[_ dotlrn.Error_sending_mail] \
	[_ dotlrn.lt_There_was_an_error_se_1]
    ad_script_abort
}

if {$return_url eq ""} {
    set return_url "user?user_id=$user_id"
}

ad_returnredirect $return_url
ad_script_abort

#
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
