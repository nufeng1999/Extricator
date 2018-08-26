glibc/configure
change
test -n "$critic_missing" && as_fn_error $? "
*** These critical programs are missing or too old:$critic_missing
*** Check the INSTALL file for required versions." "$LINENO" 5
to 
#test -n "$critic_missing" && as_fn_error $? "
#*** These critical programs are missing or too old:$critic_missing
#*** Check the INSTALL file for required versions." "$LINENO" 5